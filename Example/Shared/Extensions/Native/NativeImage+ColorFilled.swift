//
//  NativeImage+ColorFilled.swift
//  Example-iOS
//
//  Created by Mikhail Vospennikov on 10.02.2023.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension NativeImage {
    func filled(with color: NativeColor) -> NativeImage {
        #if canImport(UIKit)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = self.cgImage else { return self }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
        
        #elseif canImport(AppKit)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        guard let context = NSGraphicsContext.current else { return self }
        context.cgContext.saveGState()

        color.setFill()
        context.cgContext.translateBy(x: 0, y: size.height)
        context.cgContext.scaleBy(x: 1.0, y: -1.0)
        context.cgContext.setBlendMode(.normal)

        guard let mask = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return self }
        context.cgContext.clip(to: rect, mask: mask)
        context.cgContext.fill(rect)

        let newImage = context.cgContext.makeImage()!
        context.cgContext.restoreGState()
        return NSImage(cgImage: newImage, size: size)
        #endif
    }
}
