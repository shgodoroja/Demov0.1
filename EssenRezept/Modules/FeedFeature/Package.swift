// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeedFeature",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FeedFeature",
            targets: ["FeedFeature"]),
    ],
    dependencies: [
        .package(name: "Persistence", path: "./Persistence"),
        .package(name: "APIClient", path: "./APIClient"),
        .package(name: "DesignSystem", path: "./DesignSystem"),
        .package(name: "Navigation", path: "./Navigation")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FeedFeature",
            dependencies: [
                "Persistence",
                "APIClient",
                "DesignSystem",
                "Navigation"
            ]
        ),
        .testTarget(
            name: "FeedFeatureTests",
            dependencies: ["FeedFeature"]
        ),
    ]
)
