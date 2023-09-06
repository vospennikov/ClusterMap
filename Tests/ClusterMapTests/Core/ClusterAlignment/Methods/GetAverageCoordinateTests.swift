//
//  GetAverageCoordinateTests.swift
//
//
//  Created by Mikhail Vospennikov on 03.09.2023.
//

import Foundation
import MapKit
import XCTest
@testable import ClusterMap

final class GetAverageCoordinateTests: XCTestCase {
    func test_calculatePosition() {
        let sut = GetAverageCoordinate()
        let coordinates: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 1, longitude: 1),
            CLLocationCoordinate2D(latitude: 2, longitude: 2),
            CLLocationCoordinate2D(latitude: 3, longitude: 3),
        ]

        let result = sut.calculatePosition(for: coordinates, within: .mediumRect)
        let expectedResult = CLLocationCoordinate2D(latitude: 2, longitude: 2)

        XCTAssertEqual(result, expectedResult)
    }
}
