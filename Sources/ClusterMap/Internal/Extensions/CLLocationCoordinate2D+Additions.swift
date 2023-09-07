//
//  CLLocationCoordinate2D+Additions.swift
//
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import CoreLocation
import Foundation
import MapKit

let CLLocationCoordinate2DMax = CLLocationCoordinate2D(latitude: 90, longitude: 180)
let MKMapPointMax = MKMapPoint(CLLocationCoordinate2DMax)
private let radiusOfEarth: Double = 6_372_797.6

extension CLLocationCoordinate2D {
    func coordinate(onBearingInRadians bearing: Double, atDistanceInMeters distance: Double) -> CLLocationCoordinate2D {
        let distRadians = distance / radiusOfEarth // earth radius in meters

        let lat1 = latitude * .pi / 180
        let lon1 = longitude * .pi / 180

        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))

        return CLLocationCoordinate2D(latitude: lat2 * 180 / .pi, longitude: lon2 * 180 / .pi)
    }

    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        location.distance(from: coordinate.location)
    }
}
