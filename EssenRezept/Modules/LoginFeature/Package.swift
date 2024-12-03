// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoginFeature",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LoginFeature",
            targets: ["LoginFeature"]),
        
    ],
    dependencies: [
        .package(name: "Navigation", path: "./Navigation")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LoginFeature",
            dependencies: [
                "Navigation"
            ]
        ),
        .testTarget(
            name: "LoginFeatureTests",
            dependencies: ["LoginFeature"]
        ),
    ]
)
