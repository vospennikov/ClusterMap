// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cluster",
    platforms: [
        .iOS(.v13), .macOS(.v11)
    ],
    products: [
        .library(name: "Cluster", targets: ["Cluster"]),
    ],
    targets: [
        .target(name: "Cluster", dependencies: []),
        .testTarget(name: "ClusterTests", dependencies: ["Cluster"])
    ]
)
