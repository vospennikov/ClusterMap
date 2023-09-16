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
            mapView
            annotationControls
        }
        .onAppear {
            dataSource.bind()
        }
    }

    private var mapView: some View {
        Group {
            if #available(iOS 17.0, *) {
                modernMapView
            } else {
                legacyMapView
            }
        }
        .ignoresSafeArea()
        .readSize(onChange: { newValue in
            dataSource.mapSize = newValue
        })
    }

    @available(iOS 17.0, *)
    private var modernMapView: some View {
        Map(
            initialPosition: .region(dataSource.initialPosition),
            interactionModes: .all
        ) {
            ForEach(dataSource.annotations) { item in
                switch item.style {
                case .single:
                    Marker("", coordinate: item.coordinate)
                case .cluster(let count):
                    Marker("\(count)", coordinate: item.coordinate)
                }
            }
        }
        .onMapCameraChange { context in
            dataSource.regionSubject.send(context.region)
        }
    }

    private var legacyMapView: some View {
        Map(
            coordinateRegion: dataSource.region,
            interactionModes: .all,
            annotationItems: dataSource.annotations,
            annotationContent: mapItem(for:)
        )
    }

    private var annotationControls: some View {
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
