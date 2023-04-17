//
//  CLLocationCoordinate2D+Extesnions.swift
//  
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import Foundation
import CoreLocation
import MapKit

let CLLocationCoordinate2DMax = CLLocationCoordinate2D(latitude: 90, longitude: 180)
let MKMapPointMax = MKMapPoint(CLLocationCoordinate2DMax)
private let radiusOfEarth: Double = 6372797.6

extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

/// Compare two CLLocationCoordinate2D values for equality.
public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    lhs.latitude.isNearlyEqual(to: rhs.latitude) &&
    lhs.longitude.isNearlyEqual(to: rhs.longitude)
}

extension CLLocationCoordinate2D {
    /// Calculates a new coordinate that is a certain distance away (in meters) on a given bearing (in radians) from the current coordinate.
    /// - Parameters:
    ///   - bearing: The bearing (in radians) from the current coordinate to the new coordinate.
    ///   - distance: The distance (in meters) between the current coordinate and the new coordinate.
    /// - Returns: A new `CLLocationCoordinate2D` object representing the new coordinate.
    func coordinate(onBearingInRadians bearing: Double, atDistanceInMeters distance: Double) -> CLLocationCoordinate2D {
        let distRadians = distance / radiusOfEarth // earth radius in meters
        
        let lat1 = latitude * .pi / 180
        let lon1 = longitude * .pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / .pi, longitude: lon2 * 180 / .pi)
    }
    
    /// Returns a `CLLocation` object representing the current coordinate.
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    /// Calculates the distance (in meters) between the current coordinate and another coordinate passed as an argument.
    /// - Parameter coordinate: The other coordinate to calculate the distance to.
    /// - Returns: The distance (in meters) between the current coordinate and the other coordinate.
    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        return location.distance(from: coordinate.location)
    }
}
