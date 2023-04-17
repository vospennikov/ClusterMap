//
//  Native+TypeAliases.swift
//  
//
//  Created by Mikhail Vospennikov on 09.02.2023.
//

import Foundation

/// This preprocessor macro provides type aliases for different platform-specific classes depending on whether UIKit or AppKit is available.
#if canImport(UIKit)
import UIKit

public typealias NativeColor = UIColor
public typealias NativeImage = UIImage
public typealias NativeLabel = UILabel
public typealias NativeView = UIView
public typealias NativeEdgeInsets = UIEdgeInsets

#elseif canImport(AppKit)
import AppKit

public typealias NativeColor = NSColor
public typealias NativeImage = NSImage
public typealias NativeLabel = NSTextField
public typealias NativeView = NSView
public typealias NativeEdgeInsets = NSEdgeInsets
#endif
