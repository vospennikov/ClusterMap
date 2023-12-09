# ClusterMap

![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![Platform](https://img.shields.io/badge/Platform-iOS_%7C_macOS-orange)
![Framework](https://img.shields.io/badge/Framework-AppKit_%7C_UIKit_%7C_SwiftUI-orange)
![Package Manager](https://img.shields.io/badge/Package_Manager-SPM-orange)
![GitHub](https://img.shields.io/badge/Licence-MIT-orange)

ClusterMap is an open-source library for high-performance map clustering.

## Reasons
Creating clusters is a highly effective way to improve user experience and performance when displaying multiple points on a map. [Native clustering mechanisms](https://developer.apple.com/documentation/mapkit/mkannotationview/decluttering_a_map_with_mapkit_annotation_clustering) offer a straightforward, code-free solution with visually appealing animations. However, it's worth noting that this implementation does have one major drawback: all points are added to the map in the MainThread, which can cause issues when dealing with large numbers of points. Unfortunately, this bottleneck cannot be avoided. Another problem is that SwiftUI still lacks this feature.

## What's in ClusterMap?
ClusterMap provides high-performance computations based on the [QuadTree](https://en.wikipedia.org/wiki/Quadtree) algorithm. This library is UI framework-independent and performs computations in any thread.

Comparison ClusterMap and Native implementation with 20,000 annotations. For a detailed comparison, look at [Example-UIKit](Example).

![Demo Cluster](Images/demo_cluster.gif) ![Demo MKMapKit](Images/demo_mapkit.gif)

- [Features](#features)
- [What's in the next releases?](#whats-in-the-next-releases)
- [Demo projects](#demo-projects)
- [Installation](#installation)
- [Usage](#usage)
- [Documentation](#documentation)
- [Credits](#credits)
- [License](#license)

## Features
- [x] UI framework independent. 
- [x] Thread independent.
- [x] Integration with AppKit, UIKit, and SwiftUI.
- [x] MapKit integration.
- [x] Swift concurrency.

## What's in the next releases?
- [ ] Stateless implementation.
- [ ] Improve difference logic.
- [ ] Simplify API.

## Demo projects
The repository contains three main examples, which is a good starting point for exploring the basic functionality of the library.

- [Example-AppKit](Example/Example-AppKit)
- [Example-UIKit](Example/Example-UIKit)
- [Example-SwiftUI](Example/Example-SwiftUI)

## Installation
### Xcode
Add the ClusterMap dependency to an Xcode project as a package dependency.
1. From the **File** menu, select **Add Packages...**
2. Enter "https://github.com/vospennikov/ClusterMap.git" into the package repository URL text field.

### SPM manifest
Add the ClusterMap dependency to your `Package.swift` manifest.
1. Add the following dependency to your `dependencies` argument:
   ```swift
   .package(url: "https://github.com/vospennikov/ClusterMap.git", from: "2.0.0")
   ```
2. Add the dependency to any targets you've declared in your manifest:
   ```swift
   .target(
     name: "MyTarget", 
     dependencies: [
       .product(name: "ClusterMap", package: "ClusterMap"),
     ]
   )
   ```

## Usage
### The Basics
The `ClusterManager` stores and cluster map points. It's an actor and safe thread for usage. 
1. You need to confirm your map points to the protocols `CoordinateIdentifiable, Identifiable, Hashable`:
   ```swift
   // SwiftUI annotation
   struct ExampleAnnotation: CoordinateIdentifiable, Identifiable, Hashable {
     let id = UUID()
     var coordinate: CLLocationCoordinate2D
   }
   
   // MapKit (MKMapItem) integration
   extension MKMapItem: CoordinateIdentifiable, Identifiable, Hashable {
     let id = UUID()
     var coordinate: CLLocationCoordinate2D {
       get { placemark.coordinate }
       set(newValue) { }
     }
   }
   
   // MapKit (MKPointAnnotation) integration
   class ExampleAnnotation: MKPointAnnotation, CoordinateIdentifiable, Identifiable, Hashable {
     let id = UUID()
   }
   ```
2. You need to create an instance of `ClusterManager` and set your annotation type instead `ExampleAnnotation`
   ```swift
   let clusterManager = ClusterManager<ExampleAnnotation>()
   ```

3. Next, you can add and remove your points.
   ```swift
   let reykjavik = ExampleAnnotation(coordinates: CLLocationCoordinate2D(latitude: 64.1466, longitude: -21.9426))
   let akureyri = ExampleAnnotation(coordinates: CLLocationCoordinate2D(latitude: 65.6835, longitude: -18.1002))
   let husavik = ExampleAnnotation(coordinates: CLLocationCoordinate2D(latitude: 66.0449, longitude: -17.3389))
   let cities = [reykjavik, akureyri, husavik]
    
   await clusterManager.add(cities)
   await clusterManager.remove(husavik)
   await clusterManager.removeAll()
   ```

### Reloading Annotations
#### SwiftUI integration
1. To calculate clusters correctly, the ClusterMap needs to know the size of the map. Unfortunately, Apple doesn't provide this information. For reading map size, you can use [GeometryReader](https://developer.apple.com/documentation/swiftui/geometryreader) and pass the size to your model object. 
   ```swift
   @State private var mapSize: CGSize = .zero
   
   var body: some View {
     GeometryReader(content: { geometryProxy in
       Map()
       .onAppear(perform: {
         mapSize = geometryProxy.size
       })
       .onChange(of: geometryProxy.size) { oldValue, newValue in
         mapSize = newValue
       }
     })
   }
   ```

   Or you can use the prebuilt method `.readSize` from `ClusterMapSwiftUI` package.
   ```swift
   import ClusterMapSwiftUI
   
   @State private var mapSize: CGSize = .zero
   
   var body: some View {
     GeometryReader(content: { geometryProxy in
       Map()
       .readSize(onChange: { newValue in
         mapSize = newValue
       })
     })
   }
   ```

2. Next, you need to pass this size to the reload method of ClusterMap each time. Let's reload our map each time the camera changes position. In the example, we use the modern (iOS 17) method [onMapCameraChange](https://developer.apple.com/documentation/mapkit/map/4231686-onmapcamerachange). Integrate with Map before iOS 17 a little bit tricky, for more information look at [Example-SwiftUI/App/LegacyMap](Example/Example-SwiftUI)
   ```swift
   Map()
   .onMapCameraChange(frequency: .onEnd) { context in
     Task.detached { await clusterManager.reload(mapViewSize: mapSize, coordinateRegion: context.region) }
   }
   ```

   As a result of this method, ClusterMap returns struct `ClusterManager<ExampleAnnotation>.Difference`.  You need to apply this difference to your view. 
   ```swift
   private var annotations: [ExampleAnnotation] = []
   private var clusters: [ExampleClusterAnnotation] = []
   
   func applyChanges(_ difference: ClusterManager<ExampleAnnotation>.Difference) {
     for removal in difference.removals {
       switch removal {
       case .annotation(let annotation):
         annotations.removeAll { $0 == annotation }
       case .cluster(let clusterAnnotation):
         clusters.removeAll { $0.id == clusterAnnotation.id }
       }
     }
     for insertion in difference.insertions {
       switch insertion {
       case .annotation(let newItem):
         annotations.append(newItem)
       case .cluster(let newItem):
         clusters.append(ExampleClusterAnnotation(
           id: newItem.id,
           coordinate: newItem.coordinate,
           count: newItem.memberAnnotations.count
         ))
       }
     }
   }
   ```

For additional information on integration, look at [Example-SwiftUI](Example/Example-SwiftUI)

#### UIKit integration
1. To calculate clusters correctly, the ClusterMap needs to know the size of the map. We can read the size from `MKMapView` directly.
   ```swift
   var mapView = MKMapView(frame: .zero)
   
   func reloadMap() async {
     await clusterManager.reload(mapViewSize: mapView.bounds.size, coordinateRegion: mapView.region)
   }
   ```

2. As a result of this method, ClusterMap returns struct `ClusterManager<ExampleAnnotation>.Difference`. You need to apply this difference to your view. It's tricky because your MKMapView keeps `MKAnnotation` and erases type. You can cast annotations to type check or keep them in an additional variable. I keep them in variables for clear examples. 
   ```swift
   var annotations: [ExampleAnnotation] = []
   
   private func applyChanges(_ difference: ClusterManager<ExampleAnnotation>.Difference) {
     for annotationType in difference.removals {
       switch annotationType {
       case .annotation(let annotation):
         annotations.removeAll(where: { $0 == annotation })
         mapView.removeAnnotation(annotation)
       case .cluster(let clusterAnnotation):
         if let result = annotations.enumerated().first(where: { $0.element.id == clusterAnnotation.id }) {
           annotations.remove(at: result.offset)
           mapView.removeAnnotation(result.element)
         }
       }
     }
     for annotationType in difference.insertions {
       switch annotationType {
       case .annotation(let annotation):
         annotations.append(annotation)
         mapView.addAnnotation(annotation)
       case .cluster(let clusterAnnotation):
         let cluster = ClusterAnnotation()
         cluster.id = clusterAnnotation.id
         cluster.coordinate = clusterAnnotation.coordinate
         cluster.memberAnnotations = clusterAnnotation.memberAnnotations
         annotations.append(cluster)
         mapView.addAnnotation(cluster)
       }
     }
   }
   ```

For additional information on integration, look at [Example-UIKit](Example/Example-UIKit)

#### TCA integration
ClusterMap is a UI framework independent. You can integrate this library into any application layer. Let's look at integrating this library as a [TCA](https://github.com/pointfreeco/swift-composable-architecture) dependency. Finally, you can save results in the database and reuse items anytime without additional heavyweight computations.
```swift
struct ClusterMapClient {
  struct ClusterClientResult {
    let objects: [ExampleAnnotation]
    let clusters: [ExampleClusterAnnotation]
  }
  var clusterObjects: @Sendable ([ExampleAnnotation], MKCoordinateRegion, CGSize) async -> ClusterClientResult
}
extension DependencyValues {
  var clusterMapClient: ClusterMapClient {
    get { self[ClusterMapClient.self] }
    set { self[ClusterMapClient.self] = newValue }
  }
}

extension ClusterMapClient: DependencyKey {
  static var liveValue = ClusterMapClient(
    clusterObjects: { inputObjects, mapRegion, mapSize in
      let clusterManager = ClusterManager<ExampleAnnotations>()

      await clusterManager.add(inputObjects)
      await clusterManager.reload(mapViewSize: mapSize, coordinateRegion: mapRegion)
      
      var objects: [ExampleAnnotation] = []
      var clusters: [ExampleClusterAnnotation] = []
      await clusterManager.visibleAnnotations.forEach { annotationType in
        switch annotationType {
        case .annotation(let annotation):
          objects.append(annotation)
        case .cluster(let cluster):
          clusters.append(.init(coordinate: cluster.coordinate))
        }
      }
      
      return .init(objects: objects, clusters: clusters)
    }
  )
}
```

### Advanced configuration
The `ClusterManager` has configuration, that help you improve perfomance and control clustering logic, for addition information, look at `ClusterManager.Configuration`

## Documentation
The documentation for releases and `main` are available here:

* [`main`](https://vospennikov.github.io/ClusterMap/main/documentation/clustermap)
* [2.0.0](https://vospennikov.github.io/ClusterMap/2.0.0/documentation/clustermap)
* [1.1.0](https://vospennikov.github.io/ClusterMap/1.1.0/documentation/clustermap)
* [1.0.0](https://vospennikov.github.io/ClusterMap/1.0.0/documentation/clustermap)

## Credits and thanks
This project is based on the work of [Lasha Efremidze](https://github.com/efremidze), who created the [Cluster](https://github.com/efremidze/Cluster).

## License
This library is released under the MIT license. See LICENSE for details.
