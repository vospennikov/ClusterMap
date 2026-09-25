// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ClusterMap",
    platforms: [
        .iOS(.v15), .macOS(.v12),
    ],
    products: [
        .library(name: "ClusterMap", targets: ["ClusterMap"]),
        .library(name: "ClusterMapSwiftUI", targets: ["ClusterMapSwiftUI"]),
    ],
    targets: [
        .target(name: "ClusterMap"),
        .testTarget(name: "ClusterMapTests", dependencies: ["ClusterMap"]),
        .target(name: "ClusterMapSwiftUI"),
    ]
)

// for target in package.targets {
//    target.swiftSettings = target.swiftSettings ?? []
//    target.swiftSettings?.append(
//        .unsafeFlags([
//            "-Xfrontend", "-warn-long-expression-type-checking=50",
//            "-Xfrontend", "-warn-long-function-bodies=50",
//            "-enable-library-evolution",
//            "-enable-testing"
//        ])
//    )
// }
