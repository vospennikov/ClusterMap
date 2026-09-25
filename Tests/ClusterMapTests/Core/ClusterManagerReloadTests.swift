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
}
