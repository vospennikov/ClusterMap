//
//  ClusterManagerReloadTests.swift
//
//
//  Created by Mikhail Vospennikov on 25.09.2026.
//

import MapKit
import Testing
@testable import ClusterMap

struct ClusterManagerReloadTests {
    @Test @MainActor func mapView_returnsSameDifferenceAsSizeAndRegion() async {
        let coordinate = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)
        let mapView = MKMapView(frame: CGRect(origin: .zero, size: .mediumMapSize))
        mapView.region = MKCoordinateRegion(center: coordinate, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
        let annotation = StubAnnotation(coordinate: coordinate)
        let viaMapView = ClusterManager<StubAnnotation>()
        let viaSizeAndRegion = ClusterManager<StubAnnotation>()
        await viaMapView.add(annotation)
        await viaSizeAndRegion.add(annotation)

        let difference = await viaMapView.reload(mkMapView: mapView)
        let expected = await viaSizeAndRegion.reload(mapViewSize: mapView.bounds.size, coordinateRegion: mapView.region)

        #expect(difference.insertions == expected.insertions)
        #expect(difference.removals == expected.removals)
        #expect(!difference.insertions.isEmpty)
    }

    @Test(arguments: [
        (CGSize.zero, 0.05),
        (CGSize.mediumMapSize, 0.0),
        (CGSize.zero, 0.0),
        (CGSize(width: -428, height: -926), 0.05),
    ])
    func zeroOrNegativeVisibleArea_removesVisibleAnnotations(
        mapViewSize: CGSize,
        span: CLLocationDegrees
    ) async throws {
        let coordinate = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)
        let visibleRegion = MKCoordinateRegion(
            center: coordinate,
            span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        let emptyRegion = MKCoordinateRegion(center: coordinate, span: .init(latitudeDelta: span, longitudeDelta: span))
        let manager = ClusterManager<StubAnnotation>()
        await manager.add(StubAnnotation(coordinate: coordinate))
        await manager.reload(mapViewSize: .mediumMapSize, coordinateRegion: visibleRegion)
        let visibleBefore = await manager.visibleAnnotations
        try #require(!visibleBefore.isEmpty)

        let difference = await manager.reload(mapViewSize: mapViewSize, coordinateRegion: emptyRegion)
        let visibleAfter = await manager.visibleAnnotations

        #expect(difference.insertions.isEmpty)
        #expect(difference.removals == visibleBefore)
        #expect(visibleAfter.isEmpty)
    }

    @Test func worldZoomRegion_showsAllAnnotations() async {
        let annotations = [-150.0, -60, 0, 60, 150].map {
            StubAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: $0))
        }
        let worldRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: .init(latitudeDelta: 170, longitudeDelta: 400),
        )
        let manager = ClusterManager<StubAnnotation>()
        await manager.add(annotations)

        await manager.reload(mapViewSize: .mediumMapSize, coordinateRegion: worldRegion)
        let visible = await manager.fetchVisibleNestedAnnotations()

        #expect(visible.count == annotations.count)
        #expect(Set(visible) == Set(annotations))
    }

    @Test(arguments: [
        (180.0, 60.0, [stride(from: 150.5, to: 180, by: 1), stride(from: -179.5, to: -150, by: 1)]),
        (170.0, 360.0, [stride(from: -179.5, to: 180, by: 1)]),
    ])
    func dateLineRegion_showsEachAnnotationOnce(
        centerLongitude: CLLocationDegrees,
        longitudeDelta: CLLocationDegrees,
        longitudes: [StrideTo<CLLocationDegrees>],
    ) async {
        let annotations = longitudes.joined().map {
            StubAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: $0))
        }
        let dateLineRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: centerLongitude),
            span: .init(latitudeDelta: 60, longitudeDelta: longitudeDelta),
        )
        let manager = ClusterManager<StubAnnotation>()
        await manager.add(annotations)

        await manager.reload(mapViewSize: .mediumMapSize, coordinateRegion: dateLineRegion)
        let visible = await manager.fetchVisibleNestedAnnotations()

        #expect(visible.count == annotations.count)
        #expect(Set(visible) == Set(annotations))
    }

    @Test func dateLineRegion_excludesOtherLatitudes() async {
        let inside = [
            StubAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 179)),
            StubAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: -179)),
        ]
        let outside = StubAnnotation(coordinate: CLLocationCoordinate2D(latitude: 60, longitude: 179))
        let dateLineRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 180),
            span: .init(latitudeDelta: 10, longitudeDelta: 10),
        )
        let manager = ClusterManager<StubAnnotation>()
        await manager.add(inside + [outside])

        await manager.reload(mapViewSize: .mediumMapSize, coordinateRegion: dateLineRegion)
        let visible = await manager.fetchVisibleNestedAnnotations()

        #expect(Set(visible) == Set(inside))
    }

    @Test func regionNearDateLine_excludesAnnotationsPastDateLine() async {
        let inside = StubAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 179.9))
        let pastDateLine = StubAnnotation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: -179.9))
        let regionNearDateLine = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 169.95),
            span: .init(latitudeDelta: 20, longitudeDelta: 20),
        )
        let manager = ClusterManager<StubAnnotation>()
        await manager.add([inside, pastDateLine])

        await manager.reload(mapViewSize: .mediumMapSize, coordinateRegion: regionNearDateLine)
        let visible = await manager.fetchVisibleNestedAnnotations()

        #expect(visible == [inside])
    }
}
