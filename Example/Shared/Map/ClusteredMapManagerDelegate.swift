//
//  ClusteredMapManagerDelegate.swift
//  Example
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import Foundation
import Cluster
import MapKit

final class ClusteredMapManagerDelegate: ClusterManagerDelegate {
    func cellSize(for zoomLevel: Double) -> Double? {
        nil // default
    }
    
    func shouldClusterAnnotation(_ annotation: MKAnnotation) -> Bool {
        !(annotation is MeAnnotation)
    }
}
