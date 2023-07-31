//
//  ClusterManager.swift
//  Cluster
//
//  Created by Lasha Efremidze on 4/13/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import CoreLocation
import MapKit

/// `ClusterManager` is responsible for clustering annotations and providing updates to the map view.
open class ClusterManager {
    var tree = QuadTree(rect: .world)
    
    /**
     The current zoom level of the visible map region.
     
     Min value is 0 (max zoom out), max is 20 (max zoom in).
     */
    open internal(set) var zoomLevel: Double = 0
    
    /**
     The maximum zoom level before disabling clustering.
     
     Min value is 0 (max zoom out), max is 20 (max zoom in). The default is 20.
     */
    open var maxZoomLevel: Double = 20
    
    /**
     The minimum number of annotations for a cluster.
     
     The default is 2.
     */
    open var minCountForClustering: Int = 2
    
    /**
     Whether to remove invisible annotations.
     
     The default is true.
     */
    open var shouldRemoveInvisibleAnnotations: Bool = true
    
    /**
     Whether to arrange annotations in a circle if they have the same coordinate.
     
     The default is true.
     */
    open var shouldDistributeAnnotationsOnSameCoordinate: Bool = true
    
    /**
     The distance in meters from contested location when the annotations have the same coordinate.
     
     The default is 3.
     */
    open var distanceFromContestedLocation: Double = 3
    
    /// Controls the positioning strategy of a cluster. The default is `.nearCenter`.
    ///
    /// The following clustering strategies are available for use:
    ///
    /// - `.center`: Represents the center position for a cluster of `MKAnnotation` instances.
    ///
    /// - `.nearCenter`: Represents the position of the `MKAnnotation` nearest to the center. Defaults to the center if no annotations are available.
    ///
    /// - `.average`: Represents the average position for a cluster of `MKAnnotation` instances.
    ///
    /// - `.first`: Represents the position of the first `MKAnnotation` within a cluster. Defaults to the center if no annotations are available.
    ///
    /// You can develop your own alignment strategy by implementing the `ClusterAlignmentStrategy` protocol on a `ClusterAlignment` struct.
    ///
    /// Here's an example:
    /// ```swift
    /// var clusterAlignment = ClusterAlignment(
    ///   alignmentStrategy: NewStrategy()
    /// )
    ///
    /// struct NewStrategy: ClusterAlignmentStrategy {
    ///   func calculatePosition(for annotations: [MKAnnotation], within mapRect: MKMapRect) -> CLLocationCoordinate2D {
    ///     // Place your custom alignment logic here.
    ///   }
    /// }
    /// ```
    open var clusterPosition: ClusterAlignment = .nearCenter
    
    /**
     The list of annotations associated.
     
     The objects in this array must adopt the MKAnnotation protocol. If no annotations are associated with the cluster manager, the value of this property is an empty array.
     */
    open var annotations: [MKAnnotation] {
        return dispatchQueue.sync {
            tree.findAnnotations(in: .world)
        }
    }
    
    /**
     The list of visible annotations associated.
     */
    open var visibleAnnotations = [MKAnnotation]()
    
    /**
     The list of nested visible annotations associated.
     */
    open var visibleNestedAnnotations: [MKAnnotation] {
        dispatchQueue.sync {
            visibleAnnotations.reduce(into: [MKAnnotation]()) { partialResult, annotation in
                switch annotation {
                    case let cluster as ClusterAnnotation:
                        partialResult += cluster.annotations
                    default:
                        partialResult.append(annotation)
                }
            }
        }
    }
    
    let operationQueue = OperationQueue.serial
    let dispatchQueue = DispatchQueue(label: "com.cluster.concurrentQueue", attributes: .concurrent)
    
    open weak var delegate: ClusterManagerDelegate?
    
    public init() {}
    
