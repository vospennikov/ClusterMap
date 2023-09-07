//
//  Array+Additions.swift
//
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import Foundation
import MapKit

extension Array where Element: Equatable {
    func subtracted(_ other: [Element]) -> [Element] {
        filter { item in !other.contains { $0 == item } }
    }

    mutating func subtract(_ other: [Element]) {
        self = subtracted(other)
    }

    mutating func add(_ other: [Element]) {
        append(contentsOf: other)
    }

    @discardableResult
    mutating func remove(_ item: Element) -> Element? {
        firstIndex { $0 == item }.map { remove(at: $0) }
    }
}
