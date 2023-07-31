//
//  AnnotationsContainer.swift
//
//
//  Created by Mikhail Vospennikov on 03.07.2023.
//

import Foundation
import MapKit

protocol AnnotationsContainer {
    func add(_ annotation: MKAnnotation) async -> Bool
    func remove(_ annotation: MKAnnotation) async -> Bool
    func findAnnotations(in targetRect: MKMapRect) async -> [MKAnnotation]
}

extension QuadTree: AnnotationsContainer {
}
