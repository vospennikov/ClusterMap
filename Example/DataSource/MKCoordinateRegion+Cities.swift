//
//  MKCoordinateRegion+Cities.swift
//  DataSource
//
//  Created by Mikhail Vospennikov on 08.02.2023.
//

import MapKit

public extension MKCoordinateRegion {
    static var sanFrancisco: MKCoordinateRegion {
        .init(
            center: CLLocationCoordinate2D(latitude: 37.787_994, longitude: -122.407_437),
            span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
}
