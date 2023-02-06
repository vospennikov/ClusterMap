//
//  FloatingPointTests.swift
//  
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import XCTest
import Foundation
@testable import Cluster

final class FloatingPointTests: XCTestCase {
    func test_isNearlyEqual() {
        XCTAssertTrue((1.0).isNearlyEqual(to: 1.0 + 0.5 * .ulpOfOne))
        XCTAssertTrue((1.0).isNearlyEqual(to: 1.0 + 0.9 * .ulpOfOne))
        XCTAssertTrue((1.0).isNearlyEqual(to: 1.0 + 1.1 * .ulpOfOne))
        XCTAssertFalse((0.0).isNearlyEqual(to: 0.5 * .ulpOfOne))
        XCTAssertFalse((0.0).isNearlyEqual(to: 2.0 * .ulpOfOne))
    }
}
