//
//  CountLabel.swift
//
//
//  Created by Mikhail Vospennikov on 09.02.2023.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// A label used to display the count of annotations in a `ClusterAnnotationView`.
open class CountLabel: NativeLabel {
    ///  Configures the label with the appropriate font, color, and alignment settings.
    open func configure() {
        #if canImport(UIKit)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        baselineAdjustment = .alignCenters
        numberOfLines = 1
        
        #elseif canImport(AppKit)
        isBezeled = false
        isEditable = false
        isSelectable = false
        maximumNumberOfLines = 1
        #endif
        
        backgroundColor = .clear
        font = .boldSystemFont(ofSize: 13)
        textColor = .white
        nativeTextAlignment = .center
    }
}
