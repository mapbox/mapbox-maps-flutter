import Flutter
import UIKit

public class SwiftMapboxMapsPlugin: MapboxMapsPlugin {
    override public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MapboxMapFactory(withRegistrar: registrar)
        registrar.register(instance, withId: "plugins.flutter.io/mapbox_maps")

        let channel = FlutterMethodChannel(name: "mapbox_maps", binaryMessenger: registrar.messenger())
        channel.setMethodCallHandler { methodCall, result in
            switch methodCall.method {
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
