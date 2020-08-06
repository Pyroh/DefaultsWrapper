// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DefaultsWrapper",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v8),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(
            name: "DefaultsWrapper",
            targets: ["DefaultsWrapper"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DefaultsWrapper",
            dependencies: []),
        .testTarget(
            name: "DefaultsWrapperTests",
            dependencies: ["DefaultsWrapper"]),
    ]
)
