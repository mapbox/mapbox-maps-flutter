import Flutter
import MapboxMapsFlutterSupport_Private
import MapboxMaps
import MapboxCommon
import MapboxCommon_Private

final class MapboxMapFactory: NSObject, FlutterPlatformViewFactory {
    private static let mapCounter = FeatureTelemetryCounter.create(forName: "maps-mobile/flutter/map")

    private let registrar: FlutterPluginRegistrar
    private let mapRegistry: MapRegistry

    deinit {
        _MapboxOptionsSetup.setUp(binaryMessenger: registrar.messenger(), api: nil)
        _MapboxMapsOptionsSetup.setUp(binaryMessenger: registrar.messenger(), api: nil)
    }

    init(withRegistrar registrar: FlutterPluginRegistrar, mapRegistry: MapRegistry) {
        self.registrar = registrar
        self.mapRegistry = mapRegistry
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return MapInterfacesPigeonCodec.shared
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {

        guard let args = args as? [String: Any] else {
            return MapboxMapController(
                withFrame: frame,
                mapInitOptions: MapInitOptions(),
                channelSuffix: 0,
                registrar: registrar,
                pluginVersion: "",
                eventTypes: [],
                mapRegistry: mapRegistry
            )
        }

        let styleURI = (args["styleUri"] as? String).map(StyleURI.init(rawValue:))
        let mapOptions = args["mapOptions"] as? MapOptions
        let cameraOptions = args["cameraOptions"] as? CameraOptions

        let mapInitOptions = MapInitOptions(
            mapOptions: mapOptions?.toMapOptions() ?? MapboxMaps.MapOptions(),
            cameraOptions: cameraOptions?.toCameraOptions(),
            styleURI: styleURI ?? .standard
        )

        Self.mapCounter.increment()
        return MapboxMapController(
            withFrame: frame,
            mapInitOptions: mapInitOptions,
            channelSuffix: args["channelSuffix"] as? Int ?? 0,
            registrar: registrar,
            pluginVersion: args["mapboxPluginVersion"] as? String ?? "",
            eventTypes: args["eventTypes"] as? [Int] ?? [],
            mapRegistry: mapRegistry
        )
    }
}
