//
//  File.swift
//  
//
//  Created by Mikhail Vospennikov on 09.02.2023.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

open class CountLabel: NativeLabel {
    func configure() {
        #if canImport(UIKit)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        baselineAdjustment = .alignCenters
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        baselineAdjustment = .alignCenters
        
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
