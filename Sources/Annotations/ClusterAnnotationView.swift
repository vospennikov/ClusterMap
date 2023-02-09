//
//  ClusterAnnotationView.swift
//  
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import MapKit

/**
 The view associated with your cluster annotations.
 */
open class ClusterAnnotationView: MKAnnotationView {
    open lazy var countLabel: CountLabel = {
        let label = CountLabel()
        label.configure()
        self.addSubview(label)
        return label
    }()
    
    open override func prepareForDisplay() {
        super.prepareForDisplay()
        configure()
    }
    
    open func configure() {
        guard let annotation = annotation as? ClusterAnnotation else { return }
        let count = annotation.annotations.count
        countLabel.text = "\(count)"
    }
}
