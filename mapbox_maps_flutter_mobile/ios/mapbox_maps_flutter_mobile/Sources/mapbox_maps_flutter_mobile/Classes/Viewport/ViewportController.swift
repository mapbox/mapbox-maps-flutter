import Foundation
@_spi(Experimental) import MapboxMaps
import Flutter
@_implementationOnly import MapboxCommon_Private.MBXLog_Internal

final class ViewportController: _ViewportMessenger {
    private let viewportManager: ViewportManager
    private let cameraManager: CameraAnimationsManager
    private let mapboxMap: MapboxMap

    init(
        viewportManager: ViewportManager,
        cameraManager: CameraAnimationsManager,
        mapboxMap: MapboxMap
    ) {
        self.viewportManager = viewportManager
        self.cameraManager = cameraManager
        self.mapboxMap = mapboxMap
    }

    // MARK: - ViewportManager

    func transition(stateStorage: _ViewportStateStorage, transitionStorage: _ViewportTransitionStorage?, completion: @escaping (Result<Bool, any Error>) -> Void) {
        do {
            guard let state = try viewportManager.viewportStateFromFLTState(stateStorage, mapboxMap: mapboxMap) else {
                completion(.success(true))
                return
            }
            let transition = viewportManager.transitionFromFLTTransition(transitionStorage, camera: cameraManager)
            viewportManager.transition(to: state, transition: transition) { success in
                completion(.success(success))
            }
        } catch {
            viewportManager.idle()
            Log.error(forMessage: "Viewport", category: error.localizedDescription)
        }
    }
}

extension ViewportManager {
    func viewportStateFromFLTState(_ stateStorage: _ViewportStateStorage, mapboxMap: MapboxMap) throws -> MapboxMaps.ViewportState? {
        switch (stateStorage.type, stateStorage.options) {
        case (.idle, _):
            idle()
            return nil
        case (.overview, let options as _OverviewViewportStateOptions):
            return makeOverviewViewportState(options: options.toOptions())
        case (.followPuck, let options as _FollowPuckViewportStateOptions):
            return makeFollowPuckViewportState(options: options.toOptions())
        case (.styleDefault, _):
            return StyleDefaultViewportState(mapboxMap: mapboxMap)
        case (.camera, let options as CameraOptions):
            return makeCameraViewportState(camera: options.toCameraOptions())
        default:
            throw ViewportInternalError(
                code: "Could not create viewport state ouf of options \(stateStorage)",
                message: nil,
                details: nil
            )
        }
    }
}

extension ViewportManager {
    func transitionFromFLTTransition(
        _ transitionStorage: _ViewportTransitionStorage?,
        camera: CameraAnimationsManager
    ) -> MapboxMaps.ViewportTransition {

        switch (transitionStorage?.type, transitionStorage?.options) {
        case (.defaultTransition, let options as _DefaultViewportTransitionOptions):
            return makeDefaultViewportTransition(options: options.toOptions())
        case (.fly, let options as _FlyViewportTransitionOptions):
            return GenericViewportTransition { cameraOptions, completion in
                camera.fly(to: cameraOptions, duration: options.duration, completion: completion)
            }
        case (.easing, let options as _EasingViewportTransitionOptions):
            return GenericViewportTransition { to, completion in
                camera.cancelAnimations()
                let animator = camera.makeAnimator(
                    duration: options.duration,
                    controlPoint1: options.controlPoint1,
                    controlPoint2: options.controlPoint2,
                    animationOwner: AnimationOwner(rawValue: "com.mapbox.maps.cameraAnimationsManager")
                ) { transition in
                    transition.center.toValue = to.center
                    transition.padding.toValue = to.padding
                    // don't animate the anchor since that's unlikely to be the caller's intent
                    if let anchor = to.anchor {
                        transition.anchor.fromValue = anchor
                        transition.anchor.toValue = anchor
                    }
                    transition.zoom.toValue = to.zoom
                    transition.bearing.toValue = to.bearing
                    transition.pitch.toValue = to.pitch
                }
                animator.addCompletion(completion)
                animator.startAnimation()
                return animator
            }
        default:
            return makeImmediateViewportTransition()
        }
    }
}

extension ViewportOptions {
    func toOptions() -> MapboxMaps.ViewportOptions {
        return .init(transitionsToIdleUponUserInteraction: transitionsToIdleUponUserInteraction)
    }
}

extension MapboxMaps.ViewportOptions {
    func toFLTOptions() -> ViewportOptions {
        return .init(transitionsToIdleUponUserInteraction: transitionsToIdleUponUserInteraction)
    }
}
