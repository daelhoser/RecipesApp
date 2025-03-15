//
//  FetchRecipesUseCaseProtocol.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/14/25.
//

protocol FetchRecipesUseCaseProtocol {
    func callAsFunction() async throws -> [Recipe]
}
