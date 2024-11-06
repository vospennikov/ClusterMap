//
//  SizeReader.swift
//
//
//  Created by Mikhail Vospennikov on 04.09.2023.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}

public extension View {
    /// Adds the ability to read the size of a `View` and report changes through a closure.
    ///
    /// Use `readSize(onChange:)` to get the dimensions of the view whenever it changes.
    ///
    /// - Parameter onChange: A closure that receives the `CGSize` of the view whenever it changes.
    ///
    /// Example:
    ///
    /// ```swift
    /// Text("Hello, world!")
    ///     .readSize { size in
    ///         print("Text size: \(size)")
    ///     }
    /// ```
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
