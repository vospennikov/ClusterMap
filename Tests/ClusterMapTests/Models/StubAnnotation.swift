//
//  StubAnnotation.swift
//
//
//  Created by Mikhail Vospennikov on 03.07.2023.
//

import ClusterMap
import CoreLocation
import Foundation
import MapKit

final class StubAnnotation: NSObject, MKAnnotation, CoordinateIdentifiable, Identifiable {
    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

extension StubAnnotation {
    static var insideSmallRect: StubAnnotation {
        pointInRandomLocation(inside: .smallRect)
    }

    static var outsideSmallRect: StubAnnotation {
        pointInRandomLocation(outside: .smallRect)
    }

    static var insideMediumRect: StubAnnotation {
        pointInRandomLocation(inside: .mediumRect)
    }

    static var outsideMediumRect: StubAnnotation {
        pointInRandomLocation(outside: .mediumRect)
    }

    private static func pointInRandomLocation(inside rect: MKMapRect) -> StubAnnotation {
        StubAnnotation(
            coordinate: MKMapPoint(
                x: CGFloat.random(in: rect.minX...rect.maxX),
                y: CGFloat.random(in: rect.minY...rect.maxY)
            ).coordinate
        )
    }

    private static func pointInRandomLocation(outside rect: MKMapRect) -> StubAnnotation {
        let outerRect = MKMapRect(x: rect.maxX, y: rect.maxY, width: rect.width, height: rect.height)
        return pointInRandomLocation(inside: outerRect)
    }
}
