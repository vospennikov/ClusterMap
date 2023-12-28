//
//  ModernMap.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 31.07.2023.
//

import ClusterMap
import ClusterMapSwiftUI
import MapKit
import SwiftUI

@available(iOS 17.0, *)
struct ModernMap: View {
    @State private var dataSource = DataSource()

    var body: some View {
        Map(
            initialPosition: .region(dataSource.currentRegion),
            interactionModes: .all
        ) {
            ForEach(dataSource.annotations) { item in
                Marker(
                    "\(item.coordinate.latitude) \(item.coordinate.longitude)",
                    systemImage: "mappin",
                    coordinate: item.coordinate
                )
                .annotationTitles(.hidden)
            }
            ForEach(dataSource.clusters) { item in
                Marker(
                    "\(item.count)",
                    systemImage: "square.3.layers.3d",
                    coordinate: item.coordinate
                )
            }
        }
        .readSize(onChange: { newValue in
            dataSource.mapSize = newValue
        })
        .onMapCameraChange { context in
            dataSource.currentRegion = context.region
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            Task.detached { await dataSource.reloadAnnotations() }
        }
        .overlay(alignment: .bottom, content: {
            HStack {
                AsyncButton("Add annotations") {
                    await dataSource.addAnnotations()
                }
                Spacer()
                AsyncButton("Remove annotations") {
                    await dataSource.removeAnnotations()
                }
            }
            .padding()
            .buttonStyle(RoundedButton(fillColor: .accentColor, padding: 8))
        })
    }
}

@available(iOS 17.0, *)
#Preview {
    ModernMap()
}
