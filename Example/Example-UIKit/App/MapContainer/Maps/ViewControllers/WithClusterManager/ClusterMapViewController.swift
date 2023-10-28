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
    private lazy var clusterManager = ClusterManager<PointAnnotation>(
        configuration: .init(maxZoomLevel: 17, minCountForClustering: 3, clusterPosition: .nearCenter)
    )
    private var mapViewDelegate: ClusteredMapViewDelegate?

    var annotations: [PointAnnotation] = []

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
    }

    func addAnnotations(_ annotations: [MKAnnotation]) async {
        await clusterManager.add(annotations.map {
            let point = PointAnnotation()
            point.coordinate = $0.coordinate
            return point
        })
        async let changes = clusterManager.reload(mapViewSize: mapView.bounds.size, coordinateRegion: mapView.region)
        await applyChanges(changes)
    }

    @MainActor
    private func applyChanges(_ difference: ClusterManager<PointAnnotation>.Difference) {
        for annotationType in difference.removals {
            switch annotationType {
            case .annotation(let annotation):
                annotations.removeAll(where: { $0 == annotation })
                mapView.removeAnnotation(annotation)
            case .cluster(let clusterAnnotation):
                if let result = annotations.enumerated().first(where: { $0.element.id == clusterAnnotation.id }) {
                    annotations.remove(at: result.offset)
                    mapView.removeAnnotation(result.element)
                }
            }
        }
        for annotationType in difference.insertions {
            switch annotationType {
            case .annotation(let annotation):
                annotations.append(annotation)
                mapView.addAnnotation(annotation)
            case .cluster(let clusterAnnotation):
                let cluster = ClusterAnnotation()
                cluster.id = clusterAnnotation.id
                cluster.coordinate = clusterAnnotation.coordinate
                cluster.memberAnnotations = clusterAnnotation.memberAnnotations
                annotations.append(cluster)
                mapView.addAnnotation(cluster)
            }
        }
    }

    func removeAllAnnotations() async {
        await clusterManager.removeAll()
        await reloadMap()
    }

    func changeAnnotationsType(_ newType: AnnotationTypes) {
        let currentAnnotations = mapView.annotations
        mapViewDelegate?.annotationType = newType
        mapView.removeAnnotations(currentAnnotations)
        mapView.addAnnotations(currentAnnotations)
    }

    func reloadMap() async {
        async let changes = clusterManager.reload(mapViewSize: mapView.bounds.size, coordinateRegion: mapView.region)
        await applyChanges(changes)
    }

    private func configureMap() {
        view.addSubview(mapView)
        mapView.frame = CGRect(origin: .zero, size: view.bounds.size)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setRegion(initialRegion, animated: false)

        let delegate = ClusteredMapViewDelegate(
            regionDidChange: { newRegion in
                Task { await self.reloadMap() }
            }
        )
        mapView.delegate = delegate
        mapViewDelegate = delegate
    }
}
