//
//  MapContainerViewController.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 08.02.2023.
//

import UIKit
import MapKit
import DataSource

protocol MapController: UIViewController {
    init(initialRegion: MKCoordinateRegion)
    
    var visibleRegion: MKCoordinateRegion { get }
    var currentAnnotations: [MKAnnotation] { get }
    
    func addAnnotations(_ annotations: [MKAnnotation])
    func removeAllAnnotations()
    func changeAnnotationsType(_ newType: AnnotationTypes)
}

final class MapContainerViewController: UIViewController {
    private var dataSource = AnnotationDataSource()
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
            let annotations = self.dataSource.generateRandomAnnotations(count: 10_000, within: region)
            mapController?.addAnnotations(annotations)
        }
        controlsController.removeAnnotations = { [weak mapController] in
            mapController?.removeAllAnnotations()
        }
        controlsController.changeAnnotationType = { [weak mapController] newAnnotationType in
            mapController?.changeAnnotationsType(newAnnotationType)
        }
    }
}
