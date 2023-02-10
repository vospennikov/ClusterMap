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
        
        #if canImport(AppKit)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        #endif
        
        return label
    }()
    
    open override func prepareForDisplay() {
        super.prepareForDisplay()
        configure()
    }
    
    open func configure() {
        guard let annotation = annotation as? ClusterAnnotation else { return }
        let count = annotation.annotations.count
        countLabel.nativeText = "\(count)"
    }
    
    #if canImport(AppKit)
    open var backgroundColor: NativeColor? {
        get {
            guard let nativeLayer = self.nativeLayer,
            let backgroundColor = nativeLayer.backgroundColor else { return nil }
            return NativeColor(cgColor: backgroundColor)
        }
        set {
            self.nativeLayer?.backgroundColor = newValue?.cgColor
        }
    }
    #endif
}
