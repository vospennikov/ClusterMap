//
//  Node+Type.swift
//
//
//  Created by Mikhail Vospennikov on 03.07.2023.
//

import Foundation

extension Node {
    enum `Type` {
        case leaf
        case `internal`(children: Children)
    }
}
