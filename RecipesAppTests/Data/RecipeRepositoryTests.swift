//
//  RepositoryTests.swift
//  RecipesAppTests
//
//  Created by Jose Alvarez on 3/14/25.
//

import XCTest

struct Recipe: Equatable {
    let id: UUID
    let name: String
    let cuisineType: String
    let smallPhotoURL: URL?
}

protocol NetworkService {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

enum RepositoryError: Error {
    case fetchError
}

class RecipeRepository {
    private let url: URL
    private let service: NetworkService
    
    init(url: URL, service: NetworkService) {
        self.url = url
        self.service = service
    }

    func loadRecipes() async throws -> [Recipe] {
        do {
            let (data, response) = try await service.data(from: url)

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw RepositoryError.fetchError
            }

            let root = try JSONDecoder().decode(RecipesRootApi.self, from: data)

            return try map(root: root)
        } catch {
            throw RepositoryError.fetchError
        }
    }

    private func map(root: RecipesRootApi) throws -> [Recipe] {
        guard let recipes = root.recipes else {
            // TODO: I don't recall business rules mentioning not receiving a recipes. I'll assum this is done on purpose for performance reasons and will return an empty array
            return []
        }

        guard !recipes.isEmpty  else {
            return []
        }

        let mappedRecipe = recipes.compactMap { recipe -> Recipe? in
            guard let cuisine = recipe.cuisine,
                  let name = recipe.name,
                  let id = recipe.uuid
            else {
                return nil
            }

            let url: URL? = if let urlString = recipe.photo_url_small {
                URL(string: urlString)
            } else {
                nil
            }

            return Recipe(id: id, name: name, cuisineType: cuisine, smallPhotoURL: url)
        }

        if recipes.count != mappedRecipe.count {
            throw RepositoryError.fetchError
        }

        return mappedRecipe
    }

    private struct RecipesRootApi: Decodable {
        let recipes: [RecipeAPI]?
    }

    private struct RecipeAPI: Decodable {
        let uuid: UUID?
        let name: String?
        let cuisine: String?
        let photo_url_small: String?
    }
}


final class RepositoryTests: XCTestCase {

    func test_onInit_doesNotRequestData() {
        let (_, mock) = makeSUT()

        XCTAssertEqual(mock.numberOfRequests, 0)
    }

    func test_loadRecipes_requestsData() async throws {
        let (sut, mock) = makeSUT()

        _ = try? await sut.loadRecipes()
        _ = try? await sut.loadRecipes()
        _ = try? await sut.loadRecipes()

        XCTAssertEqual(mock.numberOfRequests, 3)
    }

    func test_loadRecipes_throwsFetchErrorOnErrorThrowned() async throws {
        let (sut, _) = makeSUT(completeWith: .failure(NSError(domain: "any error", code: 0)))

        do {
            _ = try await sut.loadRecipes()

            XCTFail("Expected a throw, instead code executed successfully")
        } catch  {
            XCTAssertEqual(error as? RepositoryError, RepositoryError.fetchError, "Expected \(RepositoryError.fetchError) error, received \(error) instead")
        }
    }

    func test_loadRecipes_throwFetchErrorOnNon2xxHTTPStatusCode() async throws {
        let anyURL = URL(string: "google.com")!
        let statusCodes: [Int] = [199, 201, 400, 500]
        let recipes = getRecipes()
        let validJSONData = try JSONSerialization.data(withJSONObject: recipes.1, options: .prettyPrinted)

        for statusCode in statusCodes {
            let response = HTTPURLResponse(url: anyURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)!

            try await expect(expectedResult: .failure(RepositoryError.fetchError), when: .success((validJSONData, response)))
        }
    }

    func test_loadRecipes_throwFetchErrorOnNonHTTPURLResponse() async throws {
        let nonHTTPURLResponse = URLResponse()

        try await expect(expectedResult: .failure(RepositoryError.fetchError), when: .success((Data(), nonHTTPURLResponse)))
    }

