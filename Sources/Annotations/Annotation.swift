//
//  Annotation.swift
//  
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import MapKit

open class Annotation: MKPointAnnotation {
    public convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        self.coordinate = coordinate
    }
}
