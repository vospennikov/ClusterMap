//
//  ClusterAlignmentStrategy.swift
//
//
//  Created by Mikhail Vospennikov on 06.07.2023.
//

import Foundation
import MapKit

/// Calculate the position for a cluster of `MKAnnotation` instances within a specified `MKMapRect`.
public protocol ClusterAlignmentStrategy {
    /// Calculates the position for a cluster of `MKAnnotation` instances.
    /// - Parameters:
    ///   - annotations: The array of `MKAnnotation` instances.
    ///   - mapRect: The `MKMapRect` within which the position will be calculated.
    /// - Returns: The calculated `CLLocationCoordinate2D`.
    func calculatePosition(for annotations: [MKAnnotation], within mapRect: MKMapRect) -> CLLocationCoordinate2D
}
