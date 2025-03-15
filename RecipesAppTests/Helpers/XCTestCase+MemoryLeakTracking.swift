//
//  XCTestCase+MemoryLeakTracking.swift
//  RecipesApp
//
//  Created by Jose Alvarez on 3/14/25.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(object: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(object, "Object should be deallocated", file: file, line: line)
        }
    }
}
