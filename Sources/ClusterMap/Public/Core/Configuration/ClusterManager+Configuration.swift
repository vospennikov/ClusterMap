//
//  ClusterManager+Configuration.swift
//
//
//  Created by Mikhail Vospennikov on 26.08.2023.
//

import CoreGraphics
import Foundation

public extension ClusterManager {
    /// Represents the configuration settings for the `ClusterManager`.
    ///
    /// Example:
    ///
    /// ```swift
    /// let defaultConfig = Configuration()  // Default settings
    ///
    /// let customConfig = Configuration(
    ///     maxZoomLevel: 18,
    ///     minCountForClustering: 3,
    ///     shouldRemoveInvisibleAnnotations: false
    /// )
    /// let manager = ClusterManager(configuration: customConfig)
    /// ```
    struct Configuration {
        /// Maximum depth for clustering.
        ///
        /// Beyond this zoom level, annotations will be displayed individually.
        ///
        /// - Note: The minimum value is `0` (max zoom out) and the maximum value is `20` (max zoom in). The default is `20`.
        @Clamping(to: 0...20)
        public var maxZoomLevel: Double = 20

        /// Threshold number for clustering within a region.
        ///
        /// This count is the minimum number of annotations required to form a cluster. Annotations in regions with fewer than this count will not be clustered.
        ///
        /// - Note: The default is `2`.
        @Clamping(to: 0...)
        public var minCountForClustering: Int = 2

        /// Removal of non-visible annotations.
        ///
        /// This optimizes rendering performance by avoiding the computation of annotations that aren't currently visible in the map's viewport.
        /// When set to `true`, annotations outside the current map view will not be processed.
        ///
        /// - Note: The default is `true`.
        public var shouldRemoveInvisibleAnnotations: Bool

        /// Distribution of annotations with identical coordinates.
        ///
        /// This ensures that annotations with identical or very close coordinates can still be distinctly recognized and interacted with by the user.
        /// When set to `true`, annotations with the same coordinate will be distributed slightly to prevent them from overlapping.
        ///
        /// - Note: The default is `true`.
        public var shouldDistributeAnnotationsOnSameCoordinate: Bool

        /// Distance (in meters) for distributing overlapping annotations.
        ///
        /// When `shouldDistributeAnnotationsOnSameCoordinate` is `true`, this value represents the distance (in meters) by which annotations should be shifted apart from a contested location.
        ///
        /// - Note: The default is `3`.
        @Clamping(to: 0...)
        public var distanceFromContestedLocation: Double = 3

        /// Controls the positioning strategy of a cluster.
        ///
        /// Defines the algorithm used to position the cluster annotation.
        ///
        /// The following clustering strategies are available for use:
        ///
        /// - `.center`: Represents the center position for a cluster of `MKAnnotation` instances.
        /// - `.nearCenter`: Represents the position of the `MKAnnotation` nearest to the center. Defaults to the center if no annotations are available.
        /// - `.average`: Represents the average position for a cluster of `MKAnnotation` instances.
        /// - `.first`: Represents the first `MKAnnotation` position within a cluster. Defaults to the center if no annotations are available.
        ///
        /// - Note: You can develop your alignment strategy by implementing the `ClusterAlignmentStrategy` protocol on a `ClusterAlignment` struct.
        ///
        /// Here's an example:
        /// ```swift
        /// var clusterAlignment = ClusterAlignment(
        ///   alignmentStrategy: NewStrategy()
        /// )
        ///
        /// struct NewStrategy: ClusterAlignmentStrategy {
        ///   func calculatePosition(for annotations: [MKAnnotation], within mapRect: MKMapRect) ->
        /// CLLocationCoordinate2D {
        ///     // Place your custom alignment logic here.
        ///   }
        /// }
        /// ```
        ///
        /// - Note: The default value is `.nearCenter`
        public var clusterPosition: ClusterAlignment = .nearCenter

        /// Dynamic size adjustment of the grid cell for a given zoom level.
        ///
        /// This closure takes an `Int` value representing the zoom level and returns a `CGSize` that sets the dimensions of the cell size at that zoom level.
        ///
        /// Use this to control how cells should be sized at different zoom levels to optimize clustering and  performance.
        ///
        /// - Parameter zoom: The zoom level as an `Int`.
        /// - Returns: A `CGSize` representing the width and height of the cell at the given zoom level. Only square cell is supported.
        ///
        /// - Note: Here's an example::
        ///
        /// ```swift
        /// let customConfig = Configuration(
        ///     maxZoomLevel: 18,
        ///     minCountForClustering: 3,
        ///     shouldRemoveInvisibleAnnotations: false,
        ///     cellSizeForZoomLevel: { zoom in
        ///         switch zoom {
        ///         case 13...15: return CGSize(width: 64, height: 64)
        ///         case 16...18: return CGSize(width: 32, height: 32)
        ///         case 19...: return CGSize(width: 16, height: 16)
        ///         default: return CGSize(width: 88, height: 88)
        ///         }
        ///     }
        /// )
        public var cellSizeForZoomLevel: (Int) -> CGSize

        public init(
            maxZoomLevel: Double = 20,
            minCountForClustering: Int = 2,
            shouldRemoveInvisibleAnnotations: Bool = true,
            shouldDistributeAnnotationsOnSameCoordinate: Bool = true,
            distanceFromContestedLocation: Double = 3,
            clusterPosition: ClusterAlignment = .nearCenter,
            cellSizeForZoomLevel: @escaping (Int) -> CGSize = { zoom in
                switch zoom {
                case 13...15: return CGSize(width: 64, height: 64)
                case 16...18: return CGSize(width: 32, height: 32)
                case 19...: return CGSize(width: 16, height: 16)
                default: return CGSize(width: 88, height: 88)
                }
            }
        ) {
            self.maxZoomLevel = maxZoomLevel
            self.minCountForClustering = minCountForClustering
            self.shouldRemoveInvisibleAnnotations = shouldRemoveInvisibleAnnotations
            self.shouldDistributeAnnotationsOnSameCoordinate = shouldDistributeAnnotationsOnSameCoordinate
            self.distanceFromContestedLocation = distanceFromContestedLocation
            self.clusterPosition = clusterPosition
            self.cellSizeForZoomLevel = cellSizeForZoomLevel
        }
    }
}
