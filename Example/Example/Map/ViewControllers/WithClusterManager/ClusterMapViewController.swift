//
//  ClusteredMapViewController.swift
//  Example
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import UIKit
import SwiftUI
import MapKit
import Cluster

final class ClusterMapViewController: UIViewController, MapController {
    private let initialRegion: MKCoordinateRegion
    private lazy var mapView = MKMapView(frame: .zero)
    private lazy var clusterManager = ClusterManager()
    private var mapViewDelegate: ClusteredMapViewDelegate?
    private var clusterManagerDelegate: ClusterManagerDelegate?
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
        
        mapViewDelegate = ClusteredMapViewDelegate(manager: clusterManager)
        clusterManagerDelegate = ClusteredMapManagerDelegate()
        
        mapView.delegate = mapViewDelegate
        clusterManager.delegate = clusterManagerDelegate
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
        mapViewDelegate?.annotationType = newType
        mapView.removeAnnotations(currentAnnotations)
        mapView.addAnnotations(currentAnnotations)
    }
    
    private func configureMap() {
        view.addSubview(mapView)
        mapView.frame = CGRect(origin: .zero, size: view.bounds.size)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setRegion(initialRegion, animated: false)
    }
    
    private func configureClusterManager() {
        clusterManager.maxZoomLevel = 17
        clusterManager.minCountForClustering = 3
        clusterManager.clusterPosition = .nearCenter
    }
}

private struct ClusteredMapViewController_PreviewProvider: PreviewProvider {
    static var previews: some View {
        ClusterMapViewController(initialRegion: .sanFrancisco)
            .preview
    }
}
