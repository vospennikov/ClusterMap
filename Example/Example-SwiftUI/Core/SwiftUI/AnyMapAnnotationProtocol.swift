//
//  AnyMapAnnotationProtocol.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 05.09.2023.
//

import Foundation
import MapKit
import SwiftUI

struct AnyMapAnnotationProtocol: MapAnnotationProtocol {
    let _annotationData: _MapAnnotationData
    let value: Any

    init(_ value: some MapAnnotationProtocol) {
        self.value = value
        _annotationData = value._annotationData
    }
}
