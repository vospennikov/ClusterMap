//
//  ClusterAnnotation.swift
//
//
//  Created by Mikhail Vospennikov on 28.08.2023.
//

import CoreLocation
import Foundation

public extension ClusterManager {
    /// Represents a cluster of annotations on the map.
    ///
    /// `ClusterAnnotation` is a struct that holds the information for a group of annotations that have been clustered
    /// together. It contains the geographical coordinate for the cluster and an array of `Annotation` objects that
    /// belong to this cluster.
    struct ClusterAnnotation: Equatable, Hashable, Identifiable {
        /// A unique identifier
        public let id = UUID()

        /// The geographical coordinate where the cluster annotation will be displayed.
        public let coordinate: CLLocationCoordinate2D

        /// An array of `Annotation` objects that belong to this cluster.
        public let memberAnnotations: [Annotation]

        public static func == (lhs: ClusterAnnotation, rhs: ClusterAnnotation) -> Bool {
            lhs.coordinate == rhs.coordinate && lhs.memberAnnotations == rhs.memberAnnotations
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
