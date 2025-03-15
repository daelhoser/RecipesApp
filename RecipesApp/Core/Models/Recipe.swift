//
//  Recipe.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/14/25.
//

import Foundation

public struct Recipe: Equatable {
    public let id: UUID
    public let name: String
    public let cuisineType: String
    public let smallPhotoURL: URL?

    public init(id: UUID, name: String, cuisineType: String, smallPhotoURL: URL?) {
        self.id = id
        self.name = name
        self.cuisineType = cuisineType
        self.smallPhotoURL = smallPhotoURL
    }
}
