//
//  RecipesListViewModel.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/14/25.
//

import Foundation

enum LoadingState {
    case idle
    case loading
    case loaded
    case error
}

@MainActor
final class RecipesListViewModel: ObservableObject {
    private let getRecipesUseCase: FetchRecipesUseCaseProtocol

    @Published var loadingState: LoadingState = .idle

    var recipes: [Recipe]?

    init(getRecipesUseCase: FetchRecipesUseCaseProtocol) {
        self.getRecipesUseCase = getRecipesUseCase
    }

    func loadRecipes() async {
        loadingState = .loading

        do {
            recipes = try await getRecipesUseCase()
            loadingState = .loaded
        } catch {
            loadingState = .error
        }
    }
}
