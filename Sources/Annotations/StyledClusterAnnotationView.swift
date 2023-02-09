//
//  StyledClusterAnnotationView.swift
//  
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import MapKit
#if canImport(UIKit)
import UIKit
#elseif canImport(Cocoa)
import Cocoa
#endif
/**
 A cluster annotation view that supports styles.
 */
open class StyledClusterAnnotationView: ClusterAnnotationView {
    
    /**
     The style of the cluster annotation view.
     */
    public var style: ClusterAnnotationStyle
    
    /**
     Initializes and returns a new cluster annotation view.
     
     - Parameters:
     - annotation: The annotation object to associate with the new view.
     - reuseIdentifier: If you plan to reuse the annotation view for similar types of annotations, pass a string to identify it. Although you can pass nil if you do not intend to reuse the view, reusing annotation views is generally recommended.
     - style: The cluster annotation style to associate with the new view.
     
     - Returns: The initialized cluster annotation view.
     */
    public init(annotation: MKAnnotation?, reuseIdentifier: String?, style: ClusterAnnotationStyle) {
        self.style = style
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func configure() {
        guard let annotation = annotation as? ClusterAnnotation else { return }
        
        switch style {
            case let .image(image):
                backgroundColor = .clear
                self.image = image
            case let .color(color, radius):
                let count = annotation.annotations.count
                backgroundColor = color
                var diameter = radius * 2
                switch count {
                    case _ where count < 8:
                        diameter *= 0.6
                    case _ where count < 16:
                        diameter *= 0.8
                    default: break
                }
                frame = CGRect(origin: frame.origin, size: CGSize(width: diameter, height: diameter))
                countLabel.text = "\(count)"
        }
    }
    
    private func configureLayer() {
        if case .color = style {
            nativeLayer?.masksToBounds = true
            nativeLayer?.cornerRadius = image == nil ? bounds.width / 2 : 0
            countLabel.frame = bounds
        }
    }
    
    #if canImport(UIKit)
    override open func layoutSubviews() {
        super.layoutSubviews()
        configureLayer()
    }
    #elseif canImport(Cocoa)
    open override func layout() {
        super.layout()
        configureLayer()
    }
    
    var backgroundColor: NSColor? {
        get {
            guard let cgColor = layer?.backgroundColor else { return nil }
            return NSColor(cgColor: cgColor)
        }
        set {
            if let newValue {
                layer?.backgroundColor = newValue.cgColor
            } else {
                layer?.backgroundColor = nil
            }
        }
    }
    #endif
}
