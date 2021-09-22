// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DefaultsWrapper",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
        .tvOS(.v14),
        .watchOS(.v7)
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
