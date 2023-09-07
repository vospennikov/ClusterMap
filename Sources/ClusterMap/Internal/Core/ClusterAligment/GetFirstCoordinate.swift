//
//  GetFirstCoordinate.swift
//
//
//  Created by Mikhail Vospennikov on 06.07.2023.
//

import Foundation
import MapKit

struct GetFirstCoordinate: ClusterAlignmentStrategy {
    let fallback: ClusterAlignmentStrategy

    func calculatePosition(
        for coordinates: [CLLocationCoordinate2D],
        within mapRect: MKMapRect
    ) -> CLLocationCoordinate2D {
        coordinates.first ?? fallback.calculatePosition(for: coordinates, within: mapRect)
    }
}
