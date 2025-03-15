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
        let url = URL(string: "https://any-url.com")!
        let mock = MockServiceSpy()
        _ = RecipeRepository(url: url, service: mock)

        XCTAssertEqual(mock.numberOfRequests, 0)
    }

    func test_loadRecipes_requestsData() async throws {
        let url = URL(string: "https://any-url.com")!
        let mock = MockServiceSpy()
        let sut = RecipeRepository(url: url, service: mock)

        _ = try await sut.loadRecipes()
        _ = try await sut.loadRecipes()
        _ = try await sut.loadRecipes()

        XCTAssertEqual(mock.numberOfRequests, 3)
    }


    class MockServiceSpy: NetworkService {
        var numberOfRequests = 0
        
        func data(from url: URL) async throws -> (Data, URLResponse) {
            numberOfRequests += 1

            return (Data(), URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil))
        }
    }
}
