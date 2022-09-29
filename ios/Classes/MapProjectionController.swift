import Foundation
import MapboxMaps
import UIKit

class MapProjectionController: NSObject, FLTProjection {
    func getMetersPerPixel(atLatitudeLatitude latitude: NSNumber, zoom: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> NSNumber? {
        let meters = Projection.metersPerPoint(for: CLLocationDegrees(truncating: latitude), zoom: zoom.CGFloat)
        return NSNumber(value: meters)
    }

    func projectedMeters(forCoordinateCoordinate coordinate: [String: Any], error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTProjectedMeters? {
        let projectedMeters = Projection.projectedMeters(for: convertDictionaryToCLLocationCoordinate2D(dict: coordinate)!)
        return FLTProjectedMeters.make(withNorthing: NSNumber(value: projectedMeters.northing), easting: NSNumber(value: projectedMeters.easting))
    }

    func coordinate(forProjectedMetersProjectedMeters projectedMeters: FLTProjectedMeters, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> [String: Any]? {
        let coordinate = Projection.coordinate(for: projectedMeters.toProjectedMeters())
        return coordinate.toDict()
    }

    func projectCoordinate(_ coordinate: [String: Any], zoomScale: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTMercatorCoordinate? {
        let coordinate = Projection.project(convertDictionaryToCLLocationCoordinate2D(dict: coordinate)!, zoomScale: zoomScale.CGFloat)
        return coordinate.toFLTMercatorCoordinate()
    }

    func unprojectCoordinate(_ coordinate: FLTMercatorCoordinate, zoomScale: NSNumber, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> [String: Any]? {
        let point = Projection.unproject(coordinate.toMercatorCoordinate(), zoomScale: zoomScale.CGFloat)
        return point.toDict()
    }
}
