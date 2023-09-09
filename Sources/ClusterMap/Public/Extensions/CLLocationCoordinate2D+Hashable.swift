//
//  CLLocationCoordinate2D+Hashable.swift
//
//
//  Created by Mikhail Vospennikov on 06.09.2023.
//

import CoreLocation
import Foundation

extension CLLocationCoordinate2D: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    lhs.latitude.isNearlyEqual(to: rhs.latitude) &&
        lhs.longitude.isNearlyEqual(to: rhs.longitude)
}
