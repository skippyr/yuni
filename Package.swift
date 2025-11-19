// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "yuni",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(
            url: "https://github.com/skippyr/Teco",
            from: "1.0.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "yuni",
            dependencies: ["Teco"]
        )
    ]
)
