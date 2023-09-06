//
//  ClusterAnnotationView.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 05.09.2023.
//

import SwiftUI

struct ClusterAnnotationView: View {
    var count: Int

    var body: some View {
        Text("\(count)")
            .lineLimit(1)
            .foregroundColor(.white)
            .frame(width: 44.0, height: 44.0, alignment: .center)
            .background {
                Circle()
                    .aspectRatio(1 / 1, contentMode: .fill)
                    .foregroundColor(Color.blue)
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 2.0)
                            .foregroundColor(.white)
                    }
                    .shadow(color: .black.opacity(0.2), radius: 25.0, x: 5, y: 10)
            }
    }
}

struct ClusterAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            VStack {
                ClusterAnnotationView(count: 1)
                ClusterAnnotationView(count: 12)
                ClusterAnnotationView(count: 123)
                ClusterAnnotationView(count: 1234)
            }
        }
        .ignoresSafeArea()
    }
}
