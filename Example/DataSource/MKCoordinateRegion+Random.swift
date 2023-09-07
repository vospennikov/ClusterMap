//
//  MKCoordinateRegion+Random.swift
//  DataSource
//
//  Created by Mikhail Vospennikov on 08.02.2023.
//

import MapKit

extension MKCoordinateRegion {
    var maxLongitude: CLLocationDegrees { center.longitude + span.longitudeDelta / 2 }
    var minLongitude: CLLocationDegrees { center.longitude - span.longitudeDelta / 2 }
    var maxLatitude: CLLocationDegrees { center.latitude + span.latitudeDelta / 2 }
    var minLatitude: CLLocationDegrees { center.latitude - span.latitudeDelta / 2 }
}

extension MKCoordinateRegion {
    func randomCoordinate() -> CLLocationCoordinate2D {
        .random(
            minLatitude: minLatitude,
            maxLatitude: maxLatitude,
            minLongitude: minLongitude,
            maxLongitude: maxLongitude
        )
    }
}
