//
//  AnnotationDataSource.swift
//  DataSource
//
//  Created by Mikhail Vospennikov on 08.02.2023.
//

import Foundation
import MapKit

public struct AnnotationDataSource {
    public init() { }
    
    public func generateRandomAnnotations(count: Int, within region: MKCoordinateRegion) -> [MKAnnotation] {
        let annotations: [MKAnnotation] = (0..<count).map { index in
            let annotation = MKPointAnnotation()
            annotation.coordinate = region.randomLocationWithinRegion()
            return annotation
        }
        return annotations
    }
}
