import Flutter
import UIKit
import MapboxMaps

public class MapboxMapsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MapboxMapFactory(withRegistrar: registrar)
        registrar.register(instance, withId: "plugins.flutter.io/mapbox_maps")

        setupStaticChannels(with: registrar.messenger())
    }

    private static func setupStaticChannels(with binaryMessanger: FlutterBinaryMessenger) {

        let mapboxOptionsController = MapboxOptionsController()
        let snapshotterInstanceManager = SnapshotterInstanceManager(binaryMessenger: binaryMessanger)

        _MapboxOptionsSetup.setUp(binaryMessenger: binaryMessanger, api: mapboxOptionsController)
        _MapboxMapsOptionsSetup.setUp(binaryMessenger: binaryMessanger, api: mapboxOptionsController)
        _SnapshotterInstanceManagerSetup.setUp(binaryMessenger: binaryMessanger, api: snapshotterInstanceManager)

        LoggingController.setup(binaryMessanger)
    }
}
