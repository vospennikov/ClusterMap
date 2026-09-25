//
//  XCTestCase+MemoryLeak.swift
//
//
//  Created by Mikhail Vospennikov on 26.01.2023.
//

import Foundation
import XCTest

public extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        nonisolated(unsafe) weak let weakInstance = instance
        addTeardownBlock {
            XCTAssertNil(
                weakInstance,
                "Instance should have been deallocated. Potential memory leak.",
                file: file,
                line: line
            )
        }
    }
}
