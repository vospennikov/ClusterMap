//
//  ClusterAnnotationTests.swift
//
//
//  Created by Mikhail Vospennikov on 06.02.2023.
//

import XCTest
@testable import ClusterMap

final class ClusterAnnotationTests: XCTestCase {
    func testAnnotations() {
        let identifier = "identifier"
        let annotation = ClusterAnnotation()
        let text = "\(annotation.annotations.count)"
        let annotationView = ClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.prepareForDisplay()
        XCTAssertEqual(annotationView.reuseIdentifier, identifier)
        if let _annotation = annotationView.annotation as? ClusterAnnotation {
            XCTAssertEqual(_annotation, annotation)
            XCTAssertEqual(annotationView.countLabel.nativeText, text)
        } else {
            XCTAssertTrue(false)
        }
    }
}
