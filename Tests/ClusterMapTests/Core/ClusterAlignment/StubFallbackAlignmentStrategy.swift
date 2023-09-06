//
//  StubFallbackAlignmentStrategy.swift
//
//
//  Created by Mikhail Vospennikov on 03.09.2023.
//

import ClusterMap
import Foundation
import MapKit

struct StubFallbackAlignmentStrategy: ClusterAlignmentStrategy {
    var stubCalculatePosition: CLLocationCoordinate2D
    func calculatePosition(
        for coordinates: [CLLocationCoordinate2D],
        within mapRect: MKMapRect
    ) -> CLLocationCoordinate2D {
        stubCalculatePosition
    }
}

extension StubFallbackAlignmentStrategy {
    static let zeroCoordinates = StubFallbackAlignmentStrategy(stubCalculatePosition: CLLocationCoordinate2D(
        latitude: 0,
        longitude: 0
    ))
}
