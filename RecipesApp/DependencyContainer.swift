//
//  DependencyContainer.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/15/25.
//

import Foundation

final class RecipesListContainer {
    private init() {}

    private let recipesURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!

    private let networkService = URLSession.shared

    lazy var repository: RecipeRepositoryProtocol = {
        RecipeRepository(url: recipesURL, service: networkService)
    }()

    private let imageCache: ImageCacheProtocol = NSImageCache()

    @MainActor
    private lazy var recipeViewModelFactory: RecipeViewModelFactory = {
        DefaultRecipeViewModelFactory(imageCache: imageCache, service: URLSession(configuration: .ephemeral))
    }()

    @MainActor
    static func composeRecipeList() -> RecipeListScreen {
        let container = RecipesListContainer()
        let repository = container.repository
        let useCase = FetchRecipesUseCase(repository: repository)
        let viewModel = RecipesListViewModel(getRecipesUseCase: useCase)

        return RecipeListScreen(recipeViewModelFactory: container.recipeViewModelFactory, viewModel: viewModel)
    }
}

extension URLSession: NetworkService {
}
