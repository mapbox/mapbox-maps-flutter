import Flutter
import UIKit

public class MapboxMapsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MapboxMapFactory(withRegistrar: registrar)
        registrar.register(instance, withId: "plugins.flutter.io/mapbox_maps")

        let channel = FlutterMethodChannel(name: "mapbox_maps", binaryMessenger: registrar.messenger())
        channel.setMethodCallHandler { methodCall, result in
            switch methodCall.method {
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        setupStaticChannels(with: registrar.messenger())
    }

    private static func setupStaticChannels(with binaryMessanger: FlutterBinaryMessenger) {
        // Register MapboxMapsOptions and MapboxOptions
        let mapboxOptionsController = MapboxOptionsController()
        _MapboxOptionsSetup.setUp(binaryMessenger: binaryMessanger, api: mapboxOptionsController)
        _MapboxMapsOptionsSetup.setUp(binaryMessenger: binaryMessanger, api: mapboxOptionsController)

        LoggingController.setup(binaryMessanger)
    }
}
