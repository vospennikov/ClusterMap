//
//  MKMapRect+Additions.swift
//
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import Foundation
import MapKit

extension MKMapRect {
    init(minX: Double, minY: Double, maxX: Double, maxY: Double) {
        self.init(x: minX, y: minY, width: abs(maxX - minX), height: abs(maxY - minY))
    }

    init(x: Double, y: Double, width: Double, height: Double) {
        self.init(origin: MKMapPoint(x: x, y: y), size: MKMapSize(width: width, height: height))
    }

    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        contains(MKMapPoint(coordinate))
    }

    init(region: MKCoordinateRegion) {
        let center = region.center
        let span = region.span
        let topLeft = CLLocationCoordinate2D(
            latitude: center.latitude + span.latitudeDelta * 0.5,
            longitude: center.longitude - span.longitudeDelta * 0.5
        )
        let bottomRight = CLLocationCoordinate2D(
            latitude: center.latitude - span.latitudeDelta * 0.5,
            longitude: center.longitude + span.longitudeDelta * 0.5
        )
        let topLeftPoint = MKMapPoint(topLeft)
        let bottomRightPoint = MKMapPoint(bottomRight)

        self.init(
            x: min(topLeftPoint.x, bottomRightPoint.x),
            y: min(topLeftPoint.y, bottomRightPoint.y),
            width: abs(topLeftPoint.x - bottomRightPoint.x),
            height: abs(topLeftPoint.y - bottomRightPoint.y)
        )
    }
}
