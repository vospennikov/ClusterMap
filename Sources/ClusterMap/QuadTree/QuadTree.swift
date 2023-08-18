//
//  QuadTree.swift
//
//
//  Created by Mikhail Vospennikov on 03.07.2023.
//

import MapKit

/// A class representing a QuadTree data structure. This structure is specifically designed to handle annotations for
/// spatial indexing,
/// offering improved efficiency when dealing with large amounts of data spread across a geographical area.
final class QuadTree {
    /// The root node of the QuadTree. This represents the topmost level of the QuadTree structure.
    private let root: Node

    /// Creates a new `QuadTree` instance, initializing it with a specified map rectangle that represents the boundary
    /// of the QuadTree.
    /// - Parameter rect: The map rectangle defines the boundary of the QuadTree. The default value is `.world`
    /// - Note: All annotations added to this QuadTree must reside within this boundary.
    init(rect: MKMapRect = .world) {
        root = Node(rect: rect)
    }

    /// Adds a specified annotation to the QuadTree.
    /// - Parameter annotation: The annotation will be added to the QuadTree.
    /// - Returns: A Boolean value indicating whether the addition of the annotation was successful (`true`) or not
    /// (`false`).
    @discardableResult
    func add(_ annotation: MKAnnotation) -> Bool {
        root.add(annotation)
    }

    /// Removes a specified annotation from the QuadTree.
    /// - Parameter annotation: The annotation will be removed from the QuadTree.
    /// - Returns: A Boolean value indicating whether the annotation removal was successful (`true`) or not (`false`).
    @discardableResult
    func remove(_ annotation: MKAnnotation) -> Bool {
        root.remove(annotation)
    }

    /// Retrieves all annotations within a specified map rectangle.
    /// This method searches the QuadTree for any annotations within the specified boundary and returns them in an
    /// array.
    /// - Parameter rect: The map rectangle to search for annotations.
    /// - Returns: An array of `MKAnnotation` objects within the specified map rectangle. If no annotations are found,
    /// an empty array is returned.
    func findAnnotations(in targetRect: MKMapRect) -> [MKAnnotation] {
        root.findAnnotations(in: targetRect)
    }
}
