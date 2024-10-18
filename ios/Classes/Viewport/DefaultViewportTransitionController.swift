import Foundation
import MapboxMaps
import Flutter

extension DefaultViewportTransitionOptions {
    func toFLTOptions() -> _DefaultViewportTransitionOptions {
        return _DefaultViewportTransitionOptions(maxDurationMs: Int64(maxDuration * 1000.0))
    }
}

extension _DefaultViewportTransitionOptions {
    func toOptions() -> DefaultViewportTransitionOptions {
        return DefaultViewportTransitionOptions(maxDuration: Double(maxDurationMs) / 1000.0)
    }
}
