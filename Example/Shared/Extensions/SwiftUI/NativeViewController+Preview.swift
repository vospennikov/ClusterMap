//
//  NativeViewController+Preview.swift
//  Example
//
//  Created by Mikhail Vospennikov on 07.02.2023.
//

import SwiftUI

extension NativeViewController {
    struct Preview: NativeViewControllerRepresentable {
        let viewController: NativeViewController
      
        func makeNSViewController(context: Context) -> NativeViewController {
            viewController
        }
        
        func makeUIViewController(context: Context) -> NativeViewController {
            viewController
        }
        
        func updateUIViewController(_ uiViewController: NativeViewController, context: Context) {}
        func updateNSViewController(_ nsViewController: NativeViewController, context: Context) {}
    }
    
    public var preview: some View {
        return Preview(viewController: self)
    }
}
