//
//  GetAverageCoordinate.swift
//
//
//  Created by Mikhail Vospennikov on 06.07.2023.
//

import Foundation
import MapKit

struct GetAverageCoordinate: ClusterAlignmentStrategy {
    func calculatePosition(
        for coordinates: [CLLocationCoordinate2D],
        within mapRect: MKMapRect
    ) -> CLLocationCoordinate2D {
        let totals = coordinates.reduce(into: (latitude: 0.0, longitude: 0.0)) {
            total, location in
            total.latitude += location.latitude
            total.longitude += location.longitude
        }
        return CLLocationCoordinate2D(
            latitude: totals.latitude / Double(coordinates.count),
            longitude: totals.longitude / Double(coordinates.count)
        )
    }
}
