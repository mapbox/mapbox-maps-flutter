import Foundation
@_spi(Experimental) import MapboxMaps
import Flutter

final class AnimationController: _AnimationManager {
    private static let errorCode = "0"

    func easeTo(cameraOptions: CameraOptions, mapAnimationOptions: MapAnimationOptions?) throws {
        var cameraDuration = 1.0
        if mapAnimationOptions != nil && mapAnimationOptions!.duration != nil {
            cameraDuration = Double(mapAnimationOptions!.duration!) / 1000.0
        }
        cancelable = camera.ease(to: cameraOptions.toCameraOptions(), duration: cameraDuration)
    }

    func flyTo(cameraOptions: CameraOptions, mapAnimationOptions: MapAnimationOptions?) throws {
        var cameraDuration = 1.0
        if mapAnimationOptions != nil && mapAnimationOptions!.duration != nil {
            cameraDuration = Double(mapAnimationOptions!.duration!) / 1000.0
        }
        cancelable = camera.fly(to: cameraOptions.toCameraOptions(), duration: cameraDuration)
    }

    func pitchBy(pitch: Double, mapAnimationOptions: MapAnimationOptions?) throws {
        throw FlutterError(code: AnimationController.errorCode, message: "Not available.", details: nil)
    }

    func scaleBy(amount: Double, screenCoordinate: ScreenCoordinate?, mapAnimationOptions: MapAnimationOptions?) throws {
        throw FlutterError(code: AnimationController.errorCode, message: "Not available.", details: nil)
    }

    func moveBy(screenCoordinate: ScreenCoordinate, mapAnimationOptions: MapAnimationOptions?) throws {
        throw FlutterError(code: AnimationController.errorCode, message: "Not available.", details: nil)
    }

    func rotateBy(first: ScreenCoordinate, second: ScreenCoordinate, mapAnimationOptions: MapAnimationOptions?) throws {
        throw FlutterError(code: AnimationController.errorCode, message: "Not available.", details: nil)
    }

    func cancelCameraAnimation() throws {
        if cancelable != nil {
            cancelable?.cancel()
        }
    }

    private var camera: CameraAnimationsManager
    private var cancelable: MapboxMaps.Cancelable?
    init(withMapView mapView: MapView) {
        self.camera = mapView.camera
    }
}
