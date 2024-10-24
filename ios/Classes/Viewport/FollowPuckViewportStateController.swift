import Foundation
import MapboxMaps
import Flutter
@_implementationOnly import MapboxCommon_Private.MBXLog_Internal

extension _FollowPuckViewportStateOptions {
    func toOptions() -> FollowPuckViewportStateOptions {
        let bearing: FollowPuckViewportStateBearing?
        switch self.bearing {
        case .heading:
            bearing = .heading
        case .constant:
            if bearingValue == nil {
                Log.error(forMessage: "Invalid FollowPuckViewportStateOptions, bearing mode is constant but no bearing value was provided", category: "Viewport")
            }
            bearing = bearingValue.map(FollowPuckViewportStateBearing.constant)
        case .course:
            bearing = .course
        case .none:
            bearing = nil
        }
        return .init(
            zoom: zoom?.CGFloat,
            bearing: bearing,
            pitch: pitch?.CGFloat)
    }
}
