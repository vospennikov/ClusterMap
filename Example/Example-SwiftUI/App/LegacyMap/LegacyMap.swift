//
//  LegacyMap.swift
//  Example-SwiftUI
//
//  Created by Mikhail Vospennikov on 21.10.2023.
//

import ClusterMap
import ClusterMapSwiftUI
import MapKit
import SwiftUI

struct LegacyMap: View {
    @StateObject private var dataSource = DataSource()

    var body: some View {
        Map(
            coordinateRegion: dataSource.region,
            interactionModes: .all,
            annotationItems: dataSource.annotations,
            annotationContent: mapItem(for:)
        )
        .ignoresSafeArea()
        .readSize(onChange: { newValue in
            dataSource.mapSize = newValue
        })
        .overlay(alignment: .bottom) {
            HStack {
                AsyncButton("Add annotations") {
                    await dataSource.addAnnotations()
                }
                Spacer()
                AsyncButton("Remove annotations") {
                    await dataSource.removeAnnotations()
                }
            }
            .padding()
            .buttonStyle(RoundedButton(fillColor: .accentColor, padding: 8))
        }
        .onAppear {
            dataSource.bind()
        }
    }

    private func mapItem(for annotation: Annotation) -> some MapAnnotationProtocol {
        switch annotation.style {
        case .single:
            AnyMapAnnotationProtocol(
                MapPin(coordinate: annotation.coordinate)
            )
        case .cluster(let count):
            AnyMapAnnotationProtocol(MapAnnotation(coordinate: annotation.coordinate) {
                VStack(spacing: 0) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundColor(.red)

                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                        .offset(x: 0, y: -5)

                    Text("\(count)")
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(4)
                        .background {
                            RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                .foregroundColor(.white)
                        }
                }
            })
        }
    }
}

struct LegacyMap_Previews: PreviewProvider {
    static var previews: some View {
        LegacyMap()
    }
}
