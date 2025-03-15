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


    @MainActor
    static func composeRecipeList() -> RecipeListScreen {
        let repository = RecipesListContainer().repository
        let useCase = FetchRecipesUseCase(repository: repository)
        let viewModel = RecipesListViewModel(getRecipesUseCase: useCase)

        return RecipeListScreen(viewModel: viewModel)
    }
}

extension URLSession: NetworkService {
}
