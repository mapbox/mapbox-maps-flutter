import Foundation
import MapboxMaps
import Flutter

final class OverviewViewportStateController: _OverviewViewportMessenger {
    private let overviewState: OverviewViewportState

    init(overviewState: OverviewViewportState) {
        self.overviewState = overviewState
    }

    func getInternalOptions() throws -> _OverviewViewportStateOptions {
        return overviewState.options.toFLTOptions()
    }

    func setInternalOptions(options: _OverviewViewportStateOptions) throws {
        overviewState.options = options.toOptions()
    }
}

extension OverviewViewportStateOptions {
    func toFLTOptions() -> _OverviewViewportStateOptions {
        let data = try! JSONEncoder().encode(geometry)
        let bar = _OverviewViewportStateOptions(
            geometry: String(decoding: data, as: UTF8.self),
            geometryPadding: geometryPadding.toMbxEdgeInsets(),
            bearing: bearing,
            pitch: pitch.map(Double.init),
            padding: padding?.toMbxEdgeInsets(),
            maxZoom: maxZoom,
            offset: offset?.toFLTScreenCoordinate(),
            animationDurationMs: Int64(animationDuration * 1000)
        )
        return bar
    }
}

extension _OverviewViewportStateOptions {
    func toOptions() -> OverviewViewportStateOptions {
        let geometry = try! JSONDecoder().decode(Geometry.self, from: geometry.data(using: .utf8)!)
        return .init(
            geometry: geometry,
            geometryPadding: geometryPadding.toUIEdgeInsets(),
            bearing: bearing,
            pitch: pitch?.CGFloat,
            padding: padding?.toUIEdgeInsets(),
            maxZoom: maxZoom,
            offset: offset?.toCGPoint(),
            animationDuration: Double(animationDurationMs) / 1000.0
        )
    }
}
