//
//  CountClusterAnnotationView.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import ClusterMap
import Foundation
import MapKit

final class CountClusterAnnotationView: ClusterAnnotationView {
    private let labelOffset: CGFloat = 8

    override func configure(_ annotation: ClusterAnnotation) {
        super.configure(annotation)
        updateFrameSize()
        placeLabelToCenter()
        drawBackground()
    }

    private func updateFrameSize() {
        let maxLength = max(countLabel.bounds.width, countLabel.bounds.height) + labelOffset
        frame.size = CGSize(width: maxLength, height: maxLength)
    }

    private func placeLabelToCenter() {
        countLabel.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }

    private func drawBackground() {
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.5
    }
}
