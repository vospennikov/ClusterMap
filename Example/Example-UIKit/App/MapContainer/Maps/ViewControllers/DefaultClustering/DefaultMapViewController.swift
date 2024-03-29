//
//  DefaultMapViewController.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 08.02.2023.
//

import DataSource
import MapKit
import UIKit

final class DefaultMapViewController: UIViewController, MapController {
    private let initialRegion: MKCoordinateRegion
    private lazy var mapView = MKMapView(frame: .zero)
    private var mapViewDelegate: MKMapViewDelegate?

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
        registerAnnotationViewClasses()
        mapViewDelegate = DefaultMapViewDelegate()
        mapView.delegate = mapViewDelegate
    }

    func addAnnotations(_ annotations: [MKAnnotation]) {
        mapView.addAnnotations(annotations)
    }

    func removeAllAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }

    func changeAnnotationsType(_ newType: AnnotationTypes) { }

    private func configureMap() {
        view.addSubview(mapView)
        mapView.frame = CGRect(origin: .zero, size: view.bounds.size)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setRegion(initialRegion, animated: false)
    }

    private func registerAnnotationViewClasses() {
        mapView.register(
            ClusterWithLabelAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier
        )
    }
}
