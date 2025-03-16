//
//  DefaultRecipeViewModelFactory.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/16/25.
//

import Foundation


final class DefaultRecipeViewModelFactory: RecipeViewModelFactory {
    private let imageCache: ImageCacheProtocol
    private let service: NetworkService

    init(imageCache: ImageCacheProtocol, service: NetworkService) {
        self.imageCache = imageCache
        self.service = service
    }

    @MainActor
    func getViewModel(for recipe: Recipe) -> RecipeViewModel {
        let repository = ImageRepository(service: service)
        let useCase = FetchImageUseCase(cache: imageCache, repository: repository)

        return RecipeViewModel(recipe: recipe, fetchImageUseCase: useCase)
    }
}
