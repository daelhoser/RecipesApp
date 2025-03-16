//
//  ImageCacheProtocol.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/16/25.
//

import Foundation

protocol ImageCacheProtocol {
    func data(for url: String) async throws -> Data?
    func setData(_data: Data, for url: String) async throws
}
