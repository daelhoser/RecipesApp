//
//  NSImageCache.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/16/25.
//

import Foundation

final class NSImageCache: ImageCacheProtocol {
    let cache: NSCache<NSString, NSData>

    // TODO: I want to point out that since this is a infrastructure component, this component (wrapper) should be as dumb as possible, meaning only perform crud operations, no business rules and no customization needs to be done to NSCache then, in my opinion)
    init(cache: NSCache<NSString, NSData> = NSCache()) {
        self.cache = cache
    }

    func data(for url: String) async throws -> Data? {
        cache.object(forKey: url as NSString) as Data?
    }

    func setData(_data: Data, for url: String) async throws {
        cache.setObject(NSData(data: _data), forKey: url as NSString)
    }
}
