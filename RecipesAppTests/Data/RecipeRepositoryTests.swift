//
//  RepositoryTests.swift
//  RecipesAppTests
//
//  Created by Jose Alvarez on 3/14/25.
//

import XCTest

protocol NetworkService {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

class RecipeRepository {
    private let url: URL
    private let service: NetworkService
    
    init(url: URL, service: NetworkService) {
        self.url = url
        self.service = service
    }

    func loadRecipes() async throws {
        _ = try await service.data(from: url)
    }
}


final class RepositoryTests: XCTestCase {

    func test_onInit_doesNotRequestData() {
        let (_, mock) = makeSUT()

        XCTAssertEqual(mock.numberOfRequests, 0)
    }

    func test_loadRecipes_requestsData() async throws {
        let (sut, mock) = makeSUT()

        _ = try await sut.loadRecipes()
        _ = try await sut.loadRecipes()
        _ = try await sut.loadRecipes()

        XCTAssertEqual(mock.numberOfRequests, 3)
    }

    private func makeSUT() -> (RecipeRepository, MockService) {
        let url = URL(string: "https://any-url.com")!
        let mock = MockService()
        let sut = RecipeRepository(url: url, service: mock)

        return (sut, mock)
    }


    class MockService: NetworkService {
        var numberOfRequests = 0
        
        func data(from url: URL) async throws -> (Data, URLResponse) {
            numberOfRequests += 1

            return (Data(), URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil))
        }
    }
}
