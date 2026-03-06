import Foundation
import MapboxMaps
import UIKit
import Turf

class MapProjectionController: Projection {
    func getMetersPerPixelAtLatitude(latitude: Double, zoom: Double) throws -> Double {
        return MapboxMaps.Projection.metersPerPoint(for: latitude, zoom: zoom)
    }

    func projectedMetersForCoordinate(coordinate: Point) throws -> ProjectedMeters {
        let projectedMeters = MapboxMaps.Projection.projectedMeters(for: coordinate.coordinates)
        return ProjectedMeters(northing: projectedMeters.northing, easting: projectedMeters.easting)
    }

    func coordinateForProjectedMeters(projectedMeters: ProjectedMeters) throws -> Point {
        return Point(MapboxMaps.Projection.coordinate(for: projectedMeters.toProjectedMeters()))
    }

    func project(coordinate: Point, zoomScale: Double) throws -> MercatorCoordinate {
        let coordinate = MapboxMaps.Projection.project(coordinate.coordinates, zoomScale: zoomScale)
        return coordinate.toFLTMercatorCoordinate()
    }

    func unproject(coordinate: MercatorCoordinate, zoomScale: Double) throws -> Point {
        return Point(MapboxMaps.Projection.unproject(coordinate.toMercatorCoordinate(), zoomScale: zoomScale))
    }
}
