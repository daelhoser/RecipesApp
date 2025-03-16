//
//  RecipeListScreen.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/14/25.
//

import SwiftUI

struct RecipeListScreen: View {
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

                        // TODO: TEMP Code
                        RecipeView(viewModel: RecipeViewModel(recipe: recipe, fetchImageUseCase: FetchImageUseCase(cache: NSImageCache(), repository: ImageRepository(service: URLSession(configuration: .ephemeral)
))))
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
