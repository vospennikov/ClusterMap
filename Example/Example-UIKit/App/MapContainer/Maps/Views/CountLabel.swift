//
//  CountLabel.swift
//  Example-UIKit
//
//  Created by Mikhail Vospennikov on 29.08.2023.
//

import UIKit

final class CountLabel: UILabel {
    final func configure() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.5
        baselineAdjustment = .alignCenters
        numberOfLines = 1
        backgroundColor = .clear
        font = .boldSystemFont(ofSize: 13)
        textColor = .white
        textAlignment = .center
    }
}
