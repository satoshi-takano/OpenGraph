// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "OpenGraph",
    platforms: [
            .macOS(.v10_15), .iOS(.v10), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(name: "OpenGraph", targets: ["OpenGraph"]),
    ],
    dependencies: [
      .package(url: "https://github.com/AliSoftware/OHHTTPStubs", .upToNextMajor(from: "9.0.0")),
    ],
    targets: [
        .target(
            name: "OpenGraph",
            path: "Sources/OpenGraph",
            exclude: ["Info.plist"]
        ),
         .testTarget(
            name: "OpenGraphTests",
            dependencies: [
                "OpenGraph",
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")
            ],
            path: "Tests",
            resources: [.process("Resources")]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
