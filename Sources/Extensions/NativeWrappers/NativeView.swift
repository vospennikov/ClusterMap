//
//  NativeView.swift
//  
//
//  Created by Mikhail Vospennikov on 09.02.2023.
//

#if canImport(UIKit)
import UIKit
public typealias NativeView = UIView

#elseif canImport(AppKit)
import AppKit
public typealias NativeView = NSView
#endif

extension NativeView {
    var nativeLayer: CALayer? {
        layer
    }
}
