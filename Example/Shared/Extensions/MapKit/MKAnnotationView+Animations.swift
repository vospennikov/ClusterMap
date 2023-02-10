//
//  MKAnnotationView+Animations.swift
//  Example
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import Foundation
import MapKit
import UIKit

extension Collection where Element == MKAnnotationView {
    func appearingAnimation() {
        self.forEach { annotationView in
            annotationView.alpha = 0
        }
        
        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                self.forEach { annotationView in
                    annotationView.alpha = 1
                }
            },
            completion: nil
        )
    }
}
