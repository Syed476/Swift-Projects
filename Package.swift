// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MyFirstProject",
    targets: [
        .executableTarget(
            name: "MyFirstProject",
            dependencies: []),
        .testTarget(
            name: "MyFirstProjectTests",
            dependencies: ["MyFirstProject"]),
    ]
)
