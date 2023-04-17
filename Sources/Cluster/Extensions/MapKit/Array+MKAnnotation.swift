//
//  Array+MKAnnotation.swift
//  
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import Foundation
import MapKit

extension Array where Element: MKAnnotation {
    /// Returns an array containing the elements that are present in the original array but not in the other array.
    /// - Parameter other: The other array to compare with.
    /// - Returns: An array containing the elements that are present in the original array but not in the other array.
    func subtracted(_ other: [Element]) -> [Element] {
        return filter { item in !other.contains { $0.isEqual(item) } }
    }
    
    /// Modifies the original array in place by removing the elements that are also present in the other array.
    /// - Parameter other: The other array to compare with.
    mutating func subtract(_ other: [Element]) {
        self = self.subtracted(other)
    }
    
    /// Appends an array of `MKAnnotation` elements to the original array.
    /// - Parameter other: The array of `MKAnnotation` elements to add.
    mutating func add(_ other: [Element]) {
        self.append(contentsOf: other)
    }

    /// Removes the first occurrence of an `MKAnnotation` element from the array and returns it.
    /// - Parameter item: The `MKAnnotation` element to remove.
    /// - Returns: The removed element, or `nil` if the element is not found in the array.
    @discardableResult
    mutating func remove(_ item: Element) -> Element? {
        return firstIndex { $0.isEqual(item) }.map { remove(at: $0) }
    }
}
