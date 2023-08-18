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

    func calculatePosition(for annotations: [MKAnnotation], within mapRect: MKMapRect) -> CLLocationCoordinate2D {
        let centerCoordinate = clusterCenterPosition.calculatePosition(for: [], within: mapRect)
        let nearestAnnotation = annotations.min {
            centerCoordinate.distance(from: $0.coordinate) < centerCoordinate.distance(from: $1.coordinate)
        }
        return nearestAnnotation?.coordinate ?? centerCoordinate
    }
}
