//
//  File.swift
//  
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import Foundation
import MapKit

extension MKPolyline {
    convenience init(mapRect: MKMapRect) {
        let points = [
            MKMapPoint(x: mapRect.minX, y: mapRect.minY),
            MKMapPoint(x: mapRect.maxX, y: mapRect.minY),
            MKMapPoint(x: mapRect.maxX, y: mapRect.maxY),
            MKMapPoint(x: mapRect.minX, y: mapRect.maxY),
            MKMapPoint(x: mapRect.minX, y: mapRect.minY)
        ]
        self.init(points: points, count: points.count)
    }
}
