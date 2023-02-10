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
    lazy var once: Void = { [unowned self] in
        self.countLabel.frame.size.width -= 6
        self.countLabel.frame.origin.x += 3
        self.countLabel.frame.origin.y -= 6
    }()
    
    #if canImport(UIKit)
    override func layoutSubviews() {
        super.layoutSubviews()
        _ = once
    }
    #elseif canImport(AppKit)
    override func layout() {
        super.layout()
        _ = once
    }
    #endif
}
