//
//  ClusterManager.swift
//  Cluster
//
//  Created by Lasha Efremidze on 4/13/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import CoreLocation
import MapKit

/// Manages the clustering behavior for map annotations.
///
/// The `ClusterManager` is responsible for optimizing the display of map annotations by grouping close annotations
/// into clusters.
///
/// Example:
///
/// ```swift
/// let manager = ClusterManager<MyAnnotation>()
///
/// // Adding an annotation
/// let annotation = MyAnnotation(coordinate: someCoordinate)
/// manager.add(annotation)
///
/// // Adding multiple annotations
/// manager.add([annotation1, annotation2, annotation3])
///
/// // Reloading the clustering for a map region
/// manager.reload(mapSize: someSize, coordinateRegion: someRegion) { difference in
///     // Handle the difference here
/// }
/// ```
public final class ClusterManager<Annotation: CoordinateIdentifiable>
    where
    Annotation: Identifiable,
    Annotation: Hashable
{
    private var tree = QuadTree<Annotation>(rect: .world)
    private let configuration: Configuration
    private var zoomLevel: Double = 0
    private let operationQueue = OperationQueue.serial
    private let dispatchQueue = DispatchQueue(label: "com.cluster.concurrentQueue", attributes: .concurrent)

    /// Initializes a new ClusterManager instance.
    ///
    /// - Parameter configuration: The clustering configuration settings.
    public init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
    }

    /// A collection of all annotations.
    public var annotations: [Annotation] {
        dispatchQueue.sync {
            tree.findAnnotations(in: .world)
        }
    }

    /// A collection of currently visible annotations on the map.
    public var visibleAnnotations: [AnnotationType] = []

    /// A collection of currently visible nested annotations on the map.
    ///
    /// This includes individual annotations as well as annotations within visible clusters.
    public var visibleNestedAnnotations: [Annotation] {
        dispatchQueue.sync {
            visibleAnnotations.reduce(into: [Annotation]()) { partialResult, annotationType in
                switch annotationType {
                case .annotation(let annotation):
                    partialResult.append(annotation)
                case .cluster(let clusterAnnotation):
                    partialResult += clusterAnnotation.memberAnnotations
                }
            }
        }
    }

    /// Adds a single annotation to the cluster manager.
    ///
    /// - Parameter annotation: The annotation to be added.
    public func add(_ annotation: Annotation) {
        operationQueue.cancelAllOperations()
        dispatchQueue.async(flags: .barrier) { [weak tree] in
            tree?.add(annotation)
        }
    }

    /// Adds multiple annotations to the cluster manager.
    ///
    /// - Parameter annotations: An array of annotations to be added.
    public func add(_ annotations: [Annotation]) {
        operationQueue.cancelAllOperations()
        dispatchQueue.async(flags: .barrier) { [weak tree] in
            annotations.forEach { tree?.add($0) }
        }
    }

    /// Removes a single annotation from the cluster manager.
    ///
    /// - Parameter annotation: The annotation to be removed.
    public func remove(_ annotation: Annotation) {
        operationQueue.cancelAllOperations()
        dispatchQueue.async(flags: .barrier) { [weak tree] in
            tree?.remove(annotation)
        }
    }

    /// Removes multiple annotations from the cluster manager.
    ///
    /// - Parameter annotations: An array of annotations to be removed.
    public func remove(_ annotations: [Annotation]) {
        operationQueue.cancelAllOperations()
        dispatchQueue.async(flags: .barrier) { [weak tree] in
            annotations.forEach { tree?.remove($0) }
        }
    }

    /// Removes all annotations from the cluster manager.
    public func removeAll() {
        operationQueue.cancelAllOperations()
        dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.tree = QuadTree<Annotation>(rect: .world)
        }
    }

    /// Reloads the annotations on the map based on the current zoom level and visible map region.
    ///
    /// - Parameters:
    ///   - mapViewSize: The size of the map view.
    ///   - coordinateRegion: The visible coordinate region on the map.
    ///   - completion: Closure to handle the `Difference` object which contains the changes made during the reload.
    public func reload(
        mapViewSize: CGSize,
        coordinateRegion: MKCoordinateRegion,
        completion: @escaping (Difference) -> Void
    ) {
        let visibleMapRect = MKMapRect(region: coordinateRegion)
        let visibleMapRectWidth = visibleMapRect.size.width
        let zoomScale = Double(mapViewSize.width) / visibleMapRectWidth

        operationQueue.cancelAllOperations()
        operationQueue.addBlockOperation { [weak self] operation in
            guard let self else {
                return completion(Difference())
            }
            autoreleasepool {
                let changes = self.clusteredAnnotations(
                    zoomScale: zoomScale,
                    visibleMapRect: visibleMapRect,
                    operation: operation
                )
                completion(changes)
            }
        }
    }

    /// Reloads the annotations on the map based on the current zoom level and visible map region.
    /// This is an async-await variant of the `reload(mapViewSize:coordinateRegion:completion:)` method.
    ///
    /// - Parameters:
    ///   - mapViewSize: The size of the map view.
    ///   - coordinateRegion: The visible coordinate region on the map.
    /// - Returns: A `Difference` object which contains the changes made during the reload.
    @discardableResult
    public func reload(mapViewSize: CGSize, coordinateRegion: MKCoordinateRegion) async -> Difference {
        await withUnsafeContinuation { continuation in
            reload(mapViewSize: mapViewSize, coordinateRegion: coordinateRegion) { difference in
                continuation.resume(returning: difference)
            }
        }
    }

    /// Reloads the annotations on the map based on the current zoom level and visible map region.
    ///
    /// - Parameters:
    ///   - mkMapView: The map view.
    /// - Returns: A `Difference` object which contains the changes made during the reload.
    public func reload(mkMapView: MKMapView, completion: @escaping (Difference) -> Void) {
        reload(mapViewSize: mkMapView.bounds.size, coordinateRegion: mkMapView.region, completion: completion)
    }
}

