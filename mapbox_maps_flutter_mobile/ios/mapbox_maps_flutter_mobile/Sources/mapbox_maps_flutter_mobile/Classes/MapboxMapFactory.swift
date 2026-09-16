import Flutter
import MapboxCommon
import MapboxCommon_Private
@_spi(Restricted) import MapboxMaps

final class MapboxMapFactory: NSObject, FlutterPlatformViewFactory {
    private static let mapCounter = FeatureTelemetryCounter.create(
        forName: "maps-mobile/flutter/map")

    /// Set a MapView to be used by the next MapboxMapController instance
    /// created by this factory, instead of creating a new one internally.
    /// The value is consumed (set to nil) after the next create() call.
    @MainActor
    static var pendingMapView: MapView?

    var registrar: FlutterPluginRegistrar

    deinit {
        _MapboxOptionsSetup.setUp(binaryMessenger: registrar.messenger(), api: nil)
        _MapboxMapsOptionsSetup.setUp(binaryMessenger: registrar.messenger(), api: nil)
    }

    init(withRegistrar registrar: FlutterPluginRegistrar) {
        self.registrar = registrar
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return MapInterfacesPigeonCodec.shared
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {

        let externalMapView = MainActor.assumeIsolated { () -> MapView? in
            let view = Self.pendingMapView
            Self.pendingMapView = nil
            return view
        }

        guard let args = args as? [String: Any] else {
            return MapboxMapController(
                withFrame: frame,
                mapInitOptions: MapInitOptions(mapStyle: .standard, uiFramework: .flutter),
                channelSuffix: 0,
                registrar: registrar,
                pluginVersion: "",
                eventTypes: [],
                externalMapView: externalMapView,
                isOpaque: true
            )
        }

        let styleURI = (args["styleUri"] as? String).flatMap(StyleURI.init(rawValue:))
        let isOpaque = args["isOpaque"] as? Bool
        let mapOptions = args["mapOptions"] as? MapOptions
        let cameraOptions = args["cameraOptions"] as? CameraOptions

        let mapInitOptions = MapInitOptions(
            mapStyle: MapStyle(uri: styleURI ?? .standard),
            mapOptions: mapOptions?.toMapOptions() ?? MapboxMaps.MapOptions(),
            cameraOptions: cameraOptions?.toCameraOptions(),
            uiFramework: .flutter
        )

        Self.mapCounter.increment()
        return MapboxMapController(
            withFrame: frame,
            mapInitOptions: mapInitOptions,
            channelSuffix: args["channelSuffix"] as? Int ?? 0,
            registrar: registrar,
            pluginVersion: args["mapboxPluginVersion"] as? String ?? "",
            eventTypes: args["eventTypes"] as? [Int] ?? [],
            externalMapView: externalMapView,
            isOpaque: isOpaque ?? true
        )
    }
}
