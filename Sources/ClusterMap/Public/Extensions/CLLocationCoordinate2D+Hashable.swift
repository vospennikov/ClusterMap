//
//  CLLocationCoordinate2D+Hashable.swift
//
//
//  Created by Mikhail Vospennikov on 06.09.2023.
//

import CoreLocation
import Foundation

// TODO: Remove this conformance; key clusters by grid cell and annotations by identity instead.
extension CLLocationCoordinate2D: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    lhs.latitude.isNearlyEqual(to: rhs.latitude) &&
        lhs.longitude.isNearlyEqual(to: rhs.longitude)
}