private extension ClusterManager {
    func clusteredAnnotations(zoomScale: Double, visibleMapRect: MKMapRect, operation: Operation? = nil) -> Difference {
        var isCancelled: Bool { operation?.isCancelled ?? false }

        guard !isCancelled else { return Difference() }

        let mapRects = mapRects(zoomScale: zoomScale, visibleMapRect: visibleMapRect)

        guard !isCancelled else { return Difference() }

        if configuration.shouldDistributeAnnotationsOnSameCoordinate {
            distributeAnnotations(mapRect: visibleMapRect)
        }

        let allAnnotations = dispatchQueue.sync {
            clusteredAnnotations(mapRects: mapRects, zoomLevel: zoomLevel)
        }

        guard !isCancelled else { return Difference() }

        let before = visibleAnnotations
        let after = allAnnotations

        var toRemove = before.subtracted(after)
        let toAdd = after.subtracted(before)

        if !configuration.shouldRemoveInvisibleAnnotations {
            let toKeep = toRemove.filter { kindOf in
                switch kindOf {
                case .annotation(let annotation):
                    return !visibleMapRect.contains(annotation.coordinate)
                case .cluster(let clusterAnnotation):
                    return !visibleMapRect.contains(clusterAnnotation.coordinate)
                }
            }
            toRemove.subtract(toKeep)
        }

        dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.visibleAnnotations.subtract(toRemove)
            self?.visibleAnnotations.add(toAdd)
        }

        return Difference(insertions: toAdd, removals: toRemove)
    }

    func clusteredAnnotations(mapRects: [MKMapRect], zoomLevel: Double) -> [AnnotationType] {
        var allAnnotations: [AnnotationType] = []
        for mapRect in mapRects {
            var annotations: [Annotation] = []

            for node in tree.findAnnotations(in: mapRect) {
                if node.shouldCluster {
                    annotations.append(node)
                } else {
                    allAnnotations.append(.annotation(node))
                }
            }

            let count = annotations.count
            if count >= configuration.minCountForClustering, zoomLevel <= configuration.maxZoomLevel {
                let cluster = ClusterAnnotation(
                    coordinate: configuration.clusterPosition.calculatePosition(
                        for: annotations.map(\.coordinate),
                        within: mapRect
                    ),
                    memberAnnotations: annotations
                )
                allAnnotations.append(.cluster(cluster))
            } else {
                allAnnotations.append(contentsOf: annotations.map { .annotation($0) })
            }
        }
        return allAnnotations
    }

    func distributeAnnotations(mapRect: MKMapRect) {
        let annotations = dispatchQueue.sync {
            tree.findAnnotations(in: mapRect)
        }
        let hash = Dictionary(grouping: annotations) { $0.coordinate }
        dispatchQueue.async(flags: .barrier) {
            for value in hash.values where value.count > 1 {
                for (index, annotation) in value.enumerated() {
                    if var element = self.tree.remove(annotation) {
                        let radiansBetweenAnnotations = (.pi * 2) / Double(value.count)
                        let bearing = radiansBetweenAnnotations * Double(index)
                        element.coordinate = annotation.coordinate.coordinate(
                            onBearingInRadians: bearing,
                            atDistanceInMeters: self.configuration.distanceFromContestedLocation
                        )
                        self.tree.add(element)
                    }
                }
            }
        }
    }

    func mapRects(zoomScale: Double, visibleMapRect: MKMapRect) -> [MKMapRect] {
        guard !zoomScale.isInfinite, !zoomScale.isNaN else { return [] }

        zoomLevel = zoomScale.zoomLevel
        let scaleFactor = zoomScale / configuration.cellSizeForZoomLevel(Int(zoomLevel)).width

        let minX = Int(floor(visibleMapRect.minX * scaleFactor))
        let maxX = Int(floor(visibleMapRect.maxX * scaleFactor))
        let minY = Int(floor(visibleMapRect.minY * scaleFactor))
        let maxY = Int(floor(visibleMapRect.maxY * scaleFactor))

        var mapRects = [MKMapRect]()
        for x in minX...maxX {
            for y in minY...maxY {
                var mapRect = MKMapRect(
                    x: Double(x) / scaleFactor,
                    y: Double(y) / scaleFactor,
                    width: 1 / scaleFactor,
                    height: 1 / scaleFactor
                )
                if mapRect.origin.x > MKMapPointMax.x {
                    mapRect.origin.x -= MKMapPointMax.x
                }
                mapRects.append(mapRect)
            }
        }
        return mapRects
    }
}
