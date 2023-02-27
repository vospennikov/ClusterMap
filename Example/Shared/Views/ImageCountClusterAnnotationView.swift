//
//  ImageCountClusterAnnotationView.swift
//  Example
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import Foundation
import MapKit
import Cluster

class ImageCountClusterAnnotationView: ClusterAnnotationView {
    #if canImport(UIKit)
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    #elseif canImport(AppKit)
    override func layout() {
        super.layout()
        updateLayout()
    }
    #endif
    
    func updateLayout() {
        countLabel.frame.origin.y -= 6
    }
}
