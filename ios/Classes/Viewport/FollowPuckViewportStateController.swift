import Foundation
import MapboxMaps
import Flutter
@_implementationOnly import MapboxCommon_Private.MBXLog_Internal

final class FollowPuckViewportStateController: _FollowPuckViewportMessenger {
    private let state: FollowPuckViewportState

    init(state: FollowPuckViewportState) {
        self.state = state
    }

    func getInternalOptions() throws -> _FollowPuckViewportStateOptions {
        return state.options.toFLTOptions()
    }

    func setInternalOptions(options: _FollowPuckViewportStateOptions) throws {
        state.options = options.toOptions()
    }
}

extension FollowPuckViewportStateOptions {
    func toFLTOptions() -> _FollowPuckViewportStateOptions {
        let bearing: _FollowPuckViewportStateBearing?
        var bearingValue: Double?
        switch self.bearing {
        case .heading:
            bearing = .heading
        case .constant(let value):
            bearing = .constant
            bearingValue = value
        case .course:
            bearing = .course
        case .none:
            bearing = nil
        }

        return _FollowPuckViewportStateOptions(
            padding: padding?.toMbxEdgeInsets(),
            zoom: zoom.map(Double.init),
            bearingValue: bearingValue,
            bearing: bearing,
            pitch: pitch.map(Double.init))
    }
}

extension _FollowPuckViewportStateOptions {
    func toOptions() -> FollowPuckViewportStateOptions {
        let bearing: FollowPuckViewportStateBearing?
        switch self.bearing {
        case .heading:
            bearing = .heading
        case .constant:
            if let bearingValue {
                bearing = .constant(bearingValue)
            } else {
                Log.error(forMessage: "Invalid FollowPuckViewportStateOptions, bearing mode is constant but no bearing value was provided", category: "Viewport")
                bearing = nil
            }
        case .course:
            bearing = .course
        case .none:
            bearing = nil
        }
        return .init(
            padding: padding?.toUIEdgeInsets(),
            zoom: zoom?.CGFloat,
            bearing: bearing,
            pitch: pitch?.CGFloat)
    }
}
