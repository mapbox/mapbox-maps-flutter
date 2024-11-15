import Foundation
import MapboxMaps

extension _DefaultViewportTransitionOptions {
    public func toOptions() -> DefaultViewportTransitionOptions {
        return DefaultViewportTransitionOptions(maxDuration: Double(maxDurationMs) / 1000.0)
    }
}

extension _FlyViewportTransitionOptions {
    public var duration: TimeInterval? { durationMs.map { Double($0) / 1000.0 } }
}

extension _EasingViewportTransitionOptions {
    var duration: TimeInterval { Double(durationMs) / 1000.0 }
    var controlPoint1: CGPoint { CGPoint(x: a, y: b) }
    var controlPoint2: CGPoint { CGPoint(x: c, y: d) }
}

final class GenericViewportTransition: ViewportTransition {
    typealias AnimationRunner = (MapboxMaps.CameraOptions, @escaping AnimationCompletion) -> MapboxMaps.Cancelable
    private let runAnimation: AnimationRunner

    internal init(runAnimation: @escaping AnimationRunner) {
        self.runAnimation = runAnimation
    }

    public func run(to toState: MapboxMaps.ViewportState,
                    completion: @escaping (Bool) -> Void) -> MapboxMaps.Cancelable {
        var transitionAnimationCancellable: MapboxMaps.Cancelable?
        let toStateCancellable = toState.observeDataSource { [runAnimation] cameraOptions in
            transitionAnimationCancellable = runAnimation(cameraOptions) { animationPosition in
                completion(animationPosition == .end)
            }
            return false
        }

        return MapboxMaps.AnyCancelable {
            toStateCancellable.cancel()
            transitionAnimationCancellable?.cancel()
        }
    }
}
