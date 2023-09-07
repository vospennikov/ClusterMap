//
//  CoordinateRandomizer.swift
//  DataSource
//
//  Created by Mikhail Vospennikov on 08.02.2023.
//

import Foundation
import MapKit

public struct CoordinateRandomizer {
    public init() { }

    public func generateRandomCoordinates(count: Int, within region: MKCoordinateRegion) -> [CLLocationCoordinate2D] {
        (0..<count).map { _ in
            region.randomCoordinate()
        }
    }
}
