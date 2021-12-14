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
    dependencies: [
        .package(name: "OptionalType", url: "https://github.com/Pyroh/OptionalType.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "DefaultsWrapper",
            dependencies: ["OptionalType"]),
        .testTarget(
            name: "DefaultsWrapperTests",
            dependencies: ["DefaultsWrapper"]),
    ]
)
