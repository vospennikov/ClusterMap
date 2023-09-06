//
//  GetNearCenterCoordinate.swift
//
//
//  Created by Mikhail Vospennikov on 06.07.2023.
//

import Foundation
import MapKit

struct GetNearCenterCoordinate: ClusterAlignmentStrategy {
    let clusterCenterPosition: GetCenterCoordinate

    func calculatePosition(
        for coordinates: [CLLocationCoordinate2D],
        within mapRect: MKMapRect
    ) -> CLLocationCoordinate2D {
        let centerCoordinate = clusterCenterPosition.calculatePosition(for: [], within: mapRect)
        let nearestCoordinate = coordinates.min {
            centerCoordinate.distance(from: $0) < centerCoordinate.distance(from: $1)
        }
        return nearestCoordinate ?? centerCoordinate
    }
}
