//
//  Native+TypeAliases.swift
//  Example-macOS
//
//  Created by Mikhail Vospennikov on 10.02.2023.
//

import SwiftUI

#if canImport(UIKit)
import UIKit

typealias NativeImage = UIImage
typealias NativeColor = UIColor
typealias NativeView = UIView
typealias NativeViewController = UIViewController
typealias NativeViewControllerRepresentable = UIViewControllerRepresentable

#elseif canImport(AppKit)
import AppKit

typealias NativeImage = NSImage
typealias NativeColor = NSColor
typealias NativeView = NSView
typealias NativeViewController = NSViewController
typealias NativeViewControllerRepresentable = NSViewControllerRepresentable
#endif
