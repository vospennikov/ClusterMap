//
//  ClusterAnnotationStyle.swift
//  
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import UIKit

/**
 The style of the cluster annotation view.
 */
public enum ClusterAnnotationStyle {
    /**
     Displays the annotations as a circle.
     
     - `color`: The color of the annotation circle
     - `radius`: The radius of the annotation circle
     */
    case color(UIColor, radius: CGFloat)
    
    /**
     Displays the annotation as an image.
     */
    case image(UIImage?)
}
