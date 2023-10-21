//
//  ContentView.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 21.10.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView(content: {
            Form(content: {
                Section {
                    NavigationLink(
                        destination: { LazyView(LegacyMap()) },
                        label: { Text("Map before iOS 17") }
                    )
                }

                if #available(iOS 17.0, *) {
                    Section {
                        NavigationLink(
                            destination: { LazyView(ModernMap()) },
                            label: { Text("Map since iOS 17") }
                        )
                        NavigationLink(
                            destination: { LazyView(MapKitIntegration()) },
                            label: { Text("Map with MKLocalSearchCompleter") }
                        )
                    }
                }
            })
        })
    }
}

#Preview {
    ContentView()
}
