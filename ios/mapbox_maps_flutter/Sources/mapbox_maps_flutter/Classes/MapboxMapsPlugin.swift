import Flutter
import MapboxMaps
import UIKit

public class MapboxMapsPlugin: NSObject, FlutterPlugin {
    private static var httpInterceptorChannel: FlutterMethodChannel?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MapboxMapFactory(withRegistrar: registrar)
        registrar.register(instance, withId: "plugins.flutter.io/mapbox_maps")

        setupStaticChannels(with: registrar)
    }

    private static func setupStaticChannels(with registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger()

        let mapboxOptionsController = MapboxOptionsController(
            assetKeyLookup: registrar.lookupKey(forAsset:))
        let snapshotterInstanceManager = SnapshotterInstanceManager(
            binaryMessenger: binaryMessenger)
        let offlineMapInstanceManager = OfflineMapInstanceManager(binaryMessenger: binaryMessenger)

        _MapboxOptionsSetup.setUp(binaryMessenger: binaryMessenger, api: mapboxOptionsController)
        _MapboxMapsOptionsSetup.setUp(
            binaryMessenger: binaryMessenger, api: mapboxOptionsController)
        _SnapshotterInstanceManagerSetup.setUp(
            binaryMessenger: binaryMessenger, api: snapshotterInstanceManager)
        _OfflineMapInstanceManagerSetup.setUp(
            binaryMessenger: binaryMessenger, api: offlineMapInstanceManager)
        _TileStoreInstanceManagerSetup.setUp(
            binaryMessenger: binaryMessenger, api: offlineMapInstanceManager)
        _OfflineSwitchSetup.setUp(binaryMessenger: binaryMessenger, api: OfflineSwitch.shared)

        LoggingController.setup(binaryMessenger)

        // Setup static HTTP interceptor channel - available before any map is created
        setupHttpInterceptorChannel(binaryMessenger: binaryMessenger)
    }

    private static func setupHttpInterceptorChannel(binaryMessenger: FlutterBinaryMessenger) {
        httpInterceptorChannel = FlutterMethodChannel(
            name: "com.mapbox.maps.flutter/http_interceptor",
            binaryMessenger: binaryMessenger
        )

        let interceptor = CustomHttpServiceInterceptor.shared
        interceptor.setFlutterChannel(httpInterceptorChannel)

        httpInterceptorChannel?.setMethodCallHandler { call, result in
            switch call.method {
            case "setCustomHeaders":
                guard let arguments = call.arguments as? [String: Any],
                    let headers = arguments["headers"] as? [String: String]
                else {
                    result(
                        FlutterError(
                            code: "setCustomHeaders",
                            message: "could not decode arguments",
                            details: nil
                        ))
                    return
                }
                interceptor.setCustomHeaders(headers)
                result(nil)

            case "setHttpInterceptorEnabled":
                guard let arguments = call.arguments as? [String: Any],
                    let enabled = arguments["enabled"] as? Bool,
                    let interceptRequests = arguments["interceptRequests"] as? Bool,
                    let interceptResponses = arguments["interceptResponses"] as? Bool
                else {
                    result(
                        FlutterError(
                            code: "setHttpInterceptorEnabled",
                            message: "could not decode arguments",
                            details: nil
                        ))
                    return
                }
                let includeResponseBody = arguments["includeResponseBody"] as? Bool ?? false
                interceptor.setInterceptorEnabled(
                    enabled: enabled,
                    interceptRequests: interceptRequests,
                    interceptResponses: interceptResponses,
                    includeResponseBody: includeResponseBody
                )
                result(nil)

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
