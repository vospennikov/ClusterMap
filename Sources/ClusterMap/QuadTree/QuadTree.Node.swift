//
//  QuadTree.Node.swift
//
//
//  Created by Mikhail Vospennikov on 03.07.2023.
//

import MapKit

extension QuadTree {
    final class Node {
        let rect: MKMapRect
        let maxPointCapacity = 8
        
        var annotations = [MKAnnotation]()
        var type: NodeType = .leaf
        
        init(rect: MKMapRect) {
            self.rect = rect
        }
        
        @discardableResult
        func add(_ targetAnnotation: MKAnnotation) -> Bool {
            guard isAnnotationWithinRect(targetAnnotation) else {
                return false
            }
            
            switch type {
            case .leaf:
                annotations.append(targetAnnotation)
                // If maximum capacity reached, subdivide into internal node
                if annotations.count >= maxPointCapacity {
                    subdivide()
                }
            case .internal(let children):
                // Find a valid child to add the annotation
                for child in children where child.add(targetAnnotation) {
                    return true
                }
            }
            return true
        }
        
        @discardableResult
        func remove(_ targetAnnotation: MKAnnotation) -> Bool {
            guard isAnnotationWithinRect(targetAnnotation) else {
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
        
        func findAnnotations(in targetRect: MKMapRect) -> [MKAnnotation] {
            guard rect.intersects(targetRect) else {
                return []
            }
            
            // Initialize array with a reasonable capacity to prevent unnecessary reallocations
            var foundAnnotations = [MKAnnotation]()
            foundAnnotations.reserveCapacity(annotations.count)
            
            // Add only the annotations that are contained within the target rectangle
            for annotation in annotations where targetRect.contains(annotation.coordinate) {
                foundAnnotations.append(annotation)
            }
            
            switch type {
            case .leaf:
                break
            case .internal(let childNodes):
                // Retrieve annotations from each child node recursively and add them to the result array
                for childNode in childNodes {
                    foundAnnotations.append(contentsOf: childNode.findAnnotations(in: targetRect))
                }
            }
            
            return foundAnnotations
        }
    }
}

extension QuadTree.Node {
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
        switch type {
        case .internal(let children):
            for child in children where child.remove(targetAnnotation) {
                return true
            }
        case .leaf:
            break
        }
        return false
    }
    
    private func subdivide() {
        switch type {
        case .leaf:
            type = .internal(children: .init(parentNode: self))
        case .internal:
            preconditionFailure("Calling subdivide on an internal node")
        }
    }
}
