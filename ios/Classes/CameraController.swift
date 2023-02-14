import Foundation
import MapboxMaps
import UIKit
class CameraController: NSObject, FLT_CameraManager {
    func camera(forCoordinateBoundsBounds bounds: FLTCoordinateBounds, padding: FLTMbxEdgeInsets, bearing: NSNumber?, pitch: NSNumber?, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCameraOptions? {
        let cameraOptions = self.mapboxMap.camera(for: bounds.toCoordinateBounds(), padding: padding.toUIEdgeInsets(), bearing: bearing?.doubleValue, pitch: pitch?.doubleValue)
        return cameraOptions.toFLTCameraOptions()
    }

    func camera(forCoordinatesCoordinates coordinates: [[String: Any]], padding: FLTMbxEdgeInsets, bearing: NSNumber?, pitch: NSNumber?, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCameraOptions? {
        let cameraOptions = self.mapboxMap.camera(for: coordinates.map({convertDictionaryToCLLocationCoordinate2D(dict: $0)!}), padding: padding.toUIEdgeInsets(), bearing: bearing?.doubleValue, pitch: pitch?.doubleValue)
        return cameraOptions.toFLTCameraOptions()
    }

    func camera(forCoordinatesCameraOptionsCoordinates coordinates: [[String: Any]], camera: FLTCameraOptions, box: FLTScreenBox, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCameraOptions? {
        let cameraOptions = self.mapboxMap.camera(for: coordinates.map({convertDictionaryToCLLocationCoordinate2D(dict: $0)!}), camera: camera.toCameraOptions(), rect: box.toCGRect())
        return cameraOptions.toFLTCameraOptions()
    }

    func camera(forGeometryGeometry geometry: [String: Any], padding: FLTMbxEdgeInsets, bearing: NSNumber?, pitch: NSNumber?, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCameraOptions? {
        let cameraOptions = self.mapboxMap.camera(for: convertDictionaryToGeometry(dict: geometry)!, padding: padding.toUIEdgeInsets(), bearing: bearing?.CGFloat, pitch: pitch?.CGFloat)
        return cameraOptions.toFLTCameraOptions()
    }

    func coordinateBounds(forCameraCamera camera: FLTCameraOptions, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCoordinateBounds? {
        let bounds = self.mapboxMap.coordinateBounds(for: camera.toCameraOptions())
        return bounds.toFLTCoordinateBounds()
    }

    func coordinateBounds(forCameraUnwrappedCamera camera: FLTCameraOptions, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCoordinateBounds? {
        // TODO use unwrapped api
        let bounds = self.mapboxMap.coordinateBounds(for: camera.toCameraOptions())
        return bounds.toFLTCoordinateBounds()
    }

    func coordinateBoundsZoom(forCameraCamera camera: FLTCameraOptions, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCoordinateBoundsZoom? {
        let coordinate = self.mapboxMap.coordinateBoundsZoom(for: camera.toCameraOptions())
        return coordinate.toFLTCoordinateBoundsZoom()
    }

    func coordinateBoundsZoom(forCameraUnwrappedCamera camera: FLTCameraOptions, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCoordinateBoundsZoom? {
        let coordinate = self.mapboxMap.coordinateBoundsZoomUnwrapped(for: camera.toCameraOptions())
        return coordinate.toFLTCoordinateBoundsZoom()
    }

    func pixel(forCoordinateCoordinate coordinate: [String: Any], error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTScreenCoordinate? {
        let point = self.mapboxMap.point(for: convertDictionaryToCLLocationCoordinate2D(dict: coordinate)!)
        return point.toFLTScreenCoordinate()
    }

    func coordinate(forPixelPixel pixel: FLTScreenCoordinate, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> [String: Any]? {
        let coordinate = self.mapboxMap.coordinate(for: pixel.toCGPoint())
        return coordinate.toDict()
    }

    func pixels(forCoordinatesCoordinates coordinates: [[String: Any]], error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> [FLTScreenCoordinate]? {
        let points = self.mapboxMap.points(for: coordinates.map({convertDictionaryToCLLocationCoordinate2D(dict: $0)!}))
        return points.map({$0.toFLTScreenCoordinate()})
    }

    func coordinates(forPixelsPixels pixels: [FLTScreenCoordinate], error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> [[String: Any]]? {
        let coordinates = self.mapboxMap.coordinates(for: pixels.map({$0.toCGPoint()}) )
        return coordinates.map({$0.toDict()})
    }

    func setCameraCameraOptions(_ cameraOptions: FLTCameraOptions, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        self.mapboxMap.setCamera(to: cameraOptions.toCameraOptions())
    }

    func getCameraStateWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCameraState? {
        let camera = self.mapboxMap.cameraState
        return FLTCameraState.make(withCenter: ["coordinates": [camera.center.longitude, camera.center.latitude]], padding: FLTMbxEdgeInsets.make(withTop: NSNumber(value: camera.padding.top), left: NSNumber(value: camera.padding.left), bottom: NSNumber(value: camera.padding.bottom), right: NSNumber(value: camera.padding.right)), zoom: NSNumber(value: camera.zoom), bearing: NSNumber(value: camera.bearing), pitch: NSNumber(value: camera.pitch))
    }

    func setBoundsOptions(_ options: FLTCameraBoundsOptions, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        do {
            try self.mapboxMap.setCameraBounds(with: options.toCameraBoundsOptions())
        } catch {
            print("Failed to setCameraBounds. Error: \(error)")
        }
    }

    func getBoundsWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCameraBounds? {
        return self.mapboxMap.cameraBounds.toFLTCameraBounds()
    }

    func dragStartPoint(_ point: FLTScreenCoordinate, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        self.mapboxMap.dragStart(for: point.toCGPoint())
    }

    func getDragCameraOptions(fromPoint: FLTScreenCoordinate, toPoint: FLTScreenCoordinate, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTCameraOptions? {
        return self.mapboxMap.dragCameraOptions(from: fromPoint.toCGPoint(), to: toPoint.toCGPoint()).toFLTCameraOptions()
    }

    func dragEndWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        self.mapboxMap.dragEnd()
    }

    private var mapboxMap: MapboxMap
    init(withMapboxMap mapboxMap: MapboxMap) {
        self.mapboxMap = mapboxMap
    }
}
