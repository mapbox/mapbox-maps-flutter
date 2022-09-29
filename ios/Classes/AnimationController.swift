import Foundation
@_spi(Experimental) import MapboxMaps
import UIKit
class AnimationController: NSObject, FLT_AnimationManager {
    private static let errorCode = "0"

    func ease(to cameraOptions: FLTCameraOptions, mapAnimationOptions: FLTMapAnimationOptions?, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        var cameraDuration = 1.0
        if mapAnimationOptions != nil && mapAnimationOptions!.duration != nil {
            cameraDuration = mapAnimationOptions!.duration!.doubleValue / 1000
        }
        cancelable = self.mapView.camera.ease(to: cameraOptions.toCameraOptions(), duration: cameraDuration)
    }

    func fly(to cameraOptions: FLTCameraOptions, mapAnimationOptions: FLTMapAnimationOptions?, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        var cameraDuration = 1.0
        if mapAnimationOptions != nil && mapAnimationOptions!.duration != nil {
            cameraDuration = mapAnimationOptions!.duration!.doubleValue / 1000
        }
        cancelable = self.mapView.camera.fly(to: cameraOptions.toCameraOptions(), duration: cameraDuration)
    }

    func pitch(byPitch pitch: NSNumber, mapAnimationOptions: FLTMapAnimationOptions?, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        error.pointee = FlutterError(code: AnimationController.errorCode, message: "Not available.", details: nil)
    }

    func scale(byAmount amount: NSNumber, screenCoordinate: FLTScreenCoordinate?, mapAnimationOptions: FLTMapAnimationOptions?, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        error.pointee = FlutterError(code: AnimationController.errorCode, message: "Not available.", details: nil)
    }

    func move(by screenCoordinate: FLTScreenCoordinate, mapAnimationOptions: FLTMapAnimationOptions?, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        error.pointee = FlutterError(code: AnimationController.errorCode, message: "Not available.", details: nil)
    }

    func rotate(byFirst first: FLTScreenCoordinate, second: FLTScreenCoordinate, mapAnimationOptions: FLTMapAnimationOptions?, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        error.pointee = FlutterError(code: AnimationController.errorCode, message: "Not available.", details: nil)
    }

    func cancelCameraAnimationWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        if cancelable != nil {
            cancelable?.cancel()
        }
    }

    private var mapView: MapView
    private var cancelable: Cancelable?
    init(withMapView mapView: MapView) {
        self.mapView = mapView
    }
}
