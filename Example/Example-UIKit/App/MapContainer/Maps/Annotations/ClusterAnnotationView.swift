//
//  ClusterAnnotationView.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 29.08.2023.
//

import MapKit
import UIKit

class ClusterAnnotationView: MKAnnotationView {
    var countLabelOffset: UIEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8) {
        didSet { updateLayout() }
    }

    lazy var countLabel: CountLabel = {
        let label = CountLabel()
        label.configure()
        addSubview(label)
        return label
    }()

    override func prepareForDisplay() {
        super.prepareForDisplay()

        if let annotation = annotation as? ClusterAnnotation {
            configure(annotation)
        }
    }

    func configure(_ annotation: ClusterAnnotation) {
        countLabel.text = "\(annotation.memberAnnotations.count)"
        updateLayout()
    }

    private func updateLayout() {
        updateFrameSize()
        placeLabelToCenter()
    }

    private func updateFrameSize() {
        countLabel.sizeToFit()

        let frameSize = CGSize(
            width: countLabel.bounds.width + countLabelOffset.left + countLabelOffset.right,
            height: countLabel.bounds.height + countLabelOffset.top + countLabelOffset.bottom
        )
        frame.size = frameSize
    }

    private func placeLabelToCenter() {
        countLabel.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
}
