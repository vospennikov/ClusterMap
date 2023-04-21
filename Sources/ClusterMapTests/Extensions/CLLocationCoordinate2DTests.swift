//
//  CLLocationCoordinate2DTests.swift
//  
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import XCTest
import Foundation
import CoreLocation
@testable import ClusterMap

final class CLLocationCoordinate2DTests: XCTestCase {
    func test_hashable() {
        let coordinate1 = CLLocationCoordinate2D(latitude: 37.3316851, longitude: -122.0300674)
        let coordinate2 = CLLocationCoordinate2D(latitude: 37.3316851, longitude: -122.0300674)
        let coordinate3 = CLLocationCoordinate2D(latitude: 37.3316941, longitude: -122.0300684)
        
        XCTAssertEqual(coordinate1.hashValue, coordinate2.hashValue)
        XCTAssertNotEqual(coordinate1.hashValue, coordinate3.hashValue)
    }
    
    func test_equatable() {
        let coordinate1 = CLLocationCoordinate2D(latitude: 37.0000000000000001, longitude: -122.0000000000000001)
        let coordinate2 = CLLocationCoordinate2D(latitude: 37.0000000000000002, longitude: -122.0000000000000002)
        let coordinate3 = CLLocationCoordinate2D(latitude: 37.1000000000000001, longitude: -122.1000000000000001)
        let coordinate4 = CLLocationCoordinate2D(latitude: 37.2000000000000001, longitude: -122.2000000000000001)
        
        XCTAssertEqual(coordinate1, coordinate2)
        XCTAssertNotEqual(coordinate1, coordinate3)
        XCTAssertNotEqual(coordinate3, coordinate4)
    }
    
    func test_coordinateOnBearingInRadiansAtDistanceInMeters() {
        let coordinate = CLLocationCoordinate2D(latitude: 37.3316851, longitude: -122.0300674)
        let resultCoordinate = coordinate.coordinate(onBearingInRadians: 0.5, atDistanceInMeters: 1000)
        
        XCTAssertEqual(resultCoordinate.latitude, 37.33957503970442, accuracy: 0.0000001)
        XCTAssertEqual(resultCoordinate.longitude, -122.02464593514087, accuracy: 0.0000001)
    }
}
