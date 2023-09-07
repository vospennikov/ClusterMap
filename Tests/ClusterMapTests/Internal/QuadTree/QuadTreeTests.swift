//
//  QuadTreeTests.swift
//
//
//  Created by Mikhail Vospennikov on 03.07.2023.
//

import Foundation
import MapKit
import XCTest
@testable import ClusterMap

final class QuadTreeTests: XCTestCase {
    func test_add_pointInsideBoundary_returnsTrue() {
        let point = StubAnnotation.insideMediumRect
        let quadTree = makeSUT(with: .mediumRect)

        let result = quadTree.add(point)
        let points = quadTree.findAnnotations(in: .mediumRect)

        XCTAssertTrue(result)
        XCTAssertTrue(points.contains(point))
    }

    func test_add_pointOutsideBoundary_returnsFalse() {
        let point = StubAnnotation.outsideMediumRect
        let quadTree = makeSUT(with: .mediumRect)

        let result = quadTree.add(point)
        let points = quadTree.findAnnotations(in: .mediumRect)

        XCTAssertFalse(result)
        XCTAssertFalse(points.contains(point))
    }

    func test_remove_pointInQuadTree_returnsTrue() {
        let point = StubAnnotation.insideMediumRect
        let quadTree = makeSUT(with: .mediumRect)

        quadTree.add(point)

        let result = quadTree.remove(point)
        let points = quadTree.findAnnotations(in: .mediumRect)

        XCTAssertNotNil(result)
        XCTAssertFalse(points.contains(point))
    }

    func test_remove_pointNotInQuadTree_returnsFalse() {
        let point = StubAnnotation.insideMediumRect
        let quadTree = makeSUT(with: .mediumRect)

        let result = quadTree.remove(point)
        let points = quadTree.findAnnotations(in: .mediumRect)

        XCTAssertNil(result)
        XCTAssertFalse(points.contains(point))
    }

    func test_pointsInRect_containingPointsInsideAndOutside_returnsPointsOnlyInsideSelectedRect() {
        let point1 = StubAnnotation.insideSmallRect
        let point2 = StubAnnotation.insideSmallRect
        let pointOutside = StubAnnotation.outsideSmallRect
        let quadTree = makeSUT(with: .mediumRect)

        quadTree.add(point1)
        quadTree.add(point2)
        quadTree.add(pointOutside)

        let points = quadTree.findAnnotations(in: .smallRect)

        XCTAssertTrue(points.contains(point1))
        XCTAssertTrue(points.contains(point2))
        XCTAssertFalse(points.contains(pointOutside), "\(pointOutside) \(points)")
    }
}

private extension QuadTreeTests {
    func makeSUT(with rect: MKMapRect = .world) -> QuadTree<StubAnnotation> {
        let quadTree = QuadTree<StubAnnotation>(rect: rect)
        trackForMemoryLeaks(quadTree)
        return quadTree
    }
}
