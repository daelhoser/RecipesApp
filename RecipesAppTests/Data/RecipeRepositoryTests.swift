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
    private let service: NetworkService
    
    init(service: NetworkService) {
        self.service = service
    }
}


final class RepositoryTests: XCTestCase {

    func test_onInit_doesNotRequestData() {
        let mock = MockServiceSpy()
        let sut = RecipeRepository(service: mock)

        XCTAssertEqual(mock.numberOfRequests, 0)
    }

    class MockServiceSpy: NetworkService {
        var numberOfRequests = 0
        
        func data(from url: URL) async throws -> (Data, URLResponse) {
            numberOfRequests += 1

            return (Data(), URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil))
        }
    }
}
