//
//  Background.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 06.09.2023.
//

import SwiftUI

extension View {
    func background(alignment: Alignment = .center, @ViewBuilder _ content: () -> some View) -> some View {
        background(content(), alignment: alignment)
    }
}
