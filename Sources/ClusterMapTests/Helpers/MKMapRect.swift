//
//  MKMapRect.swift
//
//
//  Created by Mikhail Vospennikov on 03.07.2023.
//

import Foundation
import MapKit

extension MKMapRect {
    static var applePark: MKMapRect {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let topLeft = CLLocationCoordinate2D(
            latitude: Locations.ApplePark.latitude + span.latitudeDelta / 2,
            longitude: Locations.ApplePark.longitude - span.longitudeDelta / 2
        )
        let bottomRight = CLLocationCoordinate2D(
            latitude: Locations.ApplePark.latitude - span.latitudeDelta / 2,
            longitude: Locations.ApplePark.longitude + span.longitudeDelta / 2
        )
        return mapRect(topLeft: topLeft, bottomRight: bottomRight)
    }
    
    static var appleAndMicrosoftHeadquarters: MKMapRect {
        let topLeft = CLLocationCoordinate2D(
            latitude: max(Locations.ApplePark.latitude, Locations.MicrosoftHeadquarters.latitude),
            longitude: min(Locations.ApplePark.longitude, Locations.MicrosoftHeadquarters.longitude)
        )
        let bottomRight = CLLocationCoordinate2D(
            latitude: min(Locations.ApplePark.latitude, Locations.MicrosoftHeadquarters.latitude),
            longitude: max(Locations.ApplePark.longitude, Locations.MicrosoftHeadquarters.longitude)
        )
        return mapRect(topLeft: topLeft, bottomRight: bottomRight)
    }
    
    private static func mapRect(topLeft: CLLocationCoordinate2D, bottomRight: CLLocationCoordinate2D) -> MKMapRect {
        let topLeftPoint = MKMapPoint(topLeft)
        let bottomRightPoint = MKMapPoint(bottomRight)
        
        let originX = min(topLeftPoint.x, bottomRightPoint.x)
        let originY = min(topLeftPoint.y, bottomRightPoint.y)
        let width = abs(topLeftPoint.x - bottomRightPoint.x)
        let height = abs(topLeftPoint.y - bottomRightPoint.y)
        
        return MKMapRect(x: originX, y: originY, width: width, height: height)
    }
}
