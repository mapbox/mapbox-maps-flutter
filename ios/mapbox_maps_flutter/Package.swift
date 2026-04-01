// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let mapboxMapsVersion: Version = "11.22.0-SNAPSHOT-04-01--11-26.git-ba43138"

let mapboxMapsPackage = mapboxMapsVersion.description.contains("SNAPSHOT")
    ? "mapbox-maps-ios-binary"
    : "mapbox-maps-ios"

let package = Package(
    name: "mapbox_maps_flutter",
    platforms: [
        .iOS("14.0")
    ],
    products: [
        .library(name: "mapbox-maps-flutter", targets: ["mapbox_maps_flutter"])
    ],
    dependencies: [
        .package(url: "https://github.com/mapbox/\(mapboxMapsPackage).git", exact: mapboxMapsVersion)
    ],
    targets: [
        .target(
            name: "mapbox_maps_flutter",
            dependencies: [
                .product(name: "MapboxMaps", package: mapboxMapsPackage)
            ],
            resources: []
        )
    ]
)
