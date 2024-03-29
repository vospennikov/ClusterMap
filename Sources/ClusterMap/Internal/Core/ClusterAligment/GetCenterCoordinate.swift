//
//  GetCenterCoordinate.swift
//
//
//  Created by Mikhail Vospennikov on 06.07.2023.
//

import Foundation
import MapKit

struct GetCenterCoordinate: ClusterAlignmentStrategy {
    func calculatePosition(
        for coordinates: [CLLocationCoordinate2D],
        within mapRect: MKMapRect
    ) -> CLLocationCoordinate2D {
        MKMapPoint(x: mapRect.midX, y: mapRect.midY).coordinate
    }
}
