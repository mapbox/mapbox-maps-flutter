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

        var mapInitOptions = MapInitOptions()
        var pluginVersion = ""
        var channelSuffix = 0

        guard let args = args as? [String: Any] else {
            return MapboxMapController(
                withFrame: frame,
                mapInitOptions: mapInitOptions,
                channelSuffix: channelSuffix,
                arguments: args,
                registrar: registrar,
                pluginVersion: pluginVersion,
                eventTypes: []
            )
        }
        var styleURI: StyleURI? = .streets
        if let styleURIString = args["styleUri"] as? String {
            styleURI = StyleURI(rawValue: styleURIString)
        }
        let mapOptions = args["mapOptions"] as? MapOptions
        let cameraOptions = args["cameraOptions"] as? CameraOptions

        mapInitOptions = MapInitOptions(
            mapOptions: mapOptions?.toMapOptions() ?? MapboxMaps.MapOptions(),
            cameraOptions: cameraOptions?.toCameraOptions(),
            styleURI: styleURI
        )

        if let version = args["mapboxPluginVersion"] as? String {
            pluginVersion = version
        }

        if let suffix = args["channelSuffix"] as? Int {
            channelSuffix = suffix
        }

        let eventTypes = args["eventTypes"] as? [Int] ?? []

        Self.mapCounter.increment()
        return MapboxMapController(
            withFrame: frame,
            mapInitOptions: mapInitOptions,
            channelSuffix: channelSuffix,
            arguments: args,
            registrar: registrar,
            pluginVersion: pluginVersion,
            eventTypes: eventTypes
        )
    }
}
