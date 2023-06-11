//
//  ClusterManagerDelegate.swift
//  
//
//  Created by Mikhail Vospennikov on 14.04.2023.
//

import Foundation
import MapKit

/// The  `ClusterManagerDelegate` protocol provides a number of functions to manage clustering and configure cells.
public protocol ClusterManagerDelegate: AnyObject {
    /// The size of each cell on the grid (The larger the size, the better the performance) at a given zoom level.
    /// - Parameter zoomLevel: The zoom level of the visible map region.
    /// - Returns: The cell size at the given zoom level. If you return nil, the cell size will automatically adjust to the zoom level.
    func cellSize(for zoomLevel: Double) async -> Double?
    func cellSize(for zoomLevel: Double) -> Double?
    
    /// Whether to cluster the given annotation.
    /// - Parameter annotation: An annotation object. The object must conform to the MKAnnotation protocol.
    /// - Returns: `true` to clusterize the given annotation.
    func shouldClusterAnnotation(_ annotation: MKAnnotation) async -> Bool
    func shouldClusterAnnotation(_ annotation: MKAnnotation) -> Bool
}

/// The `ClusterManagerDelegate extension` provides default implementations for delegate methods.
public extension ClusterManagerDelegate {
    func cellSize(for zoomLevel: Double) async -> Double? {
        return nil
    }
    
    func cellSize(for zoomLevel: Double) -> Double? {
        return nil
    }
    
    func shouldClusterAnnotation(_ annotation: MKAnnotation) async -> Bool {
        return true
    }
    
    func shouldClusterAnnotation(_ annotation: MKAnnotation) -> Bool {
        return true
    }
}
