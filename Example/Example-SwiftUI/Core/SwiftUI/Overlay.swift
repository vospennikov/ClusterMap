//
//  Overlay.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 06.09.2023.
//

import SwiftUI

extension View {
    func overlay(alignment: Alignment = .center, @ViewBuilder _ content: () -> some View) -> some View {
        overlay(content(), alignment: alignment)
    }
}
