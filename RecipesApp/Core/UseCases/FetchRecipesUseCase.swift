//
//  FetchRecipesUseCase.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/14/25.
//

final class FetchRecipesUseCase: FetchRecipesUseCaseProtocol {
    private let repository: RecipeRepositoryProtocol

    init(repository: RecipeRepositoryProtocol) {
        self.repository = repository
    }

    func callAsFunction() async throws -> [Recipe] {
        try await repository.loadRecipes()
    }
}
