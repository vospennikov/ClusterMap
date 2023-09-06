//
//  AnnotationType.swift
//
//
//  Created by Mikhail Vospennikov on 28.08.2023.
//

import Foundation

public extension ClusterManager {
    /// Represents the type of individual annotation or cluster annotation.
    ///
    /// Example:
    ///
    /// ```swift
    /// let singleAnnotation: AnnotationType = .annotation(myAnnotation)
    /// let clusterAnnotation: AnnotationType = .cluster(myClusterAnnotation)
    ///
    /// let annotations: [AnnotationType] = [singleAnnotation, clusterAnnotation]
    /// switch annotations {
    ///   case .annotation(let value):
    ///     break
    ///   case .cluster(let value):
    ///     break
    /// }
    /// ```
    enum AnnotationType: Equatable, Hashable, Identifiable where Annotation: Equatable {
        public var id: Self { self }

        /// Represents an individual annotation.
        case annotation(Annotation)

        /// Represents a cluster of annotations.
        case cluster(ClusterAnnotation)

        public static func == (lhs: AnnotationType, rhs: AnnotationType) -> Bool {
            switch (lhs, rhs) {
            case let (.annotation(lhs), .annotation(rhs)):
                return lhs == rhs
            case let (.cluster(lhs), .cluster(rhs)):
                return lhs == rhs
            default:
                return false
            }
        }
    }
}
