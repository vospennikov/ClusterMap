//
//  QuadTree.swift
//
//
//  Created by Mikhail Vospennikov on 03.07.2023.
//

import MapKit

final class QuadTree<AnnotationType: CoordinateIdentifiable> where AnnotationType: Hashable {
    private let root: Node<AnnotationType>

    init(rect: MKMapRect = .world) {
        root = Node<AnnotationType>(rect: rect)
    }

    @discardableResult
    func add(_ annotation: AnnotationType) -> Bool {
        root.add(annotation)
    }

    @discardableResult
    func remove(_ annotation: AnnotationType) -> AnnotationType? {
        root.remove(annotation)
    }

    func findAnnotations(in targetRect: MKMapRect) -> [AnnotationType] {
        root.findAnnotations(in: targetRect)
    }
}
