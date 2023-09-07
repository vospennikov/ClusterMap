//
//  ContentView+DataSource.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 01.08.2023.
//

import ClusterMap
import Combine
import DataSource
import Foundation
import MapKit
import SwiftUI

extension ContentView.DataSource {
    struct MapAnnotation: Identifiable, CoordinateIdentifiable, Hashable {
        enum Style: Hashable {
            case single
            case cluster(count: Int)
        }

        var id = UUID()
        var coordinate: CLLocationCoordinate2D
        var style: Style = .single
    }
}

extension ContentView {
    final class DataSource: ObservableObject {
        private let coordinateRandomizer = CoordinateRandomizer()
        private let clusterManager = ClusterManager<MapAnnotation>()
        private var store = Set<AnyCancellable>()

        private var _region: MKCoordinateRegion = .sanFrancisco
        private var regionSubject = PassthroughSubject<MKCoordinateRegion, Never>()

        @Published var annotations: [MapAnnotation] = []
        var mapSize: CGSize = .zero
        var region: Binding<MKCoordinateRegion> {
            Binding(
                get: { self._region },
                set: { self.regionSubject.send($0) }
            )
        }

        func bind() {
            regionSubject
                .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
                .sink { newRegion in
                    self._region = newRegion
                    Task { await self.reloadAnnotations() }
                }
                .store(in: &store)
        }

        func addAnnotations() async {
            let points = coordinateRandomizer.generateRandomCoordinates(count: 10000, within: _region)
            let annotations = points.map { MapAnnotation(coordinate: $0) }

            clusterManager.add(annotations)
            await reloadAnnotations()
        }

        func removeAnnotations() async {
            clusterManager.removeAll()
            await reloadAnnotations()
        }

        private func reloadAnnotations() async {
            async let changes = clusterManager.reload(mapViewSize: mapSize, coordinateRegion: _region)
            await applyChanges(changes)
        }

        @MainActor
        private func applyChanges(_ difference: ClusterManager<MapAnnotation>.Difference) {
            for annotationType in difference.removals {
                switch annotationType {
                case .annotation(let annotation):
                    annotations.removeAll(where: { $0 == annotation })
                case .cluster(let clusterAnnotation):
                    annotations.removeAll(where: { $0.id == clusterAnnotation.id })
                }
            }
            for annotationType in difference.insertions {
                switch annotationType {
                case .annotation(let annotation):
                    annotations.append(annotation)
                case .cluster(let clusterAnnotation):
                    annotations.append(MapAnnotation(
                        id: clusterAnnotation.id,
                        coordinate: clusterAnnotation.coordinate,
                        style: .cluster(count: clusterAnnotation.memberAnnotations.count)
                    ))
                }
            }
        }
    }
}
