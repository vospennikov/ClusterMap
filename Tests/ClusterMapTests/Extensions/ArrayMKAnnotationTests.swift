//
//  ArrayMKAnnotationTests.swift
//
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import CoreLocation
import Foundation
import MapKit
import XCTest
@testable import ClusterMap

final class ArrayMKAnnotationTests: XCTestCase {
    func test_subtracted() {
        let annotation1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.1, longitude: -122.1))
        let annotation2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.2, longitude: -122.2))
        let annotation3 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.3, longitude: -122.3))

        let annotations = [annotation1, annotation2, annotation3]
        let otherAnnotations = [annotation1, annotation3]
        let expectedResult = [annotation2]

        let result = annotations.subtracted(otherAnnotations)

        XCTAssertEqual(result, expectedResult)
    }

    func test_subtract() {
        let annotation1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.1, longitude: -122.1))
        let annotation2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.2, longitude: -122.2))
        let annotation3 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.3, longitude: -122.3))

        var annotations = [annotation1, annotation2, annotation3]
        let otherAnnotations = [annotation1, annotation3]
        let expectedResult = [annotation2]

        annotations.subtract(otherAnnotations)

        XCTAssertEqual(annotations, expectedResult)
    }

    func test_add() {
        let annotation1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.1, longitude: -122.1))
        let annotation2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.2, longitude: -122.2))
        let annotation3 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.3, longitude: -122.3))
        let annotation4 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.4, longitude: -122.4))

        var annotations = [annotation1, annotation2]
        let otherAnnotations = [annotation3, annotation4]

        let expectedResult = [annotation1, annotation2, annotation3, annotation4]

        annotations.add(otherAnnotations)

        XCTAssertEqual(annotations, expectedResult)
    }

    func test_remove() throws {
        let annotation1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.1, longitude: -122.1))
        let annotation2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.2, longitude: -122.2))

        var annotations = [annotation1, annotation2]

        XCTAssertEqual(annotation2, try XCTUnwrap(annotations.remove(annotation2)))
        XCTAssertEqual(annotations, [annotation1])

        XCTAssertEqual(annotation1, try XCTUnwrap(annotations.remove(annotation1)))
        XCTAssertEqual(annotations, [])

        XCTAssertEqual(nil, annotations.remove(annotation1))
        XCTAssertEqual(annotations, [])
    }
}
