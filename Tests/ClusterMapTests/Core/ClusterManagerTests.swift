//
//  ClusterManagerTests.swift
//  Tests
//
//  Created by Lasha Efremidze on 7/11/18.
//  Copyright © 2018 efremidze. All rights reserved.
//

import MapKit
import XCTest
@testable import ClusterMap

final class ClusterManagerTests: XCTestCase {
    func testAddAndRemoveAllAnnotations() async {
        let clusterManager = makeSUT()
        let annotations = makeAnnotations(within: .mediumRect, count: 1000)

        await clusterManager.add(annotations)
        let difference = await clusterManager.reload(mapViewSize: .mediumMapSize, coordinateRegion: .mediumRegion)

        XCTAssertFalse(difference.insertions.isEmpty)
        XCTAssertTrue(difference.removals.isEmpty)

        await clusterManager.removeAll()
        let difference2 = await clusterManager.reload(mapViewSize: .mediumMapSize, coordinateRegion: .mediumRegion)

        XCTAssertTrue(difference2.insertions.isEmpty)
        XCTAssertTrue(!difference2.removals.isEmpty)

        XCTAssertEqual(difference.insertions.count, difference2.removals.count)
        XCTAssertEqual(difference2.insertions.count, difference.removals.count)
    }

    func testAddAndRemoveAnnotations() async {
        let clusterManager = makeSUT()
        let annotations = makeAnnotations(within: .mediumRect, count: 1000)

        await clusterManager.add(annotations)
        let difference = await clusterManager.reload(mapViewSize: .mediumMapSize, coordinateRegion: .mediumRegion)

        XCTAssertFalse(difference.insertions.isEmpty)
        XCTAssertTrue(difference.removals.isEmpty)

        await clusterManager.remove(annotations)
        let difference2 = await clusterManager.reload(mapViewSize: .mediumMapSize, coordinateRegion: .mediumRegion)

        XCTAssertTrue(difference2.insertions.isEmpty)
        XCTAssertTrue(!difference2.removals.isEmpty)

        XCTAssertEqual(difference.insertions.count, difference2.removals.count)
        XCTAssertEqual(difference2.insertions.count, difference.removals.count)
    }

    func testSameCoordinate() async {
        let clusterManager = makeSUT(with: .init(shouldDistributeAnnotationsOnSameCoordinate: false))
        let annotations = makeAnnotations(within: .mediumRect, count: 1000)

        await clusterManager.add(annotations)
        await clusterManager.reload(mapViewSize: .mediumMapSize, coordinateRegion: .mediumRegion)

        let annotationsCount = await clusterManager.fetchVisibleNestedAnnotations().count
        XCTAssertTrue(annotationsCount == 1000)
    }

    func testRemoveInvisibleAnnotations() async {
        let clusterManager = makeSUT(with: .init(shouldRemoveInvisibleAnnotations: false))
        let annotations = makeAnnotations(within: .mediumRect, count: 1000)

        await clusterManager.add(annotations)
        await clusterManager.reload(mapViewSize: .mediumMapSize, coordinateRegion: .mediumRegion)

        let annotationsCount = await clusterManager.fetchVisibleNestedAnnotations().count
        XCTAssertTrue(annotationsCount == 1000)
    }

    func testMinCountForClustering() async {
        let clusterManager = makeSUT(with: .init(minCountForClustering: 10))
        let annotations = makeAnnotations(within: .mediumRect, count: 1000)

        await clusterManager.add(annotations)
        await clusterManager.reload(mapViewSize: .mediumMapSize, coordinateRegion: .mediumRegion)

        let annotationsCount = await clusterManager.fetchVisibleNestedAnnotations().count
        XCTAssertTrue(annotationsCount == 1000)
    }

    func testMultipleOperations() async {
        let clusterManager = makeSUT()
        let annotations = makeAnnotations(within: .mediumRect, count: 10)

        await clusterManager.removeAll()
        await clusterManager.add(annotations)

        let annotations2 = makeAnnotations(within: .mediumRect, count: 100)
        await clusterManager.removeAll()
        await clusterManager.add(annotations2)

        let annotationsCount = await clusterManager.fetchAllAnnotations().count
        XCTAssertTrue(annotationsCount == 100, "\(annotationsCount)")
    }
}

private extension ClusterManagerTests {
    func makeSUT(
        with configuration: ClusterManager<StubAnnotation>.Configuration = .init()
    ) -> ClusterManager<StubAnnotation> {
        let manager = ClusterManager<StubAnnotation>(configuration: configuration)
        trackForMemoryLeaks(manager)
        return manager
    }

    func makeAnnotations(within rect: MKMapRect, count: Int) -> [StubAnnotation] {
        (0..<count).map { _ in StubAnnotation(coordinate: MKCoordinateRegion(rect).randomLocationWithinRegion()) }
    }
}
