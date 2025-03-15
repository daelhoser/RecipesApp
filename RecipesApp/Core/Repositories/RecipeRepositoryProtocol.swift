//
//  RecipeRepositoryProtocol.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/14/25.
//

protocol RecipeRepositoryProtocol {
    func loadRecipes() async throws -> [Recipe]
}
