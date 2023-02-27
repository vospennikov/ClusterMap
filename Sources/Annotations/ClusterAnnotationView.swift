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
        addSubview(label)
        return label
    }()
    
    open override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let annotation = annotation as? ClusterAnnotation {
            configure(annotation)
        }
    }
    
    open func configure(_ annotation: ClusterAnnotation) {
        countLabel.nativeText = "\(annotation.annotations.count)"
        countLabel.sizeToFit()
        placeLabelToCenter()
    }
    
    #if canImport(UIKit)
    open override func layoutSubviews() {
        super.layoutSubviews()
        placeLabelToCenter()
    }
    #elseif canImport(AppKit)
    open override func layout() {
        super.layout()
        placeLabelToCenter()
    }
    #endif
    
    func placeLabelToCenter() {
        #if canImport(UIKit)
        countLabel.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        #elseif canImport(AppKit)
        countLabel.frame.origin.x = bounds.width / 2 - countLabel.bounds.width / 2
        countLabel.frame.origin.y = bounds.height / 2 - countLabel.bounds.height / 2
        #endif
    }
    
    #if canImport(AppKit)
    open var backgroundColor: NativeColor? {
        get {
            guard let nativeLayer,
                  let backgroundColor = nativeLayer.backgroundColor else {
                return nil
            }
            return NativeColor(cgColor: backgroundColor)
        }
        set {
            nativeLayer?.backgroundColor = newValue?.cgColor
        }
    }
    #endif
}
