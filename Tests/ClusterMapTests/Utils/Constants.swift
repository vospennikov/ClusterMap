//
//  Constants.swift
//
//
//  Created by Mikhail Vospennikov on 06.09.2023.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    static let smallRegion = MKCoordinateRegion(.smallRect)
    static let mediumRegion = MKCoordinateRegion(.mediumRect)
}

extension MKMapRect {
    static let mediumRect = MKMapRect(x: 0, y: 0, width: 1_000_000, height: 1_000_000)
    static let smallRect = MKMapRect(x: 0, y: 0, width: 500_000, height: 500_000)
}

extension CGSize {
    static let mediumMapSize = CGSize(width: 428, height: 926)
}
