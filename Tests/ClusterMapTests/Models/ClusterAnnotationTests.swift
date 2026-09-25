//
//  ClusterAnnotationTests.swift
//
//
//  Created by Mikhail Vospennikov on 25.09.2026.
//

import CoreLocation
import Testing
@testable import ClusterMap

struct ClusterAnnotationTests {
    typealias Manager = ClusterManager<StubAnnotation>

    @Test func equalClusters_haveEqualHashes() {
        let coordinate = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)
        let member = StubAnnotation(coordinate: coordinate)
        let lhs = Manager.ClusterAnnotation(coordinate: coordinate, memberAnnotations: [member])
        let rhs = Manager.ClusterAnnotation(coordinate: coordinate, memberAnnotations: [member])

        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
        #expect(Set([Manager.AnnotationType.cluster(lhs), .cluster(rhs)]).count == 1)
    }
}
