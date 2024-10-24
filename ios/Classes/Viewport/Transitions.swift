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
    typealias AnimationRunner = (MapboxMaps.CameraOptions, @escaping AnimationCompletion) -> Void
    private let runAnimation: AnimationRunner

    internal init(runAnimation: @escaping AnimationRunner) {
        self.runAnimation = runAnimation
    }

    public func run(to toState: MapboxMaps.ViewportState,
                    completion: @escaping (Bool) -> Void) -> MapboxMaps.Cancelable {
        return toState.observeDataSource { [runAnimation] cameraOptions in
            runAnimation(cameraOptions) { animationPosition in
                completion(animationPosition == .end)
            }
            return false
        }
    }
}
