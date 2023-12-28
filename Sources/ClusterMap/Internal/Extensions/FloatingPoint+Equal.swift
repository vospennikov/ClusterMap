//
//  FloatingPoint+Equal.swift
//
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import Foundation

extension FloatingPoint {
    func isNearlyEqual(to value: Self) -> Bool {
        if self == value {
            return true
        }
        
        let absA = abs(self)
        let absB = abs(value)
        let diff = abs(self - value)
        
        if self == .zero || value == .zero || (absA + absB) < .leastNormalMagnitude {
            return isDiffLessThanUlp(diff)
        } else {
            return isDiffSmallEnough(diff, absA, absB)
        }
    }
    
    private func isDiffLessThanUlp(_ diff: Self) -> Bool {
        return diff < .ulpOfOne * .leastNormalMagnitude
    }
    
    private func isDiffSmallEnough(_ diff: Self, _ absA: Self, _ absB: Self) -> Bool {
        let sumMin = min(absA + absB, .greatestFiniteMagnitude)
        return diff / sumMin < .ulpOfOne
    }
}
