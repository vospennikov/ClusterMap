//
//  LegacyMap+DataSource.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 21.10.2023.
//

import ClusterMap
import Combine
import DataSource
import Foundation
import MapKit
import SwiftUI

extension LegacyMap {
    struct Annotation: Identifiable, CoordinateIdentifiable, Hashable {
        enum Style: Hashable {
            case single
            case cluster(count: Int)
        }

        var id = UUID()
        var coordinate: CLLocationCoordinate2D
        var style: Style = .single
    }

    final class DataSource: ObservableObject {
        private let coordinateRandomizer = CoordinateRandomizer()
        private let clusterManager = ClusterManager<Annotation>()
        private var cancellables = Set<AnyCancellable>()

        @Published var annotations: [Annotation] = []

        var mapSize: CGSize = .zero
        var regionSubject = PassthroughSubject<MKCoordinateRegion, Never>()

        private var _region: MKCoordinateRegion = .sanFrancisco
        var region: Binding<MKCoordinateRegion> {
            Binding(
                get: { self._region },
                set: { newValue in self.regionSubject.send(newValue) }
            )
        }

        func bind() {
            regionSubject
                .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
                .sink { newRegion in
                    self._region = newRegion
                    Task { await self.reloadAnnotations() }
                }
                .store(in: &cancellables)
        }

        func addAnnotations() async {
            let points = coordinateRandomizer.generateRandomCoordinates(count: 10000, within: _region)
            let newAnnotations = points.map { Annotation(coordinate: $0) }

            await clusterManager.add(newAnnotations)
            await reloadAnnotations()
        }

        func removeAnnotations() async {
            await clusterManager.removeAll()
            await reloadAnnotations()
        }

        private func reloadAnnotations() async {
            async let changes = clusterManager.reload(mapViewSize: mapSize, coordinateRegion: _region)
            await applyChanges(changes)
        }

        @MainActor
        private func applyChanges(_ difference: ClusterManager<Annotation>.Difference) {
            for removal in difference.removals {
                switch removal {
                case .annotation(let annotation):
                    annotations.removeAll { $0 == annotation }
                case .cluster(let clusterAnnotation):
                    annotations.removeAll { $0.id == clusterAnnotation.id }
                @unknown default:
                    fatalError()
                }
            }

            for insertion in difference.insertions {
                switch insertion {
                case .annotation(let newItem):
                    annotations.append(newItem)
                case .cluster(let newItem):
                    annotations.append(Annotation(
                        id: newItem.id,
                        coordinate: newItem.coordinate,
                        style: .cluster(count: newItem.memberAnnotations.count)
                    ))
                @unknown default:
                    fatalError()
                }
            }
        }
    }
}
