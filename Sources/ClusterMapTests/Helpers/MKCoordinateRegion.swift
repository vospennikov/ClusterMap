//
//  MKCoordinateRegion.swift
//
//
//  Created by Mikhail Vospennikov on 12.04.2023.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    func randomLocationWithinRegion() -> CLLocationCoordinate2D {
        .random(
            minLatitude: minLatitude,
            maxLatitude: maxLatitude,
            minLongitude: minLongitude,
            maxLongitude: maxLongitude
        )
    }
}

extension MKCoordinateRegion {
    var maxLongitude: CLLocationDegrees {
        center.longitude + span.longitudeDelta / 2
    }

    var minLongitude: CLLocationDegrees {
        center.longitude - span.longitudeDelta / 2
    }

    var maxLatitude: CLLocationDegrees {
        center.latitude + span.latitudeDelta / 2
    }

    var minLatitude: CLLocationDegrees {
        center.latitude - span.latitudeDelta / 2
    }
}
