//
//  ClusteredMapViewDelegate.swift
//  Example
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import Foundation
import MapKit
import Cluster

final class ClusteredMapViewDelegate: NSObject, MKMapViewDelegate {
    private let manager: ClusterManager
    var annotationType: AnnotationTypes = .count
    
    init(manager: ClusterManager) {
        self.manager = manager
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
            case is ClusterAnnotation:
                let identifier = "Cluster\(annotationType.rawValue)"
                switch annotationType {
                    case .count:
                        let annotationView = mapView.annotationView(
                            of: CountClusterAnnotationView.self,
                            annotation: annotation,
                            reuseIdentifier: identifier
                        )
                        annotationView.countLabel.backgroundColor = .green
                        return annotationView
                        
                    case .imageCount:
                        let annotationView = mapView.annotationView(
                            of: ImageCountClusterAnnotationView.self,
                            annotation: annotation,
                            reuseIdentifier: identifier
                        )
                        annotationView.countLabel.textColor = .green
                        annotationView.image = .pin2
                        return annotationView
                        
                    case .image:
                        let annotationView = mapView.annotationView(
                            of: MKAnnotationView.self,
                            annotation: annotation,
                            reuseIdentifier: identifier
                        )
                        annotationView.image = .pin
                        return annotationView
                }
                
            case is MeAnnotation:
                let identifier = "Me"
                let annotationView = mapView.annotationView(
                    of: MKAnnotationView.self,
                    annotation: annotation,
                    reuseIdentifier: identifier
                )
                annotationView.image = .me
                return annotationView
            default:
                let identifier = "Pin"
                let annotationView = mapView.annotationView(
                    of: MKPinAnnotationView.self,
                    annotation: annotation,
                    reuseIdentifier: identifier
                )
                annotationView.pinTintColor = .green
                return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        manager.reload(mapView: mapView) { finished in
            print(#function, "cluster manager reload result:", finished)
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
        views.appearingAnimation()
    }
}
