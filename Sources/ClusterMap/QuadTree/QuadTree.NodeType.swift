//
//  QuadTree.NodeType.swift
//
//
//  Created by Mikhail Vospennikov on 03.07.2023.
//

import Foundation

extension QuadTree {
    enum NodeType {
        case leaf
        case `internal`(children: Children)
    }
}
