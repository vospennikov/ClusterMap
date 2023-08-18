//
//  MockAnnotation.swift
//
//
//  Created by Mikhail Vospennikov on 03.07.2023.
//

import CoreLocation
import Foundation
import MapKit

class MockAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
