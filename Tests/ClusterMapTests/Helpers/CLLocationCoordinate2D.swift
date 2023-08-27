//
//  CLLocationCoordinate2D.swift
//
//
//  Created by Mikhail Vospennikov on 12.04.2023.
//

import CoreLocation
import Foundation

extension CLLocationCoordinate2D {
    static func random(
        minLatitude: Double,
        maxLatitude: Double,
        minLongitude: Double,
        maxLongitude: Double
    ) -> CLLocationCoordinate2D {
        let latitudeDelta = maxLatitude - minLatitude
        let longitudeDelta = maxLongitude - minLongitude

        let latitude = minLatitude + latitudeDelta * Double.random(in: 0 ... 1)
        let longitude = minLongitude + longitudeDelta * Double.random(in: 0 ... 1)

        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
