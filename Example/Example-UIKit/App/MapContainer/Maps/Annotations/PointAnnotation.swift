//
//  PointAnnotation.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 03.09.2023.
//

import ClusterMap
import Foundation
import MapKit

class PointAnnotation: MKPointAnnotation, CoordinateIdentifiable, Identifiable {
    var id: UUID = .init()

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? PointAnnotation else { return false }
        return coordinate == object.coordinate && self === object
    }
}
