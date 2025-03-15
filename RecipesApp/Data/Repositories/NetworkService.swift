//
//  NetworkService.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/14/25.
//

import Foundation

public protocol NetworkService {
    func data(from url: URL) async throws -> (Data, URLResponse)
}
