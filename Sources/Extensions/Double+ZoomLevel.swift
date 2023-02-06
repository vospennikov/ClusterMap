//
//  File.swift
//  
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import Foundation
import MapKit

extension Double {
    var zoomLevel: Double {
        let maxZoomLevel = log2(MKMapSize.world.width / 256) // 20
        let zoomLevel = floor(log2(self) + 0.5) // negative
        return max(0, maxZoomLevel + zoomLevel) // max - current
    }
}
