//
//  RecipeView.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/15/25.
//

import SwiftUI

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

