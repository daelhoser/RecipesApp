//
//  RecipeListScreen.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/14/25.
//

import SwiftUI

@MainActor
protocol RecipeViewModelFactory {
    func getViewModel(for recipe: Recipe) -> RecipeViewModel
}

final class DefaultRecipeViewModelFactory: RecipeViewModelFactory {
    private let imageCache: ImageCacheProtocol
    private let service: NetworkService

    init(imageCache: ImageCacheProtocol, service: NetworkService) {
        self.imageCache = imageCache
        self.service = service
    }

    @MainActor
    func getViewModel(for recipe: Recipe) -> RecipeViewModel {
        let repository = ImageRepository(service: service)
        let useCase = FetchImageUseCase(cache: imageCache, repository: repository)

        return RecipeViewModel(recipe: recipe, fetchImageUseCase: useCase)
    }
}

struct RecipeListScreen: View {
    let recipeViewModelFactory: RecipeViewModelFactory
    @StateObject var viewModel: RecipesListViewModel

    var body: some View {
        switch viewModel.loadingState {
        case .idle, .loading:
            ProgressView()
                .task {
                    await viewModel.loadRecipes()
                }
        case .loaded:
            if let recipes = viewModel.recipes {
                List {
                    ForEach(recipes, id: \.id) { recipe in
                        RecipeView(viewModel: recipeViewModelFactory.getViewModel(for: recipe))
                    }
                }
            } else {
                Button("No recipes. try again") {

                }
            }
        case .error:
            Text("Error loading recipes.")
        }
    }
}

//#Preview {
//    RecipeListScreen()
//}
