//
//  MapViewController.swift
//  Example-AppKit
//
//  Created by Mikhail Vospennikov on 10.02.2023.
//

import ClusterMap
import Cocoa
import DataSource
import MapKit

final class MapViewController: NSViewController {
    private lazy var mapView = MKMapView(frame: .zero)
    private lazy var clusterManager = ClusterManager<PointAnnotation>(
        configuration: .init(maxZoomLevel: 17, minCountForClustering: 3, clusterPosition: .nearCenter)
    )
    private var mapViewDelegate: MapViewDelegate?
    private lazy var dataSource = CoordinateRandomizer()
    private var annotations: [PointAnnotation] = []

    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 640, height: 480))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
    }

    private func configureHierarchy() {
        configureMap()
        configureMapControls()
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
        self.mapView = mapView
        view.addSubview(mapView)
        mapView.autoresizingMask = [.height, .width]

        let delegate = MapViewDelegate(
            regionDidChange: { newRegion in
                Task { await self.reloadMap() }
            }
        )
        mapView.delegate = delegate
        mapViewDelegate = delegate
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
            controlsContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0),
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
        Task {
            let annotations = dataSource.generateRandomCoordinates(count: 10000, within: mapView.region)
            await addAnnotations(annotations)
        }
    }

    func removeActionHandler(_ sender: NSButton) {
        Task {
            await clusterManager.removeAll()
            await reloadMap()
        }
    }
}

extension MapViewController {
    func addAnnotations(_ coordinates: [CLLocationCoordinate2D]) async {
        await clusterManager.add(coordinates.map {
            let point = PointAnnotation()
            point.coordinate = $0
            return point
        })
        async let changes = clusterManager.reload(mapViewSize: mapView.bounds.size, coordinateRegion: mapView.region)
        await applyChanges(changes)
    }

    func reloadMap() async {
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
            @unknown default:
                fatalError()
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
            @unknown default:
                fatalError()
            }
        }
    }
}
