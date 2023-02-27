//
//  CountClusterAnnotationView.swift
//  Example
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import Foundation
import Cluster
import MapKit

class CountClusterAnnotationView: ClusterAnnotationView {
    override func configure(_ annotation: ClusterAnnotation) {
        super.configure(annotation)
        
        let count = annotation.annotations.count
        let diameter = radius(for: count) * 2
        frame.size = CGSize(width: diameter, height: diameter)
        self.countLabel.sizeToFit()
        nativeLayer?.cornerRadius = frame.width / 2
        nativeLayer?.masksToBounds = true
        nativeLayer?.borderColor = NativeColor.white.cgColor
        nativeLayer?.borderWidth = 1.5
    }
    
    var nativeLayer: CALayer? {
        layer
    }
    
    func radius(for count: Int) -> CGFloat {
        if count < 5 {
            return 12
        } else if count < 10 {
            return 16
        } else {
            return 20
        }
    }
}
