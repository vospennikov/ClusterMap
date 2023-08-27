//
//  CLLocationCoordinate2DTests.swift
//
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import CoreLocation
import Foundation
import XCTest
@testable import ClusterMap

final class CLLocationCoordinate2DTests: XCTestCase {
    func test_hashable() {
        let coordinate1 = CLLocationCoordinate2D(latitude: 37.3_316_851, longitude: -122.0_300_674)
        let coordinate2 = CLLocationCoordinate2D(latitude: 37.3_316_851, longitude: -122.0_300_674)
        let coordinate3 = CLLocationCoordinate2D(latitude: 37.3_316_941, longitude: -122.0_300_684)

        XCTAssertEqual(coordinate1.hashValue, coordinate2.hashValue)
        XCTAssertNotEqual(coordinate1.hashValue, coordinate3.hashValue)
    }

    func test_equatable() {
        let coordinate1 = CLLocationCoordinate2D(
            latitude: 37.0_000_000_000_000_001,
            longitude: -122.0_000_000_000_000_001
        )
        let coordinate2 = CLLocationCoordinate2D(
            latitude: 37.0_000_000_000_000_002,
            longitude: -122.0_000_000_000_000_002
        )
        let coordinate3 = CLLocationCoordinate2D(
            latitude: 37.1_000_000_000_000_001,
            longitude: -122.1_000_000_000_000_001
        )
        let coordinate4 = CLLocationCoordinate2D(
            latitude: 37.2_000_000_000_000_001,
            longitude: -122.2_000_000_000_000_001
        )

        XCTAssertEqual(coordinate1, coordinate2)
        XCTAssertNotEqual(coordinate1, coordinate3)
        XCTAssertNotEqual(coordinate3, coordinate4)
    }

    func test_coordinateOnBearingInRadiansAtDistanceInMeters() {
        let coordinate = CLLocationCoordinate2D(latitude: 37.3_316_851, longitude: -122.0_300_674)
        let resultCoordinate = coordinate.coordinate(onBearingInRadians: 0.5, atDistanceInMeters: 1000)

        XCTAssertEqual(resultCoordinate.latitude, 37.33_957_503_970_442, accuracy: 0.0_000_001)
        XCTAssertEqual(resultCoordinate.longitude, -122.02_464_593_514_087, accuracy: 0.0_000_001)
    }
}
