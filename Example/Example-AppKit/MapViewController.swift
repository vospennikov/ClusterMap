//
//  MapViewController.swift
//  Example-AppKit
//
//  Created by Mikhail Vospennikov on 10.02.2023.
//

import Cocoa
import MapKit
import ClusterMap
import DataSource

final class MapViewController: NSViewController {
    private lazy var mapView = MKMapView(frame: .zero)
    private lazy var clusterManager = ClusterManager()
    private lazy var mapViewDelegate = MapViewDelegate(manager: clusterManager)
    private lazy var dataSource = AnnotationDataSource()
    
    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 640, height: 480))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureClusterManager()
    }
    
    private func configureHierarchy() {
        configureMap()
        configureMapControls()
    }
    
    private func configureClusterManager() {
        clusterManager.maxZoomLevel = 17
        clusterManager.minCountForClustering = 3
        clusterManager.clusterPosition = .nearCenter
    }
}

// MARK: - Layout
private extension MapViewController {
    func configureMap() {
        let mapView = MKMapView(frame: view.bounds)
        mapView.isZoomEnabled = true
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = true
        mapView.showsZoomControls = true
        mapView.setRegion(.sanFrancisco, animated: false)
        mapView.delegate = mapViewDelegate
        self.mapView = mapView
        view.addSubview(mapView)
        mapView.autoresizingMask = [.height, .width]
    }
    
    func configureMapControls() {
        let controlsContainerView = NSStackView()
        controlsContainerView.spacing = 16.0
        controlsContainerView.orientation = .vertical
        controlsContainerView.addArrangedSubview(buildAnnotationActionsControl())
        
        view.addSubview(controlsContainerView)
        controlsContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controlsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlsContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0)
        ])
    }
    
    func buildAnnotationActionsControl() -> NSView {
        let containerView = NSStackView()
        containerView.spacing = 8.0
        containerView.orientation = .horizontal
        containerView.distribution = .fillProportionally
        containerView.addArrangedSubview(
            NSButton(title: "Add annotations", target: self, action: #selector(addActionHandler))
        )
        containerView.addArrangedSubview(
            NSButton(title: "Remove annotations", target: self, action: #selector(removeActionHandler))
        )
        return containerView
    }
}

// MARK: - Target handlers
@objc private extension MapViewController {
    func addActionHandler(_ sender: NSButton) {
        let annotations = dataSource.generateRandomAnnotations(count: 10_000, within: mapView.region)
        clusterManager.add(annotations)
        clusterManager.reload(mapView: mapView)
    }
    
    func removeActionHandler(_ sender: NSButton) {
        clusterManager.removeAll()
        clusterManager.reload(mapView: mapView)
    }
}
