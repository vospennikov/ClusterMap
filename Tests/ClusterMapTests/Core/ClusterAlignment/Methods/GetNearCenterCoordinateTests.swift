//
//  GetNearCenterCoordinateTests.swift
//
//
//  Created by Mikhail Vospennikov on 03.09.2023.
//

import Foundation
import MapKit
import XCTest
@testable import ClusterMap

final class GetNearCenterCoordinateTests: XCTestCase {
    func test_calculatePosition() {
        let sut = GetNearCenterCoordinate(clusterCenterPosition: GetCenterCoordinate())
        let coordinates: [CLLocationCoordinate2D] = [
            MKMapPoint(x: MKMapRect.mediumRect.minX, y: MKMapRect.mediumRect.minY).coordinate,
            MKMapPoint(x: MKMapRect.mediumRect.maxX, y: MKMapRect.mediumRect.maxY).coordinate,
            MKMapPoint(x: MKMapRect.mediumRect.midX, y: MKMapRect.mediumRect.midY).coordinate,
        ]

        let result = sut.calculatePosition(for: coordinates, within: .mediumRect)
        let expectedResult = MKMapPoint(x: MKMapRect.mediumRect.midX, y: MKMapRect.mediumRect.midY).coordinate

        XCTAssertEqual(result, expectedResult)
    }

    func test_calculatePosition_emptyInput_returnFallback() {
        let sut = GetNearCenterCoordinate(clusterCenterPosition: GetCenterCoordinate())
        let coordinates: [CLLocationCoordinate2D] = []

        let result = sut.calculatePosition(for: coordinates, within: .mediumRect)
        let expectedResult = MKMapPoint(x: MKMapRect.mediumRect.midX, y: MKMapRect.mediumRect.midY).coordinate

        XCTAssertEqual(result, expectedResult)
    }
}
