//
//  UIViewController+Preview.swift
//  Example
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import SwiftUI
import UIKit

extension UIViewController {
    struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
      
        func makeUIViewController(context: Context) -> UIViewController {
            viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    public var preview: some View {
        return Preview(viewController: self)
    }
}
