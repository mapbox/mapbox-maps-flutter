import Foundation
import MapboxMaps
import Flutter

final class DefaultViewportTransitionController: _DefaultViewportTransitionMessenger {
    let transition: DefaultViewportTransition

    init(transition: DefaultViewportTransition) {
        self.transition = transition
    }

    func getInternalOptions() throws -> _DefaultViewportTransitionOptions {
        return transition.options.toFLTOptions()
    }

    func setInternalOptions(options: _DefaultViewportTransitionOptions) throws {
        transition.options = options.toOptions()
    }
}

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
