import Foundation
import MapboxMaps
import UIKit

class MapProjectionController: Projection {
    func getMetersPerPixelAtLatitude(latitude: Double, zoom: Double) throws -> Double {
        return MapboxMaps.Projection.metersPerPoint(for: latitude, zoom: zoom)
    }

    func projectedMetersForCoordinate(coordinate: [String?: Any?]) throws -> ProjectedMeters {
        let projectedMeters = MapboxMaps.Projection.projectedMeters(for: convertDictionaryToCLLocationCoordinate2D(dict: coordinate)!)
        return ProjectedMeters(northing: projectedMeters.northing, easting: projectedMeters.easting)
    }

    func coordinateForProjectedMeters(projectedMeters: ProjectedMeters) throws -> [String?: Any?] {
        return MapboxMaps.Projection.coordinate(for: projectedMeters.toProjectedMeters()).toDict()
    }

    func project(coordinate: [String?: Any?], zoomScale: Double) throws -> MercatorCoordinate {
        let coordinate = MapboxMaps.Projection.project(convertDictionaryToCLLocationCoordinate2D(dict: coordinate)!, zoomScale: zoomScale)
        return coordinate.toFLTMercatorCoordinate()
    }

    func unproject(coordinate: MercatorCoordinate, zoomScale: Double) throws -> [String?: Any?] {
        return MapboxMaps.Projection.unproject(coordinate.toMercatorCoordinate(), zoomScale: zoomScale).toDict()
    }
}
