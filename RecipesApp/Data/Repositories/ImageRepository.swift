//
//  ImageRepository.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/16/25.
//

import Foundation

final class ImageRepository: ImageRepositoryProtocol {
    private let service: NetworkService

    init(service: NetworkService) {
        self.service = service
    }

    func loadImage(url: URL) async throws -> Data {
        do {
            let (data, response) = try await service.data(from: url)

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw ImageRepositoryError.fetchError
            }

            return data

        } catch {
            throw ImageRepositoryError.fetchError
        }
    }
}
