//
//  RecipeViewModelFactory.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/16/25.
//

import Foundation

@MainActor
protocol RecipeViewModelFactory {
    func getViewModel(for recipe: Recipe) -> RecipeViewModel
}
