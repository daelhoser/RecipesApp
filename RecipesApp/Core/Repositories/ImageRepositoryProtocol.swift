//
//  ImageRepositoryProtocol.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/16/25.
//

import Foundation

protocol ImageRepositoryProtocol {
    func loadImage(url: URL) async throws -> Data
}
