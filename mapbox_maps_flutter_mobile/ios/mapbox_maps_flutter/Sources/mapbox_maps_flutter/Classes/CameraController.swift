import MapboxMaps
import Foundation
import Flutter
import Turf

final class CameraController: _CameraManager {
    private static let errorCode = "0"

    func cameraForCoordinatesPadding(coordinates: [Point], camera: CameraOptions, coordinatesPadding: MbxEdgeInsets?, maxZoom: Double?, offset: ScreenCoordinate?) throws -> CameraOptions {
        do {
            let camera = try mapboxMap.camera(
                for: coordinates.map(\.coordinates),
                camera: camera.toCameraOptions(),
                coordinatesPadding: coordinatesPadding?.toUIEdgeInsets(),
                maxZoom: maxZoom,
                offset: offset?.toCGPoint())
            return camera.toFLTCameraOptions()
        } catch let cameraError {
            throw FlutterError(code: CameraController.errorCode, message: cameraError.localizedDescription, details: nil)
        }
    }

    func cameraForCoordinateBounds(bounds: CoordinateBounds, padding: MbxEdgeInsets?, bearing: Double?, pitch: Double?, maxZoom: Double?, offset: ScreenCoordinate?) throws -> CameraOptions {
        let camera = mapboxMap.camera(
            for: bounds.toCoordinateBounds(),
            padding: padding?.toUIEdgeInsets(),
            bearing: bearing,
            pitch: pitch,
            maxZoom: maxZoom,
            offset: offset?.toCGPoint())
        return camera.toFLTCameraOptions()
    }

    func cameraForCoordinates(coordinates: [Point], padding: MbxEdgeInsets?, bearing: Double?, pitch: Double?) throws -> CameraOptions {
        let cameraOptions = mapboxMap.camera(
            for: coordinates.map(\.coordinates),
            padding: padding?.toUIEdgeInsets(),
            bearing: bearing,
            pitch: pitch)
        return cameraOptions.toFLTCameraOptions()
    }

    func cameraForCoordinatesCameraOptions(coordinates: [Point], camera: CameraOptions, box: ScreenBox) throws -> CameraOptions {
        let cameraOptions = mapboxMap.camera(
            for: coordinates.map(\.coordinates),
            camera: camera.toCameraOptions(),
            rect: box.toCGRect())
        return cameraOptions.toFLTCameraOptions()
    }

    func cameraForGeometry(geometry: [String?: Any?], padding: MbxEdgeInsets, bearing: Double?, pitch: Double?) throws -> CameraOptions {
        let cameraOptions = mapboxMap.camera(
            for: convertDictionaryToGeometry(dict: geometry)!,
            padding: padding.toUIEdgeInsets(),
            bearing: bearing?.CGFloat,
            pitch: pitch?.CGFloat)
        return cameraOptions.toFLTCameraOptions()
    }

    func coordinateBoundsForCamera(camera: CameraOptions) throws -> CoordinateBounds {
        let bounds = self.mapboxMap.coordinateBounds(for: camera.toCameraOptions())
        return bounds.toFLTCoordinateBounds()
    }

    func coordinateBoundsForCameraUnwrapped(camera: CameraOptions) throws -> CoordinateBounds {
        // TODO use unwrapped api
        let bounds = self.mapboxMap.coordinateBounds(for: camera.toCameraOptions())
        return bounds.toFLTCoordinateBounds()
    }

    func coordinateBoundsZoomForCamera(camera: CameraOptions) throws -> CoordinateBoundsZoom {
        let coordinate = self.mapboxMap.coordinateBoundsZoom(for: camera.toCameraOptions())
        return coordinate.toFLTCoordinateBoundsZoom()
    }

    func coordinateBoundsZoomForCameraUnwrapped(camera: CameraOptions) throws -> CoordinateBoundsZoom {
        let coordinate = self.mapboxMap.coordinateBoundsZoomUnwrapped(for: camera.toCameraOptions())
        return coordinate.toFLTCoordinateBoundsZoom()
    }

    func pixelForCoordinate(coordinate: Point) throws -> ScreenCoordinate {
        let point = self.mapboxMap.point(for: coordinate.coordinates)
        return point.toFLTScreenCoordinate()
    }

    func coordinateForPixel(pixel: ScreenCoordinate) throws -> Point {
        let coordinate = self.mapboxMap.coordinate(for: pixel.toCGPoint())
        return Point(coordinate)
    }

    func pixelsForCoordinates(coordinates: [Point]) throws -> [ScreenCoordinate?] {
        let points = self.mapboxMap.points(for: coordinates.map(\.coordinates))
        return points.map({$0.toFLTScreenCoordinate()})
    }

    func coordinatesForPixels(pixels: [ScreenCoordinate?]) throws -> [Point] {
        let coordinates = self.mapboxMap.coordinates(for: pixels.compactMap({$0?.toCGPoint()}) )
        return coordinates.map(Point.init)
    }

    func setCamera(cameraOptions: CameraOptions) throws {
        self.mapboxMap.setCamera(to: cameraOptions.toCameraOptions())
    }

    func getCameraState() throws -> CameraState {
        return mapboxMap.cameraState.toFLTCameraState()
    }

    func setBounds(options: CameraBoundsOptions) throws {
        do {
            try self.mapboxMap.setCameraBounds(with: options.toCameraBoundsOptions())
        } catch {
            print("Failed to setCameraBounds. Error: \(error)")
        }
    }

    func getBounds() throws -> CameraBounds {
        return self.mapboxMap.cameraBounds.toFLTCameraBounds()
    }

    private var mapboxMap: MapboxMap
    init(withMapboxMap mapboxMap: MapboxMap) {
        self.mapboxMap = mapboxMap
    }
}
