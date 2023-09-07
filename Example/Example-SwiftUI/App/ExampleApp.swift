//
//  ExampleApp.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 31.07.2023.
//

import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(dataSource: ContentView.DataSource())
        }
    }
}
