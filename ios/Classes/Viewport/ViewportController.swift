import Foundation
import MapboxMaps
import Flutter
@_implementationOnly import MapboxCommon_Private.MBXLog_Internal

final class ViewportController: _ViewportManagerMessenger {
    private let viewportManager: ViewportManager
    private let binaryMessenger: FlutterBinaryMessenger

    init(viewportManager: ViewportManager, binaryMessenger: FlutterBinaryMessenger) {
        self.viewportManager = viewportManager
        self.binaryMessenger = binaryMessenger
    }

    func getOptions() throws -> ViewportOptions {
        return viewportManager.options.toFLTOptions()
    }

    func setOptions(options: ViewportOptions) throws {
        viewportManager.options = options.toOptions()
    }

    // MARK: - ViewportManager

    func transition(stateStorage: _ViewportStateStorage, transitionIdentifier: Int64?) throws -> Bool {
        let state = viewportManager.viewportStateFromFLTState(stateStorage)
        viewportManager.transition(to: state) { result in
            print(result)
            // TODO: pass the message to completion handler
        }

        return true
    }
}

extension ViewportManager {
    func viewportStateFromFLTState(_ stateStorage: _ViewportStateStorage) -> MapboxMaps.ViewportState {
        switch (stateStorage.type, stateStorage.options) {
        case (.idle, nil):
            fatalError()
        case (.overview, let options as _OverviewViewportStateOptions):
            return makeOverviewViewportState(options: options.toOptions())
        case (.followPuck, let options as _FollowPuckViewportStateOptions):
            return makeFollowPuckViewportState(options: options.toOptions())
        case (.styleDefault, nil):
            fatalError()
        case (.camera, nil):
            fatalError()
        default:
            fatalError()
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
