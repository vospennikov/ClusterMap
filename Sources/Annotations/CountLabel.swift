//
//  File.swift
//  
//
//  Created by Mikhail Vospennikov on 09.02.2023.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(Cocoa)
import Cocoa
#endif

open class CountLabel: NativeLabel {
    func configure() {
        #if canImport(UIKit)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .clear
        font = .boldSystemFont(ofSize: 13)
        textColor = .white
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        baselineAdjustment = .alignCenters
        #elseif canImport(Cocoa)
        autoresizingMask = [.height, .width]
        backgroundColor = .clear
        font = .boldSystemFont(ofSize: 13)
        textColor = .white
        alignment = .center
        isBezeled = false
        isEditable = false
        // label.adjustsFontSizeToFitWidth = true
        // label.minimumScaleFactor = 0.5
        // label.baselineAdjustment = .alignCenters
        #endif
    }
    
    #if canImport(Cocoa)
    public var text: String? {
        get { stringValue }
        set { stringValue = newValue ?? "" }
    }
    #endif
}
