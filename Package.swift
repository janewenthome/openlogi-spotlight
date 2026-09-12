// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "OpenLogiSpotlight",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .executable(name: "OpenLogiSpotlight", targets: ["OpenLogiSpotlight"]),
    ],
    targets: [
        .executableTarget(
            name: "OpenLogiSpotlight",
            path: "Sources/OpenLogiSpotlight"
        ),
    ]
)
