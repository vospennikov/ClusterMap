//
//  GetFirstCoordinateTests.swift
//
//
//  Created by Mikhail Vospennikov on 03.09.2023.
//

import Foundation
import MapKit
import XCTest
@testable import ClusterMap

final class GetFirstCoordinateTests: XCTestCase {
    func test_calculatePosition() {
        let sut = GetFirstCoordinate(fallback: StubFallbackAlignmentStrategy.zeroCoordinates)
        let coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 1, longitude: 1),
            CLLocationCoordinate2D(latitude: 2, longitude: 2),
            CLLocationCoordinate2D(latitude: 3, longitude: 3),
        ]

        let result = sut.calculatePosition(for: coordinates, within: .mediumRect)

        XCTAssertEqual(result, CLLocationCoordinate2D(latitude: 1, longitude: 1))
    }

    func test_calculatePosition_emptyInput_returnFallback() {
        let sut = GetFirstCoordinate(fallback: StubFallbackAlignmentStrategy.zeroCoordinates)
        let coordinates: [CLLocationCoordinate2D] = []

        let result = sut.calculatePosition(for: coordinates, within: .mediumRect)

        XCTAssertEqual(result, CLLocationCoordinate2D(latitude: 0, longitude: 0))
    }
}
