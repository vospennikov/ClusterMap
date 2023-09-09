//
//  ClusterAlignment.swift
//
//
//  Created by Mikhail Vospennikov on 06.07.2023.
//

import Foundation
import MapKit

/// Manages the alignment of clustered annotations on the map.
///
/// `ClusterAlignment` is a wrapper around a `ClusterAlignmentStrategy` implementation. It is responsible for
/// determining the position of the cluster icon based on the geographical coordinates of its constituent annotations.
///
/// - Note: You can initialize `ClusterAlignment` with any object conforming to `ClusterAlignmentStrategy`.
/// This allows for custom alignment strategies.
///
/// Example:
///
/// ```swift
/// let myAlignmentStrategy = MyCustomAlignmentStrategy()
/// let clusterAlignment = ClusterAlignment(alignmentStrategy: myAlignmentStrategy)
///
/// // Use clusterAlignment in ClusterManager
/// let customConfig = Configuration(
///     clusterAlignment: clusterAlignment
/// )
/// let manager = ClusterManager(configuration: customConfig)
/// ```
public struct ClusterAlignment: ClusterAlignmentStrategy {
    private let alignmentStrategy: ClusterAlignmentStrategy

    /// Initializes a new `ClusterAlignment` instance.
    ///
    /// - Parameter alignmentStrategy: The object implementing `ClusterAlignmentStrategy` to be used for cluster
    /// alignment.
    public init(alignmentStrategy: ClusterAlignmentStrategy) {
        self.alignmentStrategy = alignmentStrategy
    }

    /// Calculates the position for a cluster based on its coordinates.
    ///
    /// - Parameters:
    ///   - coordinates: An array of `CLLocationCoordinate2D` representing the geographical coordinates of each
    /// annotation in the cluster.
    ///   - mapRect: The visible rectangle area of the map view.
    ///
    /// - Returns: The `CLLocationCoordinate2D` that represents the cluster's aligned position on the map.
    public func calculatePosition(
        for coordinates: [CLLocationCoordinate2D],
        within mapRect: MKMapRect
    ) -> CLLocationCoordinate2D {
        alignmentStrategy.calculatePosition(for: coordinates, within: mapRect)
    }
}

public extension ClusterAlignment {
    /// Cluster position in the center of the map grid.
    static let center = ClusterAlignment(
        alignmentStrategy: GetCenterCoordinate()
    )

    /// Сluster position near to the center of the map grid relative to the underlying annotations. If there are no
    /// annotations, it falls back to the center of map grid.
    static let nearCenter = ClusterAlignment(
        alignmentStrategy: GetNearCenterCoordinate(clusterCenterPosition: GetCenterCoordinate())
    )

    /// Cluster position has an average location relative to the underlying annotations
    static let average = ClusterAlignment(
        alignmentStrategy: GetAverageCoordinate()
    )

    /// Cluster position is equal to the location of the first of the underlying annotations. If there are no
    /// annotations, it falls back to the center of map grid.
    static let first = ClusterAlignment(
        alignmentStrategy: GetFirstCoordinate(fallback: GetCenterCoordinate())
    )
}