    func test_loadRecipse_throwFetchErrorOnInvalidJSONError() async throws {
        let anyURL = URL(string: "google.com")!
        let response = HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let jsonData = "invalid json".data(using: .utf8)!

        try await expect(expectedResult: .failure(RepositoryError.fetchError), when: .success((jsonData, response)))

        let incompleteJSON = [
            "recipes": [
                [
                    "uuid": UUID().uuidString,
                    "cuisine": "Italian",
                ]
            ]
        ]

        let incompleteRecipes = try JSONSerialization.data(withJSONObject: incompleteJSON, options: .prettyPrinted)
        try await expect(expectedResult: .failure(RepositoryError.fetchError), when: .success((incompleteRecipes, response)))
    }

    func test_loadRecipes_deliversMappedRecipesOnSuccessfulResponseWithValidData() async throws {
        let anyURL = URL(string: "google.com")!
        let response = HTTPURLResponse(url: anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let recipes = getRecipes()
        let jsonData = try JSONSerialization.data(withJSONObject: recipes.1, options: .prettyPrinted)

        try await expect(expectedResult: .success(recipes.0), when: .success((jsonData, response)))
    }

    private func makeSUT(completeWith result: Result<(Data, URLResponse), Error> = .success((Data(), URLResponse()))) -> (RecipeRepository, MockService) {
        let url = URL(string: "https://any-url.com")!
        let mock = MockService(result: result)
        let sut = RecipeRepository(url: url, service: mock)

        trackForMemoryLeaks(object: mock)
        trackForMemoryLeaks(object: sut)

        return (sut, mock)
    }

    private func expect(
        expectedResult: Result<[Recipe], RepositoryError>,
        when serviceResult: Result<(Data, URLResponse), Error>,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async throws {
        let (sut, _) = makeSUT(completeWith: serviceResult)

        do {
            let recipes = try await sut.loadRecipes()
            let capturedResult = Result<[Recipe], RepositoryError>.success(recipes)

            XCTAssertEqual(capturedResult, expectedResult, "Expected \(expectedResult), received \(capturedResult) instead", file: file, line: line)
        } catch  {
            let capturedResult = Result<[Recipe], RepositoryError>.failure(error as! RepositoryError)
            XCTAssertEqual(capturedResult, expectedResult, "Expected \(expectedResult), received \(capturedResult) instead", file: file, line: line)
        }
    }

    private func getRecipes() -> ([Recipe], [String: [[String: String]]]) {
        let recipe1 = validRecipe(id: UUID())
        let recipe2 = validRecipe(id: UUID())
        let recipe3 = validRecipe(id: UUID())
        let recipe4 = validRecipe(id: UUID())

        let recipesDict = [
            "recipes": [
                recipe1.1,
                recipe2.1,
                recipe3.1,
                recipe4.1
            ]
        ]

        return ([recipe1.0, recipe2.0, recipe3.0, recipe4.0], recipesDict)
    }

    private func validRecipe(
        id: UUID = UUID(),
        name: String = "any name",
        cuisineType: String = "any cuisine",
        smallImageUrl: URL = URL(string: "any-url.com")!
    ) -> (Recipe, [String: String]) {
        let dictionary: [String: String] = [
            "uuid": id.uuidString,
            "name": name,
            "cuisine": cuisineType,
            "photo_url_small": smallImageUrl.absoluteString
        ]

        let recipe = Recipe(id: id, name: name, cuisineType: cuisineType, smallPhotoURL: smallImageUrl)

        return (recipe, dictionary)
    }

    class MockService: NetworkService {
        private let result: Result<(Data, URLResponse), Error>

        var numberOfRequests = 0

        init(result: Result<(Data, URLResponse), Error>) {
            self.result = result
        }

        func data(from url: URL) async throws -> (Data, URLResponse) {
            numberOfRequests += 1

            switch result {
                case .success(let (data, response)):
                return (data, response)
            case .failure(let error):
                throw error
            }
        }
    }
}
