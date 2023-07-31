//
//  QuadTree.Children.swift
//
//
//  Created by Mikhail Vospennikov on 03.07.2023.
//

import Foundation
import MapKit

extension QuadTree {
    struct Children: Sequence {
        let northWest: Node
        let northEast: Node
        let southWest: Node
        let southEast: Node
        
        init(parentNode: Node) {
            let mapRect = parentNode.rect
            northWest = Node(rect: MKMapRect(minX: mapRect.minX, minY: mapRect.minY, maxX: mapRect.midX, maxY: mapRect.midY))
            northEast = Node(rect: MKMapRect(minX: mapRect.midX, minY: mapRect.minY, maxX: mapRect.maxX, maxY: mapRect.midY))
            southWest = Node(rect: MKMapRect(minX: mapRect.minX, minY: mapRect.midY, maxX: mapRect.midX, maxY: mapRect.maxY))
            southEast = Node(rect: MKMapRect(minX: mapRect.midX, minY: mapRect.midY, maxX: mapRect.maxX, maxY: mapRect.maxY))
        }
        
        struct ChildrenIterator: IteratorProtocol {
            private var index = 0
            private let children: Children
            
            init(children: Children) {
                self.children = children
            }
            
            mutating func next() -> Node? {
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
        
        func makeIterator() -> ChildrenIterator {
            return ChildrenIterator(children: self)
        }
    }
}
