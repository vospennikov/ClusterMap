// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ClusterMap",
    platforms: [
        .iOS(.v13), .macOS(.v11)
    ],
    products: [
        .library(name: "ClusterMap", targets: ["ClusterMap"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.2.0")
    ],
    targets: [
        .target(
            name: "ClusterMap",
            swiftSettings: [
                .unsafeFlags(
                    [
                        "-Xfrontend", "-warn-long-expression-type-checking=100",
                        "-Xfrontend", "-warn-long-function-bodies=100"
                    ],
                    .when(configuration: .debug)
                )
            ]
        ),
        .testTarget(name: "ClusterMapTests", dependencies: ["ClusterMap"])
    ]
)
