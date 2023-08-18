//
//  FloatingPoint.swift
//
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import Foundation

extension FloatingPoint {
    func isNearlyEqual(to value: Self) -> Bool {
        let absA = abs(self)
        let absB = abs(value)
        let diff = abs(self - value)

        if self == value {
            return true
        } else if self == .zero || value == .zero || (absA + absB) < .leastNormalMagnitude {
            return diff < .ulpOfOne * .leastNormalMagnitude
        } else {
            return diff / min(absA + absB, .greatestFiniteMagnitude) < .ulpOfOne
        }
    }
}
