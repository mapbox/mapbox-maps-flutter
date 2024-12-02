import Foundation
import MapboxMaps
import Flutter
import UIKit
@_implementationOnly import MapboxCommon_Private.MBXLog_Internal

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

final class StyleDefaultViewportState: ViewportState {
    private var token: AnyCancelable?

    private let result: Signal<StyleLoaded>
    private let mapboxMap: MapboxMap

    init(mapboxMap: MapboxMap) {
        if mapboxMap.isStyleLoaded {
            result = Signal(just: StyleLoaded(timeInterval: EventTimeInterval(begin: Date(), end: Date())))
        } else {
            result = mapboxMap.onStyleLoaded
        }

        self.mapboxMap = mapboxMap
    }

    func observeDataSource(with handler: @escaping (MapboxMaps.CameraOptions) -> Bool) -> MapboxMaps.Cancelable {
        return result.observe { [mapboxMap] _ in
            _ = handler(mapboxMap.styleDefaultCamera)
        }
    }

    func startUpdatingCamera() {
        token = result.observe { [mapboxMap] _ in
            mapboxMap.setCamera(to: mapboxMap.styleDefaultCamera)
        }
    }

    func stopUpdatingCamera() {
        token = nil
    }
}
