//
//  RoundedButton.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 01.08.2023.
//

import SwiftUI

struct RoundedButton: ButtonStyle {
    var fillColor: Color
    var padding: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .colorInvert()
            .padding(.all, padding)
            .background(fillColor.opacity(configuration.isPressed ? 0.8 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
