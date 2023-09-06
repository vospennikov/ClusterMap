//
//  MapContainerViewController.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 08.02.2023.
//

import DataSource
import MapKit
import UIKit

final class MapContainerViewController: UIViewController {
    private var dataSource = CoordinateRandomizer()
    private var mapController: MapController
    private var controlsController = MapControlsViewController()

    init(mapController: MapController) {
        self.mapController = mapController
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureActions()
    }

    private func configureHierarchy() {
        add(mapController)
        add(controlsController)

        controlsController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controlsController.view.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0
            ),
            controlsController.view.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8.0
            ),
            controlsController.view.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
        ])
    }

    private func configureActions() {
        controlsController.addAnnotations = { [weak mapController] in
            guard let region = mapController?.visibleRegion else {
                return
            }
            let points = self.dataSource.generateRandomCoordinates(count: 10000, within: region)
            let annotations = points.map {
                let point = PointAnnotation()
                point.coordinate = $0
                return point
            }
            Task { await mapController?.addAnnotations(annotations) }
        }
        controlsController.removeAnnotations = { [weak mapController] in
            Task { await mapController?.removeAllAnnotations() }
        }
        controlsController.changeAnnotationType = { [weak mapController] newAnnotationType in
            Task { await mapController?.changeAnnotationsType(newAnnotationType) }
        }
    }
}
