//
//  ClusterAlignment.swift
//
//
//  Created by Mikhail Vospennikov on 06.07.2023.
//

import Foundation
import MapKit

/// Calculate the position of a cluster of `MKAnnotation` instances on a map by delegating the calculation to the injected `ClusterAlignmentStrategy`.
public struct ClusterAlignment: ClusterAlignmentStrategy {
    private let alignmentStrategy: ClusterAlignmentStrategy
    
    /// Creates a new `ClusterAlignment` instance.
    /// - Parameter alignmentStrategy: The strategy to be used in calculating the position of a cluster of annotations.
    public init(alignmentStrategy: ClusterAlignmentStrategy) {
        self.alignmentStrategy = alignmentStrategy
    }
    
    /// Calculates the position for a cluster of `MKAnnotation` instances.
    /// - Parameters:
    ///   - annotations: The array of `MKAnnotation` instances.
    ///   - mapRect: The `MKMapRect` within which the position will be calculated.
    /// - Returns: The calculated `CLLocationCoordinate2D`.
    public func calculatePosition(for annotations: [MKAnnotation], within mapRect: MKMapRect) -> CLLocationCoordinate2D {
        alignmentStrategy.calculatePosition(for: annotations, within: mapRect)
    }
}

public extension ClusterAlignment {
    /// Center position for a cluster of `MKAnnotation` instances.
    static let center = ClusterAlignment(
        alignmentStrategy: GetCenterCoordinate()
    )
    
    /// Position of the `MKAnnotation` nearest to the center. If there are no annotations, it falls back to the center.
    static let nearCenter = ClusterAlignment(
        alignmentStrategy: GetNearCenterCoordinate(clusterCenterPosition: GetCenterCoordinate())
    )
    
    /// Average position for a cluster of `MKAnnotation` instances.
    static let average = ClusterAlignment(
        alignmentStrategy: GetAverageCoordinate()
    )
    
    /// Position of the first `MKAnnotation` in a cluster. If there are no annotations, it falls back to the center position.
    static let first = ClusterAlignment(
        alignmentStrategy: GetFirstCoordinate(fallback: GetCenterCoordinate())
    )
}
