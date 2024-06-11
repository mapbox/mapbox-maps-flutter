import Flutter
import UIKit
import MapboxMaps

public class MapboxMapsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MapboxMapFactory(withRegistrar: registrar)
        registrar.register(instance, withId: "plugins.flutter.io/mapbox_maps")

        setupStaticChannels(with: registrar.messenger())
    }

    private static func setupStaticChannels(with binaryMessenger: FlutterBinaryMessenger) {

        let mapboxOptionsController = MapboxOptionsController()
        let snapshotterInstanceManager = SnapshotterInstanceManager(binaryMessenger: binaryMessenger)
        let offlineMapInstanceManager = OfflineMapInstanceManager(binaryMessenger: binaryMessenger)

        _MapboxOptionsSetup.setUp(binaryMessenger: binaryMessenger, api: mapboxOptionsController)
        _MapboxMapsOptionsSetup.setUp(binaryMessenger: binaryMessenger, api: mapboxOptionsController)
        _SnapshotterInstanceManagerSetup.setUp(binaryMessenger: binaryMessenger, api: snapshotterInstanceManager)
        _OfflineMapInstanceManagerSetup.setUp(binaryMessenger: binaryMessenger, api: offlineMapInstanceManager)
        _TileStoreInstanceManagerSetup.setUp(binaryMessenger: binaryMessenger, api: offlineMapInstanceManager)
        _OfflineSwitchSetup.setUp(binaryMessenger: binaryMessenger, api: OfflineSwitch.shared)

        LoggingController.setup(binaryMessenger)
    }
}
