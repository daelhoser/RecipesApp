//
//  RecipeView.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/15/25.
//

import SwiftUI

protocol ImageRepositoryProtocol {
    func loadImage(url: URL) async throws -> Data
}

enum ImageRepositoryError: Error {
    case fetchError
}

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

protocol ImageCacheProtocol {
    func data(for url: String) async throws -> Data?
    func setData(_data: Data, for url: String) async throws
}

final class NSImageCache: ImageCacheProtocol {
    func data(for url: String) async throws -> Data? {
        nil
    }
    
    func setData(_data: Data, for url: String) async throws {
    }
}

protocol FetchImageUseCaseProtocol {
    func callAsFunction(url: URL) async throws -> Data
}

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

@MainActor
final class RecipeViewModel: ObservableObject {
    private let recipe: Recipe
    private let fetchImageUseCase: FetchImageUseCaseProtocol

    var name: String {
        recipe.name
    }

    var cuisineType: String {
        recipe.cuisineType
    }

    @Published var imageData: Data?

    init(recipe: Recipe, fetchImageUseCase: FetchImageUseCaseProtocol) {
        self.recipe = recipe
        self.fetchImageUseCase = fetchImageUseCase
    }

    func loadImage() async {
        guard let url = recipe.smallPhotoURL else { return }

        imageData = try? await fetchImageUseCase(url: url)
    }
}

struct RecipeView: View {
    @StateObject var viewModel: RecipeViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 8.0) {
            image

            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(viewModel.cuisineType)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .task {
            await viewModel.loadImage()
        }
    }

    @ViewBuilder
    private var image: some View {
        if let imageData = viewModel.imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .frame(width: 100, height: 100)
                .clipped()
        } else {
            VStack {
                Image(systemName: "fork.knife.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            .frame(width: 100, height: 100)
            .background(Color.gray)
        }
    }
}

