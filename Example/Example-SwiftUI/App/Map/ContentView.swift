//
//  ContentView.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 31.07.2023.
//

import ClusterMap
import ClusterMapSwiftUI
import MapKit
import SwiftUI

struct ContentView: View {
    @ObservedObject var dataSource: DataSource

    var body: some View {
        ZStack {
            Map(
                coordinateRegion: dataSource.region,
                interactionModes: .all,
                annotationItems: dataSource.annotations,
                annotationContent: mapItem(for:)
            )
            .ignoresSafeArea()
            .readSize { newValue in
                dataSource.mapSize = newValue
            }
            .onAppear {
                dataSource.bind()
            }

            VStack {
                Spacer()
                HStack {
                    AsyncButton("Add annotations") {
                        await dataSource.addAnnotations()
                    }
                    Spacer()
                    AsyncButton("Remove annotations") {
                        await dataSource.removeAnnotations()
                    }
                }
                .padding(.vertical, 36)
                .padding(.horizontal)
                .buttonStyle(RoundedButton(fillColor: .accentColor, padding: 8))
            }
        }
    }

    private func mapItem(for annotation: ContentView.DataSource.MapAnnotation) -> some MapAnnotationProtocol {
        switch annotation.style {
        case .single:
            return AnyMapAnnotationProtocol(MapPin(coordinate: annotation.coordinate))
        case .cluster(let count):
            return AnyMapAnnotationProtocol(MapAnnotation(coordinate: annotation.coordinate) {
                ClusterAnnotationView(count: count)
                    .onTapGesture {
                        print(count)
                    }
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataSource: ContentView.DataSource())
    }
}
