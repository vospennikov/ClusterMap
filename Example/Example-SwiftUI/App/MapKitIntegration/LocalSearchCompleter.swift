//
//  LocalSearchCompleter.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 21.10.2023.
//

import ClusterMap
import Foundation
import MapKit

@available(iOS 17.0, *)
extension MapKitIntegration {
    struct ExampleClusterAnnotation: Identifiable {
        var id = UUID()
        var coordinate: CLLocationCoordinate2D
        var count: Int
    }

    @Observable
    class LocalSearchCompleter: NSObject, MKLocalSearchCompleterDelegate {
        private let completer = MKLocalSearchCompleter()
        private let clusterManager = ClusterManager<MKMapItem>()

        var mapSize: CGSize = .zero
        var currentRegion: MKCoordinateRegion = .sanFrancisco
        var annotations = [MKMapItem]()
        var clusters = [ExampleClusterAnnotation]()

        func setup() {
            completer.delegate = self
        }

        func search() async {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = "Apple Store"
            request.region = currentRegion

            do {
                async let searchResult = MKLocalSearch(request: request).start()
                await clusterManager.removeAll()
                try await clusterManager.add(searchResult.mapItems)
                await reloadAnnotations()
            } catch {
                assertionFailure("Error: \(error.localizedDescription)")
            }
        }

        func reloadAnnotations() async {
            async let changes = clusterManager.reload(mapViewSize: mapSize, coordinateRegion: currentRegion)
            await applyChanges(changes)
        }

        @MainActor
        private func applyChanges(_ difference: ClusterManager<MKMapItem>.Difference) {
            for removal in difference.removals {
                switch removal {
                case .annotation(let annotation):
                    annotations.removeAll { $0 == annotation }
                case .cluster(let clusterAnnotation):
                    clusters.removeAll { $0.id == clusterAnnotation.id }
                @unknown default:
                    fatalError()
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
                @unknown default:
                    fatalError()
                }
            }
        }
    }
}

extension MKMapItem: CoordinateIdentifiable, Identifiable {
    public var id: String {
        placemark.region?.identifier ?? UUID().uuidString
    }

    public var coordinate: CLLocationCoordinate2D {
        get { placemark.coordinate }
        set(newValue) { }
    }
}
