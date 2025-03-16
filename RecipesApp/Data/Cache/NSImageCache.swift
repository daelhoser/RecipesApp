//
//  NSImageCache.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/16/25.
//

import Foundation

final class NSImageCache: ImageCacheProtocol {
    func data(for url: String) async throws -> Data? {
        nil
    }
    
    func setData(_data: Data, for url: String) async throws {
    }
}
