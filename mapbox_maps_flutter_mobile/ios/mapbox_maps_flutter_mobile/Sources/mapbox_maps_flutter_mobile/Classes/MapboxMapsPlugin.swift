import Flutter
import UIKit
import MapboxMaps

public class MapboxMapsPlugin: NSObject, FlutterPlugin {
    private let cancelableOperationRegistry = CancelableOperationRegistry()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MapboxMapFactory(withRegistrar: registrar)
        registrar.register(instance, withId: "plugins.flutter.io/mapbox_maps")

        let plugin = MapboxMapsPlugin()
        // The engine calls `detachFromEngine(for:)` only on a published plugin.
        registrar.publish(plugin)
        setupStaticChannels(with: registrar, cancelableOperationRegistry: plugin.cancelableOperationRegistry)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        cancelableOperationRegistry.cancelAll()
    }

    private static func setupStaticChannels(
        with registrar: FlutterPluginRegistrar,
        cancelableOperationRegistry: CancelableOperationRegistry
    ) {
        let binaryMessenger = registrar.messenger()

        let mapboxOptionsController = MapboxOptionsController(assetKeyLookup: registrar.lookupKey(forAsset:))
        let snapshotterInstanceManager = SnapshotterInstanceManager(binaryMessenger: binaryMessenger)
        let offlineMapInstanceManager = OfflineMapInstanceManager(
            binaryMessenger: binaryMessenger,
            cancelableOperationRegistry: cancelableOperationRegistry
        )

        _MapboxOptionsSetup.setUp(binaryMessenger: binaryMessenger, api: mapboxOptionsController)
        _MapboxMapsOptionsSetup.setUp(binaryMessenger: binaryMessenger, api: mapboxOptionsController)
        _SnapshotterInstanceManagerSetup.setUp(binaryMessenger: binaryMessenger, api: snapshotterInstanceManager)
        _OfflineMapInstanceManagerSetup.setUp(binaryMessenger: binaryMessenger, api: offlineMapInstanceManager)
        _TileStoreInstanceManagerSetup.setUp(binaryMessenger: binaryMessenger, api: offlineMapInstanceManager)
        _CancelableOperationMessengerSetup.setUp(binaryMessenger: binaryMessenger, api: cancelableOperationRegistry)
        _OfflineSwitchSetup.setUp(binaryMessenger: binaryMessenger, api: OfflineSwitch.shared)

        LoggingController.setup(binaryMessenger)
        _GeofencingMessengerSetup.setUp(
            binaryMessenger: binaryMessenger,
            api: GeofencingController(binaryMessenger: binaryMessenger)
        )
        _HttpServiceMessengerSetup.setUp(binaryMessenger: binaryMessenger, api: HttpServiceController())
    }
}
