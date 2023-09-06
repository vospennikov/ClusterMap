//
//  AnnotationTypes.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 08.02.2023.
//

import Foundation

enum AnnotationTypes: Int, CaseIterable {
    case count
    case imageCount
    case image

    var description: String {
        switch self {
        case .count: return "Count"
        case .imageCount: return "Image count"
        case .image: return "Image"
        }
    }
}
