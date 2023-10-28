//
//  ModernMap+DataSource.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 01.08.2023.
//

import ClusterMap
import DataSource
import Foundation
import MapKit

@available(iOS 17.0, *)
extension ModernMap {
    struct ExampleAnnotation: Identifiable, CoordinateIdentifiable, Hashable {
        var id = UUID()
        var coordinate: CLLocationCoordinate2D
    }

    struct ExampleClusterAnnotation: Identifiable {
        var id = UUID()
        var coordinate: CLLocationCoordinate2D
        var count: Int
    }

    @Observable
    final class DataSource: ObservableObject {
        private let coordinateRandomizer = CoordinateRandomizer()
        private let clusterManager = ClusterManager<ExampleAnnotation>()

        var annotations: [ExampleAnnotation] = []
        var clusters: [ExampleClusterAnnotation] = []

        var mapSize: CGSize = .zero
        var currentRegion: MKCoordinateRegion = .sanFrancisco

        func addAnnotations() async {
            let points = coordinateRandomizer.generateRandomCoordinates(count: 10000, within: currentRegion)
            let newAnnotations = points.map { ExampleAnnotation(coordinate: $0) }
            await clusterManager.add(newAnnotations)
            await reloadAnnotations()
        }

        func removeAnnotations() async {
            await clusterManager.removeAll()
            await reloadAnnotations()
        }

        func reloadAnnotations() async {
            async let changes = clusterManager.reload(mapViewSize: mapSize, coordinateRegion: currentRegion)
            await applyChanges(changes)
        }

        @MainActor
        private func applyChanges(_ difference: ClusterManager<ExampleAnnotation>.Difference) {
            for removal in difference.removals {
                switch removal {
                case .annotation(let annotation):
                    annotations.removeAll { $0 == annotation }
                case .cluster(let clusterAnnotation):
                    clusters.removeAll { $0.id == clusterAnnotation.id }
                }
            }
            for insertion in difference.insertions {
                switch insertion {
                case .annotation(let newItem):
                    annotations.append(newItem)
                case .cluster(let newItem):
                    clusters.append(ExampleClusterAnnotation(
                        id: newItem.id,
                        coordinate: newItem.coordinate,
                        count: newItem.memberAnnotations.count
                    ))
                }
            }
        }
    }
}
