//
//  Array+MKAnnotation.swift
//  
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import Foundation
import MapKit

extension Array where Element: MKAnnotation {
    func subtracted(_ other: [Element]) -> [Element] {
        return filter { item in !other.contains { $0.isEqual(item) } }
    }
    
    mutating func subtract(_ other: [Element]) {
        self = self.subtracted(other)
    }
    
    mutating func add(_ other: [Element]) {
        self.append(contentsOf: other)
    }
    
    @discardableResult
    mutating func remove(_ item: Element) -> Element? {
        return firstIndex { $0.isEqual(item) }.map { remove(at: $0) }
    }
}
