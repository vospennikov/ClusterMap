//
//  NativeLabel.swift
//  
//
//  Created by Mikhail Vospennikov on 09.02.2023.
//

#if canImport(UIKit)
import UIKit
public typealias NativeLabel = UILabel

#elseif canImport(Cocoa)
import Cocoa
public typealias NativeLabel = NSTextField
#endif
