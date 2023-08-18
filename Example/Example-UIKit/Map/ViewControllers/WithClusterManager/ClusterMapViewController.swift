//
//  ClusterMapViewController.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import ClusterMap
import MapKit
import UIKit

final class ClusterMapViewController: UIViewController, MapController {
    private let initialRegion: MKCoordinateRegion
    private lazy var mapView = MKMapView(frame: .zero)
    private lazy var clusterManager = ClusterManager()
    private lazy var mapViewDelegate = ClusteredMapViewDelegate(manager: clusterManager)

    var visibleRegion: MKCoordinateRegion { mapView.region }
    var currentAnnotations: [MKAnnotation] { mapView.annotations }

    init(initialRegion: MKCoordinateRegion) {
        self.initialRegion = initialRegion
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureClusterManager()
    }

    func addAnnotations(_ annotations: [MKAnnotation]) {
        clusterManager.add(annotations)
        clusterManager.reload(mapView: mapView)
    }

    func removeAllAnnotations() {
        clusterManager.removeAll()
        clusterManager.reload(mapView: mapView)
    }

    func changeAnnotationsType(_ newType: AnnotationTypes) {
        let currentAnnotations = mapView.annotations
        mapViewDelegate.annotationType = newType
        mapView.removeAnnotations(currentAnnotations)
        mapView.addAnnotations(currentAnnotations)
    }

    private func configureMap() {
        view.addSubview(mapView)
        mapView.frame = CGRect(origin: .zero, size: view.bounds.size)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setRegion(initialRegion, animated: false)
        mapView.delegate = mapViewDelegate
    }

    private func configureClusterManager() {
        clusterManager.maxZoomLevel = 17
        clusterManager.minCountForClustering = 3
        clusterManager.clusterPosition = .nearCenter
    }
}
