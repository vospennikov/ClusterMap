//
//  Difference.swift
//
//
//  Created by Mikhail Vospennikov on 31.08.2023.
//

import Foundation

public extension ClusterManager {
    /// Represents the differences between the current and new sets of annotations.
    struct Difference {
        /// An array of  objects that should be inserted.
        public var insertions: [AnnotationType] = []

        /// An array of  objects that should be removed.
        public var removals: [AnnotationType] = []
    }
}
