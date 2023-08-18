//
//  ClusterView.swift
//  Example-AppKit
//
//  Created by Mikhail Vospennikov on 31.07.2023.
//

import ClusterMap
import Foundation
import MapKit

final class ClusterView: ClusterAnnotationView {
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
        countLabel.frame.origin.x = bounds.width / 2 - countLabel.bounds.width / 2
        countLabel.frame.origin.y = bounds.height / 2 - countLabel.bounds.height / 2
    }

    private func drawBackground() {
        layer?.cornerRadius = frame.width / 2
        layer?.masksToBounds = true
        layer?.borderColor = NSColor.white.cgColor
        layer?.borderWidth = 1.5
    }
}
