//
//  ImageCountClusterAnnotationView.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import Foundation
import MapKit
import ClusterMap

final class ImageCountClusterAnnotationView: ClusterAnnotationView {
    private let labelOffsetY: CGFloat = -6
    private let labelOffsetX: CGFloat = -4
    
    override func configure(_ annotation: ClusterAnnotation) {
        super.configure(annotation)
        updateFrameSize()
        updateLabelSize()
        placeLabel()
    }
    
    private func updateFrameSize() {
        let originalSize = frame.size
        frame.size = image?.size ?? originalSize
    }
    
    private func updateLabelSize() {
        countLabel.frame.size = CGSize(
            width: countLabel.frame.width + labelOffsetX,
            height: countLabel.frame.height
        )
    }
    
    private func placeLabel() {
        countLabel.center = CGPoint(
            x: bounds.width / 2,
            y: bounds.height / 2 + labelOffsetY
        )
    }
}
