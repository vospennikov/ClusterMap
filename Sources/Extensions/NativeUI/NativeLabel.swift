//
//  File.swift
//  
//
//  Created by Mikhail Vospennikov on 10.02.2023.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension NativeLabel {
    var nativeTextAlignment: NSTextAlignment {
        get {
            #if canImport(UIKit)
            return textAlignment
            #elseif canImport(AppKit)
            return alignment
            #endif
        }
        set {
            #if canImport(UIKit)
            textAlignment = newValue
            #elseif canImport(AppKit)
            alignment = newValue
            #endif
        }
    }
    
    var nativeText: String? {
        get {
            #if canImport(UIKit)
            return text
            #elseif canImport(AppKit)
            return stringValue
            #endif
        }
        set {
            #if canImport(UIKit)
            text = newValue
            #elseif canImport(AppKit)
            stringValue = newValue ?? ""
            #endif
        }
    }
}
