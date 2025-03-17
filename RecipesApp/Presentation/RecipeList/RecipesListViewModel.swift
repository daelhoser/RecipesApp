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
    private var task: Task<(), Never>?

    @Published var loadingState: LoadingState = .idle

    var recipes: [Recipe]?

    init(getRecipesUseCase: FetchRecipesUseCaseProtocol) {
        self.getRecipesUseCase = getRecipesUseCase
    }

    func loadRecipes() async {
        guard task == nil else { return }

        loadingState = .loading

        do {
            recipes = try await getRecipesUseCase()
            loadingState = .loaded
            task = nil
        } catch {
            loadingState = .error
        }
    }

    func reloadRecipes() {
        task = Task {
            await loadRecipes()
        }
    }
}
