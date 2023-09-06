//
//  MapController.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 06.09.2023.
//

import Foundation
import MapKit
import UIKit

protocol MapController: UIViewController {
    init(initialRegion: MKCoordinateRegion)

    var visibleRegion: MKCoordinateRegion { get }
    var currentAnnotations: [MKAnnotation] { get }

    func addAnnotations(_ annotations: [MKAnnotation]) async
    func removeAllAnnotations() async
    func changeAnnotationsType(_ newType: AnnotationTypes) async
}
