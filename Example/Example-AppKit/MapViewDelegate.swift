//
//  MapViewDelegate.swift
//  Example-AppKit
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import ClusterMap
import Foundation
import MapKit

final class MapViewDelegate: NSObject, MKMapViewDelegate {
    private let manager: ClusterManager

    init(manager: ClusterManager) {
        self.manager = manager
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case is ClusterAnnotation:
            let identifier = "Cluster"
            let annotationView = mapView.annotationView(
                of: ClusterView.self,
                annotation: annotation,
                reuseIdentifier: identifier
            )
            annotationView.backgroundColor = NSColor.systemGreen
            annotationView.alphaValue = 0.0
            return annotationView

        default:
            let identifier = "Pin"
            let annotationView = mapView.annotationView(
                of: MKPinAnnotationView.self,
                annotation: annotation,
                reuseIdentifier: identifier
            )
            annotationView.pinTintColor = NSColor.systemGreen
            annotationView.alphaValue = 0.0
            return annotationView
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        manager.reload(mapView: mapView) { result in
            print(#function, "cluster manager reload result: \(result)")
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }

        if let cluster = annotation as? ClusterAnnotation {
            var zoomRect = MKMapRect.null
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
                if zoomRect.isNull {
                    zoomRect = pointRect
                } else {
                    zoomRect = zoomRect.union(pointRect)
                }
            }
            mapView.setVisibleMapRect(zoomRect, animated: true)
        }
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            views.forEach { view in
                view.animator().alphaValue = 1.0
            }
        }
    }
}
