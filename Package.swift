// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DefaultsWrapper",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
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
