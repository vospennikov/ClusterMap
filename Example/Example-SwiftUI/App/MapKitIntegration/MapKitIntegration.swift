//
//  MapKitIntegration.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 17.10.2023.
//

import DataSource
import MapKit
import SwiftUI

@available(iOS 17.0, *)
struct MapKitIntegration: View {
    @State private var searchClient = LocalSearchCompleter()
    @State private var isSheetPresented = true

    var body: some View {
        Map(
            initialPosition: .region(searchClient.currentRegion),
            interactionModes: .all
        ) {
            ForEach(searchClient.annotations) { item in
                Marker(
                    "\(item.coordinate.latitude) \(item.coordinate.longitude)",
                    systemImage: "mappin",
                    coordinate: item.coordinate
                )
                .annotationTitles(.hidden)
            }
            ForEach(searchClient.clusters) { item in
                Marker(
                    "\(item.count)",
                    systemImage: "square.3.layers.3d",
                    coordinate: item.coordinate
                )
            }
        }
        .overlay(alignment: .bottom) {
            Button(
                action: { Task.detached { await searchClient.search() } },
                label: { Label("Apple store", systemImage: "magnifyingglass") }
            )
            .buttonStyle(RoundedButton(fillColor: .accentColor, padding: 8))
        }
        .readSize(onChange: { newValue in
            searchClient.mapSize = newValue
        })
        .onMapCameraChange { context in
            searchClient.currentRegion = context.region
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            Task.detached { await searchClient.reloadAnnotations() }
        }
        .onAppear {
            searchClient.setup()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    MapKitIntegration()
}
