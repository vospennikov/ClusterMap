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
    
    func calculatePosition(for annotations: [MKAnnotation], within mapRect: MKMapRect) -> CLLocationCoordinate2D {
        guard let first = annotations.first else {
            return fallback.calculatePosition(for: annotations, within: mapRect)
        }
        return first.coordinate
    }
}
