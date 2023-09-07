//
//  ClusterAnnotation.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 29.08.2023.
//

import ClusterMap
import MapKit

final class ClusterAnnotation: PointAnnotation {
    var memberAnnotations = [MKAnnotation]()

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? ClusterAnnotation else { return false }

        if self === object {
            return true
        }

        if coordinate != object.coordinate {
            return false
        }

        if memberAnnotations.count != object.memberAnnotations.count {
            return false
        }

        return memberAnnotations.map(\.coordinate) == object.memberAnnotations.map(\.coordinate)
    }
}
