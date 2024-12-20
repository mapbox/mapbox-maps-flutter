// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mapbox_maps_flutter",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "mapbox-maps-flutter", targets: ["MapboxMapsFlutter"])
    ],
    dependencies: [
        .package(url: "https://github.com/mapbox/mapbox-maps-ios.git", exact: "11.9.0-rc.1"),
    ],
    targets: [
        .target(
            // TODO: Update your target name.
            name: "MapboxMapsFlutter",
            dependencies: [
                .product(name: "MapboxMaps", package: "mapbox-maps-ios"),
            ],
            resources: []
        )
    ]
)
