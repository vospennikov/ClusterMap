//
//  ClusterManagerConfigurationTests.swift
//
//
//  Created by Mikhail Vospennikov on 25.09.2026.
//

import MapKit
import Testing
@testable import ClusterMap

struct ClusterManagerConfigurationTests {
    @Test(arguments: [0, -1])
    func nonPositiveMinCountForClustering_behavesAsOne(minCount: Int) async {
        let coordinate = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)
        let region = MKCoordinateRegion(center: coordinate, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
        let configuration = ClusterManager<StubAnnotation>.Configuration(minCountForClustering: minCount)
        let manager = ClusterManager<StubAnnotation>(configuration: configuration)
        let annotation = StubAnnotation(coordinate: coordinate)

        await manager.add(annotation)
        let difference = await manager.reload(mapViewSize: .mediumMapSize, coordinateRegion: region)

        #expect(configuration.minCountForClustering == 1)
        #expect(difference.insertions == [.cluster(.init(coordinate: coordinate, memberAnnotations: [annotation]))])
    }
}
