//
//  RecipeRepository.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/14/25.
//

import Foundation

public final class RecipeRepository: RecipeRepositoryProtocol {
    private let url: URL
    private let service: NetworkService
    
    public init(url: URL, service: NetworkService) {
        self.url = url
        self.service = service
    }

    public func loadRecipes() async throws -> [Recipe] {
        do {
            let (data, response) = try await service.data(from: url)

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                throw RepositoryError.fetchError
            }

            let root = try JSONDecoder().decode(RecipesRootApi.self, from: data)

            return try map(root: root)
        } catch {
            throw RepositoryError.fetchError
        }
    }

    private func map(root: RecipesRootApi) throws -> [Recipe] {
        guard let recipes = root.recipes else {
            // TODO: I don't recall business rules mentioning not receiving a recipes. I'll assum this is done on purpose for performance reasons and will return an empty array
            return []
        }

        guard !recipes.isEmpty  else {
            return []
        }

        let mappedRecipe = recipes.compactMap { recipe -> Recipe? in
            guard let cuisine = recipe.cuisine,
                  let name = recipe.name,
                  let id = recipe.uuid
            else {
                return nil
            }

            let url: URL? = if let urlString = recipe.photo_url_small {
                URL(string: urlString)
            } else {
                nil
            }

            return Recipe(id: id, name: name, cuisineType: cuisine, smallPhotoURL: url)
        }

        if recipes.count != mappedRecipe.count {
            throw RepositoryError.fetchError
        }

        return mappedRecipe
    }

    private struct RecipesRootApi: Decodable {
        let recipes: [RecipeAPI]?
    }

    private struct RecipeAPI: Decodable {
        let uuid: UUID?
        let name: String?
        let cuisine: String?
        let photo_url_small: String?
    }
}
