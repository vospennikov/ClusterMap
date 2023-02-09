//
//  File.swift
//  
//
//  Created by Mikhail Vospennikov on 09.02.2023.
//

#if canImport(UIKit)
import UIKit
public typealias NativeImage = UIImage

#elseif canImport(AppKit)
import AppKit
public typealias NativeImage = NSImage
#endif
