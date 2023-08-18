//
//  ClusterAnnotation.swift
//
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import MapKit

/// `ClusterAnnotation` is a subclass of `MKPointAnnotation` which is used to represent a cluster annotation on a map
/// view.
open class ClusterAnnotation: MKPointAnnotation {
    /// An array of `MKAnnotation` objects which represent the points to be clustered.
    open var annotations = [MKAnnotation]()

    /// Compares two `ClusterAnnotation` objects for equality.
    /// - Parameter object: The object to compare against.
    /// - Returns: `true` if the two objects are equal, `false` otherwise.
    override open func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? ClusterAnnotation else { return false }

        if self === object {
            return true
        }

        if coordinate != object.coordinate {
            return false
        }

        if annotations.count != object.annotations.count {
            return false
        }

        return annotations.map(\.coordinate) == object.annotations.map(\.coordinate)
    }
}
