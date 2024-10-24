import Foundation
import MapboxMaps
import Flutter

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
