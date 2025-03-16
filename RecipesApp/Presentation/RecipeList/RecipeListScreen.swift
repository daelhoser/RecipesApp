//
//  RecipeListScreen.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/14/25.
//

import SwiftUI

struct RecipeListScreen: View {
    let recipeViewModelFactory: RecipeViewModelFactory
    @StateObject var viewModel: RecipesListViewModel

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.loadingState {
                case .idle, .loading:
                    ProgressView()
                        .task {
                            await viewModel.loadRecipes()
                        }
                case .loaded:
                    if let recipes = viewModel.recipes, !recipes.isEmpty {
                        List {
                            ForEach(recipes, id: \.id) { recipe in
                                RecipeView(viewModel: recipeViewModelFactory.getViewModel(for: recipe))
                            }
                        }
                    } else {
                        Text("No Recipes Found")
                    }
                case .error:
                    Button("Error loading recipes. try again") {
                        Task {
                            await viewModel.loadRecipes()
                        }
                    }
                }
            }
                .navigationTitle("Recipes")
        }
    }
}

//#Preview {
//    RecipeListScreen()
//}
