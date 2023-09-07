//
//  AsyncButton.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 31.08.2023.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
    @State private var isPerformingTask = false

    var action: () async -> Void
    @ViewBuilder var label: () -> Label

    var body: some View {
        Button(
            action: {
                isPerformingTask = true
                Task {
                    await action()
                    isPerformingTask = false
                }
            },
            label: {
                label().opacity(isPerformingTask ? 0.5 : 1)
            }
        )
        .disabled(isPerformingTask)
    }
}

extension AsyncButton where Label == Text {
    init(_ label: String, action: @escaping () async -> Void) {
        self.init(action: action) {
            Text(label)
        }
    }
}
