//
//  ClusterAlignmentStrategy.swift
//
//
//  Created by Mikhail Vospennikov on 06.07.2023.
//

import Foundation
import MapKit

/// Calculate the position for a cluster of `CLLocationCoordinate2D` instances within a specified `MKMapRect`.
public protocol ClusterAlignmentStrategy: Sendable {
    /// Calculates the position for a cluster of `CLLocationCoordinate2D` instances.
    /// - Parameters:
    ///   - annotations: The array of `CLLocationCoordinate2D` instances.
    ///   - mapRect: The `MKMapRect` within which the position will be calculated.
    /// - Returns: The calculated `CLLocationCoordinate2D`.
    func calculatePosition(
        for coordinates: [CLLocationCoordinate2D],
        within mapRect: MKMapRect
    ) -> CLLocationCoordinate2D
}
