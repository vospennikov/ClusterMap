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
    /// Returns the text alignment of the label using the `NSTextAlignment` enum on macOS and the `UITextAlignment` enum on iOS.
    /// It can also be set to change the text alignment of the label to a specified value.
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
    
    /// Returns the text of the label as a `String` on both macOS and iOS. It can also be set to change the text of the label to a specified value.
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
