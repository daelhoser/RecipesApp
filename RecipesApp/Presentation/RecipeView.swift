//
//  RecipeView.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/15/25.
//

import SwiftUI

struct RecipeView: View {
    private let recipe: Recipe

    init(recipe: Recipe) {
        self.recipe = recipe
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8.0) {
            image

            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(recipe.cuisineType)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }

    @ViewBuilder
    private var image: some View {
        if let imageURL = recipe.smallPhotoURL {
            AsyncImage(url: imageURL)
                .frame(width: 100, height: 100)
                .clipped()
        } else {
            Image(systemName: "fork.knife.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .background(Color.gray)
        }
    }
}

