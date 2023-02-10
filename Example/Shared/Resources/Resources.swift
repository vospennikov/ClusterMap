//
//  Resources.swift
//  Cluster
//
//  Created by Lasha Efremidze on 7/8/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

extension NativeImage {
    static let pin: NativeImage? = .init(named: "pin")?.filled(with: .annotationGreen)
    static let pin2: NativeImage? = .init(named: "pin2")?.filled(with: .annotationGreen)
    static let me: NativeImage? = .init(named: "me")?.filled(with: .annotationBlue)
}

extension NativeColor {
    static let accentColor: NativeColor? = .init(named: "AccentColor")
}
