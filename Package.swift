// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SelectedTextKit",
    platforms: [
        .macOS(.v13),
        .macCatalyst(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SelectedTextKit",
            targets: ["SelectedTextKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/tmandry/AXSwift.git", from: "0.3.0"),
        .package(url: "https://github.com/jordanbaird/KeySender", from: "0.0.5"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SelectedTextKit",
            dependencies: [
                "AXSwift",
                "KeySender",
                .product(name: "Subprocess", package: "swift-subprocess"),
            ]
        ),
        .target(
            name: "SelectedTextKitExample",
            dependencies: ["SelectedTextKit"],
            path: "SelectedTextKitExample"),
    ]
)
