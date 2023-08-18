//
//  MapControlsViewContainer.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 08.02.2023.
//

import UIKit

final class MapControlsViewController: UIViewController {
    var addAnnotations: () -> Void = { }
    var removeAnnotations: () -> Void = { }
    var changeAnnotationType: (AnnotationTypes) -> Void = { _ in }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
    }

    private func configureHierarchy() {
        let controlsContainerView = UIStackView()
        controlsContainerView.spacing = 16.0
        controlsContainerView.axis = .vertical
        controlsContainerView.addArrangedSubview(buildAnnotationActionsControl())
        controlsContainerView.addArrangedSubview(buildAnnotationTypesControl())

        view.addSubview(controlsContainerView)
        controlsContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controlsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlsContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            controlsContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: – Controls
private extension MapControlsViewController {
    func buildAnnotationActionsControl() -> UIView {
        let containerView = UIStackView()
        containerView.spacing = 16.0
        containerView.axis = .horizontal
        containerView.alignment = .center
        containerView.distribution = .fillProportionally
        containerView.addArrangedSubview(
            buildActionButton(title: "Add annotations", action: #selector(addActionHandler))
        )
        containerView.addArrangedSubview(
            buildActionButton(title: "Remove annotations", action: #selector(removeActionHandler))
        )
        return containerView
    }

    func buildActionButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8.0
        button.layer.cornerCurve = .continuous
        return button
    }

    func buildAnnotationTypesControl() -> UIView {
        let segmentControl = UISegmentedControl(items: AnnotationTypes.allCases.map(\.description))
        segmentControl.addTarget(self, action: #selector(changeMapAnnotationsTypeHandler), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }
}

// MARK: - Target handlers
@objc private extension MapControlsViewController {
    func addActionHandler(_ sender: UIButton) {
        addAnnotations()
    }

    func removeActionHandler(_ sender: UIButton) {
        removeAnnotations()
    }

    func changeMapAnnotationsTypeHandler(_ sender: UISegmentedControl) {
        guard let annotationType = AnnotationTypes(rawValue: sender.selectedSegmentIndex) else {
            assertionFailure("Unexpected segment index")
            return
        }
        changeAnnotationType(annotationType)
    }
}
