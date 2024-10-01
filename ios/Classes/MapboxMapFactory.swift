import Flutter
import MapboxMaps
import MapboxCommon
import MapboxCommon_Private

final class MapboxMapFactory: NSObject, FlutterPlatformViewFactory {
    private static let mapCounter = FeatureTelemetryCounter.create(forName: "maps-mobile/flutter/map")

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

        guard let args = args as? [String: Any] else {
            return MapboxMapController(
                withFrame: frame,
                mapInitOptions: MapInitOptions(),
                channelSuffix: 0,
                registrar: registrar,
                pluginVersion: "",
                eventTypes: []
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
            eventTypes: args["eventTypes"] as? [Int] ?? []
        )
    }
}
