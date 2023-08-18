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
    func test_add_whenAnnotationInside_shouldReturnTrue() {
        let quadTree = makeSUT(with: .applePark)
        let annotation = MockAnnotation(coordinate: Locations.ApplePark)
        let addResult = quadTree.add(annotation)

        XCTAssertTrue(addResult)
    }

    func test_add_whenAnnotationOutside_shouldReturnFalse() {
        let quadTree = makeSUT(with: .applePark)
        let annotation = MockAnnotation(coordinate: Locations.MicrosoftHeadquarters)
        let addResult = quadTree.add(annotation)

        XCTAssertFalse(addResult)
    }

    func test_remove_whenAnnotationExiting_shouldReturnTrue() {
        let quadTree = makeSUT()
        let annotation = MockAnnotation(coordinate: Locations.ApplePark)

        let addResult = quadTree.add(annotation)
        let removeResult = quadTree.remove(annotation)

        XCTAssertTrue(addResult)
        XCTAssertTrue(removeResult)
    }

    func test_remove_whenAnnotationNonExistent_shouldReturnFalse() {
        let quadTree = makeSUT()
        let annotation = MockAnnotation(coordinate: Locations.ApplePark)

        let removeResult = quadTree.remove(annotation)

        XCTAssertFalse(removeResult)
    }

    func test_annotations() {
        let quadTree = makeSUT(with: .appleAndMicrosoftHeadquarters)

        let annotation1 = MockAnnotation(coordinate: Locations.ApplePark)
        let annotation2 = MockAnnotation(coordinate: Locations.MicrosoftHeadquarters)

        let addAnnotation1Result = quadTree.add(annotation1)
        let addAnnotation2Result = quadTree.add(annotation2)

        let annotations = quadTree.findAnnotations(in: .appleAndMicrosoftHeadquarters)

        XCTAssertEqual(annotations.count, 2)
    }
}

private extension QuadTreeTests {
    func makeSUT(with rect: MKMapRect = .world) -> QuadTree {
        QuadTree(rect: rect)
    }
}
