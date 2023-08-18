//
//  DefaultMapViewDelegate.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 08.02.2023.
//

import ClusterMap
import Foundation
import MapKit

final class DefaultMapViewDelegate: NSObject, MKMapViewDelegate {
    var annotationType: AnnotationTypes = .count

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is MKUserLocation:
            return nil
        default:
            let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
            marker.clusteringIdentifier = "cluster"
            marker.tintColor = .green
            marker.animatesWhenAdded = true
            return marker
        }
    }
}
