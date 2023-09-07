//
//  QuadTreePerformanceTests.swift
//
//
//  Created by Mikhail Vospennikov on 02.09.2023.
//

import Foundation
import MapKit
import XCTest
@testable import ClusterMap

final class QuadTreePerformanceTests: XCTestCase {
    func test_add() {
        let points = (0...100_000).map { _ in StubAnnotation.insideMediumRect }

        measure {
            let quadTree = makeSUT(with: .mediumRect)
            for point in points {
                quadTree.add(point)
            }
        }
    }

    func test_remove() {
        let points = (0...100_000).map { _ in StubAnnotation.insideMediumRect }

        measure {
            let quadTree = makeSUT(with: .mediumRect)
            for point in points {
                quadTree.add(point)
            }
            for point in points {
                quadTree.remove(point)
            }
        }
    }

    func test_findAnnotations() {
        let points = (0...100_000).map { _ in StubAnnotation.insideMediumRect }
        let quadTree = makeSUT(with: .mediumRect)
        for point in points {
            quadTree.add(point)
        }

        measure {
            let _ = quadTree.findAnnotations(in: .smallRect)
        }
    }
}

private extension QuadTreePerformanceTests {
    func makeSUT(with rect: MKMapRect = .world) -> QuadTree<StubAnnotation> {
        let quadTree = QuadTree<StubAnnotation>(rect: rect)
        return quadTree
    }
}
