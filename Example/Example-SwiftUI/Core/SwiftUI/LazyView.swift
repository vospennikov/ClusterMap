//
//  LazyView.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 21.10.2023.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content

    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}
