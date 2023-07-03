//
//  QuadTree.swift
//  Cluster
//
//  Created by Lasha Efremidze on 5/6/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import MapKit

protocol AnnotationsContainer {
    func add(_ annotation: MKAnnotation) -> Bool
    func remove(_ annotation: MKAnnotation) -> Bool
    func annotations(in rect: MKMapRect) -> [MKAnnotation]
}

class QuadTreeNode {
    
    enum NodeType {
        case leaf
        case `internal`(children: Children)
    }
    
    struct Children: Sequence {
        let northWest: QuadTreeNode
        let northEast: QuadTreeNode
        let southWest: QuadTreeNode
        let southEast: QuadTreeNode
        
        init(parentNode: QuadTreeNode) {
            let mapRect = parentNode.rect
            northWest = QuadTreeNode(rect: MKMapRect(minX: mapRect.minX, minY: mapRect.minY, maxX: mapRect.midX, maxY: mapRect.midY))
            northEast = QuadTreeNode(rect: MKMapRect(minX: mapRect.midX, minY: mapRect.minY, maxX: mapRect.maxX, maxY: mapRect.midY))
            southWest = QuadTreeNode(rect: MKMapRect(minX: mapRect.minX, minY: mapRect.midY, maxX: mapRect.midX, maxY: mapRect.maxY))
            southEast = QuadTreeNode(rect: MKMapRect(minX: mapRect.midX, minY: mapRect.midY, maxX: mapRect.maxX, maxY: mapRect.maxY))
        }
        
        struct ChildrenIterator: IteratorProtocol {
            private var index = 0
            private let children: Children
            
            init(children: Children) {
                self.children = children
            }
            
            mutating func next() -> QuadTreeNode? {
                defer { index += 1 }
                switch index {
                    case 0: return children.northWest
                    case 1: return children.northEast
                    case 2: return children.southWest
                    case 3: return children.southEast
                    default: return nil
                }
            }
        }
        
        public func makeIterator() -> ChildrenIterator {
            return ChildrenIterator(children: self)
        }
    }
    
    var annotations = [MKAnnotation]()
    let rect: MKMapRect
    var type: NodeType = .leaf
    
    static let maxPointCapacity = 8
    
    init(rect: MKMapRect) {
        self.rect = rect
    }
    
}

extension QuadTreeNode: AnnotationsContainer {
    
    @discardableResult
    func add(_ annotation: MKAnnotation) -> Bool {
        guard rect.contains(annotation.coordinate) else { return false }
        
        switch type {
            case .leaf:
                annotations.append(annotation)
                // if the max capacity was reached, become an internal node
                if annotations.count == QuadTreeNode.maxPointCapacity {
                    subdivide()
                }
            case .internal(let children):
                // pass the point to one of the children
                for child in children where child.add(annotation) {
                    return true
                }
                
                assertionFailure("rect.contains evaluted to true, but none of the children added the annotation")
        }
        return true
    }
    
    @discardableResult
    func remove(_ targetAnnotation: MKAnnotation) -> Bool {
        if !isAnnotationWithinRect(targetAnnotation) {
            return false
        }
        
        if removeAnnotationFromCurrentNode(targetAnnotation) {
            return true
        }
        
        if removeAnnotationFromChildren(targetAnnotation) {
            return true
        }
        
        return false
    }
    
    private func isAnnotationWithinRect(_ targetAnnotation: MKAnnotation) -> Bool {
        rect.contains(targetAnnotation.coordinate)
    }

    private func removeAnnotationFromCurrentNode(_ targetAnnotation: MKAnnotation) -> Bool {
        if let indexOfTarget = annotations.firstIndex(where: { $0.coordinate == targetAnnotation.coordinate }) {
            annotations.remove(at: indexOfTarget)
            return true
        }
        
        return false
    }

    private func removeAnnotationFromChildren(_ targetAnnotation: MKAnnotation) -> Bool {
        if case .internal(let children) = type {
            for child in children {
                if child.remove(targetAnnotation) {
                    return true
                }
            }
        }
        
        return false
    }
    
    private func subdivide() {
        switch type {
            case .leaf:
                type = .internal(children: Children(parentNode: self))
            case .internal:
                preconditionFailure("Calling subdivide on an internal node")
        }
    }
    
    func annotations(in rect: MKMapRect) -> [MKAnnotation] {
        guard self.rect.intersects(rect) else { return [] }
        
        var result = [MKAnnotation]()
        
        for annotation in annotations where rect.contains(annotation.coordinate) {
            result.append(annotation)
        }
        
        switch type {
            case .leaf: break
            case .internal(let children):
                for childNode in children {
                    result.append(contentsOf: childNode.annotations(in: rect))
                }
        }
        
        return result
    }
    
}

/// A class representing a QuadTree data structure. This structure is specifically designed to handle annotations for spatial indexing,
/// offering improved efficiency when dealing with large amounts of data spread across a geographical area.
public class QuadTree: AnnotationsContainer {
    /// The root node of the QuadTree. This represents the topmost level of the QuadTree structure.
    private let root: QuadTreeNode
    
    /// Creates a new `QuadTree` instance, initializing it with a specified map rectangle that represents the boundary of the QuadTree.
    /// - Parameter rect: The map rectangle defines the boundary of the QuadTree. The default value is `.world`
    /// - Note: All annotations added to this QuadTree must reside within this boundary.
    public init(rect: MKMapRect = .world) {
        self.root = QuadTreeNode(rect: rect)
    }
    
    /// Adds a specified annotation to the QuadTree.
    /// - Parameter annotation: The annotation will be added to the QuadTree.
    /// - Returns: A Boolean value indicating whether the addition of the annotation was successful (`true`) or not (`false`).
    @discardableResult
    public func add(_ annotation: MKAnnotation) -> Bool {
        root.add(annotation)
    }
    
    /// Removes a specified annotation from the QuadTree.
    /// - Parameter annotation: The annotation will be removed from the QuadTree.
    /// - Returns: A Boolean value indicating whether the annotation removal was successful (`true`) or not (`false`).
    @discardableResult
    public func remove(_ annotation: MKAnnotation) -> Bool {
        root.remove(annotation)
    }

    /// Retrieves all annotations within a specified map rectangle.
    /// This method searches the QuadTree for any annotations within the specified boundary and returns them in an array.
    /// - Parameter rect: The map rectangle to search for annotations.
    /// - Returns: An array of `MKAnnotation` objects within the specified map rectangle. If no annotations are found, an empty array is returned.
    public func annotations(in rect: MKMapRect) -> [MKAnnotation] {
        root.annotations(in: rect)
    }
}
