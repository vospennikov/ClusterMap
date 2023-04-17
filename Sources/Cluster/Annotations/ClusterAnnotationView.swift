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
    open var countLabelOffset: NativeEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8) {
        didSet {
            updateLayout()
        }
    }
    
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
        updateLayout()
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
    
    private func updateLayout() {
        updateFrameSize()
        placeLabelToCenter()
    }
    
    private func updateFrameSize() {
        countLabel.sizeToFit()
        
        let frameSize = CGSize(
            width: countLabel.bounds.width + countLabelOffset.left + countLabelOffset.right,
            height: countLabel.bounds.height + countLabelOffset.top + countLabelOffset.bottom
        )
        frame.size = frameSize
    }
    
    private func placeLabelToCenter() {
        #if canImport(UIKit)
        countLabel.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        #elseif canImport(AppKit)
        countLabel.frame.origin.x = bounds.width / 2 - countLabel.bounds.width / 2
        countLabel.frame.origin.y = bounds.height / 2 - countLabel.bounds.height / 2
        #endif
    }
}
