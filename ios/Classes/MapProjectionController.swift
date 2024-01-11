import Foundation
import MapboxMaps
import UIKit

class MapProjectionController: NSObject, FLTProjection {
    func getMetersPerPixel(atLatitudeLatitude latitude: Double, zoom: Double, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
        let meters = Projection.metersPerPoint(for: latitude, zoom: zoom)
        return NSNumber(value: meters)
    }

    func projectedMeters(forCoordinateCoordinate coordinate: [String: Any], error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTProjectedMeters? {
        let projectedMeters = Projection.projectedMeters(for: convertDictionaryToCLLocationCoordinate2D(dict: coordinate)!)
        return FLTProjectedMeters.make(withNorthing: projectedMeters.northing, easting: projectedMeters.easting)
    }

    func coordinate(forProjectedMetersProjectedMeters projectedMeters: FLTProjectedMeters, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> [String: Any]? {
        let coordinate = Projection.coordinate(for: projectedMeters.toProjectedMeters())
        return coordinate.toDict()
    }

    func projectCoordinate(_ coordinate: [String: Any], zoomScale: Double, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTMercatorCoordinate? {
        let coordinate = Projection.project(convertDictionaryToCLLocationCoordinate2D(dict: coordinate)!, zoomScale: zoomScale)
        return coordinate.toFLTMercatorCoordinate()
    }

    func unprojectCoordinate(_ coordinate: FLTMercatorCoordinate, zoomScale: Double, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> [String: Any]? {
        let point = Projection.unproject(coordinate.toMercatorCoordinate(), zoomScale: zoomScale)
        return point.toDict()
    }
}