    /**
     Adds an annotation object to the cluster manager.
     
     - Parameters:
     - annotation: An annotation object. The object must conform to the MKAnnotation protocol.
     */
    open func add(_ annotation: MKAnnotation) {
        operationQueue.cancelAllOperations()
        dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.tree.add(annotation)
        }
    }
    
    /**
     Adds an array of annotation objects to the cluster manager.
     
     - Parameters:
     - annotations: An array of annotation objects. Each object in the array must conform to the MKAnnotation protocol.
     */
    open func add(_ annotations: [MKAnnotation]) {
        operationQueue.cancelAllOperations()
        dispatchQueue.async(flags: .barrier) { [weak self] in
            for annotation in annotations {
                self?.tree.add(annotation)
            }
        }
    }
    
    /**
     Removes an annotation object from the cluster manager.
     
     - Parameters:
     - annotation: An annotation object. The object must conform to the MKAnnotation protocol.
     */
    open func remove(_ annotation: MKAnnotation) {
        operationQueue.cancelAllOperations()
        dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.tree.remove(annotation)
        }
    }
    
    /**
     Removes an array of annotation objects from the cluster manager.
     
     - Parameters:
     - annotations: An array of annotation objects. Each object in the array must conform to the MKAnnotation protocol.
     */
    open func remove(_ annotations: [MKAnnotation]) {
        operationQueue.cancelAllOperations()
        dispatchQueue.async(flags: .barrier) { [weak self] in
            for annotation in annotations {
                self?.tree.remove(annotation)
            }
        }
    }
    
    /**
     Removes all the annotation objects from the cluster manager.
     */
    open func removeAll() {
        operationQueue.cancelAllOperations()
        dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.tree = QuadTree(rect: .world)
        }
    }
        
    /**
     Reload the annotations on the map view.
     
     - Parameters:
     - mapView: The map view object to reload.
     - completion: A closure to be executed when the reload finishes. The closure has no return value and takes a single Boolean argument that indicates whether or not the reload actually finished before the completion handler was called.
     */
    open func reload(mapView: MKMapView, completion: @escaping (Bool) -> Void = { finished in }) {
        let mapBounds = mapView.bounds
        let visibleMapRect = mapView.visibleMapRect
        let visibleMapRectWidth = visibleMapRect.size.width
        let zoomScale = Double(mapBounds.width) / visibleMapRectWidth
        operationQueue.cancelAllOperations()
        operationQueue.addBlockOperation { [weak self, weak mapView] operation in
            guard let self = self, let mapView = mapView else { return completion(false) }
            autoreleasepool {
                let (toAdd, toRemove) = self.clusteredAnnotations(zoomScale: zoomScale, visibleMapRect: visibleMapRect, operation: operation)
                DispatchQueue.main.async { [weak self, weak mapView] in
                    guard let self = self, let mapView = mapView else { return completion(false) }
                    self.display(mapView: mapView, toAdd: toAdd, toRemove: toRemove)
                    completion(true)
                }
            }
        }
    }
    
    /// Returns the annotations to add and remove from the map view based on the given `zoomScale` and `visibleMapRect`.
    /// This method calculates the annotations to display on the map view using a QuadTree data structure.
    /// It splits the visible map rect into smaller subrects and looks for clusters and visible annotations within those subrects.
    /// If the `shouldDistributeAnnotationsOnSameCoordinate` property is set to `true`, it will also handle annotations that have the same coordinate but are not clustered together.
    /// - Parameters:
    ///   - zoomScale: The current zoom scale of the map view.
    ///   - visibleMapRect: The current visible map rect of the map view.
    ///   - operation: An optional `Operation` object that can be used to cancel the operation.
    /// - Returns: A tuple containing the annotations to add and remove from the map view.
    open func clusteredAnnotations(zoomScale: Double, visibleMapRect: MKMapRect, operation: Operation? = nil) -> (toAdd: [MKAnnotation], toRemove: [MKAnnotation]) {
        var isCancelled: Bool { return operation?.isCancelled ?? false }
        
        guard !isCancelled else { return (toAdd: [], toRemove: []) }
        
        let mapRects = self.mapRects(zoomScale: zoomScale, visibleMapRect: visibleMapRect)
        
        guard !isCancelled else { return (toAdd: [], toRemove: []) }
        
        // handle annotations on the same coordinate
        if shouldDistributeAnnotationsOnSameCoordinate {
            distributeAnnotations(tree: tree, mapRect: visibleMapRect)
        }
        
        let allAnnotations = dispatchQueue.sync {
            clusteredAnnotations(tree: tree, mapRects: mapRects, zoomLevel: zoomLevel)
        }
        
        guard !isCancelled else { return (toAdd: [], toRemove: []) }
        
        let before = visibleAnnotations
        let after = allAnnotations
        
        var toRemove = before.subtracted(after)
        let toAdd = after.subtracted(before)
        
        if !shouldRemoveInvisibleAnnotations {
            let toKeep = toRemove.filter { !visibleMapRect.contains($0.coordinate) }
            toRemove.subtract(toKeep)
        }
        
        dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.visibleAnnotations.subtract(toRemove)
            self?.visibleAnnotations.add(toAdd)
        }
        
        return (toAdd: toAdd, toRemove: toRemove)
    }
    
    func clusteredAnnotations(tree: QuadTree, mapRects: [MKMapRect], zoomLevel: Double) -> [MKAnnotation] {
        var allAnnotations = [MKAnnotation]()
        for mapRect in mapRects {
            var annotations = [MKAnnotation]()
            
            // add annotations
            for node in tree.findAnnotations(in: mapRect) {
                if delegate?.shouldClusterAnnotation(node) ?? true {
                    annotations.append(node)
                } else {
                    allAnnotations.append(node)
                }
            }
            
            // handle clustering
            let count = annotations.count
            if count >= minCountForClustering, zoomLevel <= maxZoomLevel {
                let cluster = ClusterAnnotation()
                cluster.coordinate = clusterPosition.calculatePosition(for: annotations, within: mapRect)
                cluster.annotations = annotations
                allAnnotations += [cluster]
            } else {
                allAnnotations += annotations
            }
        }
        return allAnnotations
    }
    
    func distributeAnnotations(tree: QuadTree, mapRect: MKMapRect) {
        let annotations = dispatchQueue.sync {
            tree.findAnnotations(in: mapRect)
        }
        let hash = Dictionary(grouping: annotations) { $0.coordinate }
        dispatchQueue.async(flags: .barrier) {
            for value in hash.values where value.count > 1 {
                for (index, annotation) in value.enumerated() {
                    tree.remove(annotation)
                    let radiansBetweenAnnotations = (.pi * 2) / Double(value.count)
                    let bearing = radiansBetweenAnnotations * Double(index)
                    (annotation as? MKPointAnnotation)?.coordinate = annotation.coordinate.coordinate(onBearingInRadians: bearing, atDistanceInMeters: self.distanceFromContestedLocation)
                    tree.add(annotation)
                }
            }
        }
    }
    
    func mapRects(zoomScale: Double, visibleMapRect: MKMapRect) -> [MKMapRect] {
        guard !zoomScale.isInfinite, !zoomScale.isNaN else { return [] }
        
        zoomLevel = zoomScale.zoomLevel
        let scaleFactor = zoomScale / cellSize(for: zoomLevel)
        
        let minX = Int(floor(visibleMapRect.minX * scaleFactor))
        let maxX = Int(floor(visibleMapRect.maxX * scaleFactor))
        let minY = Int(floor(visibleMapRect.minY * scaleFactor))
        let maxY = Int(floor(visibleMapRect.maxY * scaleFactor))
        
        var mapRects = [MKMapRect]()
        for x in minX...maxX {
            for y in minY...maxY {
                var mapRect = MKMapRect(x: Double(x) / scaleFactor, y: Double(y) / scaleFactor, width: 1 / scaleFactor, height: 1 / scaleFactor)
                if mapRect.origin.x > MKMapPointMax.x {
                    mapRect.origin.x -= MKMapPointMax.x
                }
                mapRects.append(mapRect)
            }
        }
        return mapRects
    }
    
    /// Displays clustered annotations on an `MKMapView`.
    /// - Parameters:
    ///   - mapView: The `MKMapView` to display the annotations on.
    ///   - toAdd: An array of `MKAnnotation` objects to add to the map view.
    ///   - toRemove: An array of `MKAnnotation` objects to remove from the map view.
    open func display(mapView: MKMapView, toAdd: [MKAnnotation], toRemove: [MKAnnotation]) {
        assert(Thread.isMainThread, "This function must be called from the main thread.")
        mapView.removeAnnotations(toRemove)
        mapView.addAnnotations(toAdd)
    }
    
    func cellSize(for zoomLevel: Double) -> Double {
        if let cellSize = delegate?.cellSize(for: zoomLevel) {
            return cellSize
        }
        switch zoomLevel {
            case 13...15:
                return 64
            case 16...18:
                return 32
            case 19...:
                return 16
            default:
                return 88
        }
    }
    
}
