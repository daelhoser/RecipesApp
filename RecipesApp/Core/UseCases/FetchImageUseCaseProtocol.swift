//
//  FetchImageUseCaseProtocol.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/16/25.
//

import Foundation

protocol FetchImageUseCaseProtocol {
    func callAsFunction(url: URL) async throws -> Data
}
