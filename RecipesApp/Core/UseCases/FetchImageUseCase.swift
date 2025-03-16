//
//  FetchImageUseCase.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/16/25.
//

import Foundation

final class FetchImageUseCase: FetchImageUseCaseProtocol {
    private let cache: ImageCacheProtocol
    private let repository: ImageRepositoryProtocol
    
    init(cache: ImageCacheProtocol, repository: ImageRepositoryProtocol) {
        self.cache = cache
        self.repository = repository
    }
    
    func callAsFunction(url: URL) async throws -> Data {
        if let cachedData = try? await cache.data(for: url.absoluteString) {
            return cachedData
        }

        let data = try await repository.loadImage(url: url)

        try await cache.setData(_data: data, for: url.absoluteString)
        
        return data

    }
}
