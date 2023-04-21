//
//  CountClusterAnnotationView.swift
//  Example
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import Foundation
import ClusterMap
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
        #if canImport(UIKit)
        countLabel.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        #elseif canImport(AppKit)
        countLabel.frame.origin.x = bounds.width / 2 - countLabel.bounds.width / 2
        countLabel.frame.origin.y = bounds.height / 2 - countLabel.bounds.height / 2
        #endif
    }
    
    private func drawBackground() {
        nativeLayer?.cornerRadius = frame.width / 2
        nativeLayer?.masksToBounds = true
        nativeLayer?.borderColor = NativeColor.white.cgColor
        nativeLayer?.borderWidth = 1.5
    }
    
    private var nativeLayer: CALayer? {
        layer
    }
}
