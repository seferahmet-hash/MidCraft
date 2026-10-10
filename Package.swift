// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MidCraft",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "MidCraft", targets: ["MidCraft"])
    ],
    targets: [
        .executableTarget(
            name: "MidCraft",
            path: "Sources/MidCraft"
        )
    ]
)
