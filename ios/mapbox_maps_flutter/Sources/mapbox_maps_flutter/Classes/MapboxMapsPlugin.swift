import Flutter
import UIKit
import MapboxMaps

public class MapboxMapsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = MapboxMapFactory(withRegistrar: registrar)
        registrar.register(instance, withId: "plugins.flutter.io/mapbox_maps")

        setupHeadlessChannel(with: registrar)
        setupStaticChannels(with: registrar)
    }

    private static func setupHeadlessChannel(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugins.flutter.io/mapbox_maps_headless",
                                           binaryMessenger: registrar.messenger())
        channel.setMethodCallHandler { call, result in
            let args = call.arguments as? [String: Any] ?? [:]
            switch call.method {
            case "create":
                let width = args["width"] as? Double ?? 0
                let height = args["height"] as? Double ?? 0
                guard width > 0, height > 0 else {
                    result(FlutterError(code: "bad_size",
                                        message: "width and height are required",
                                        details: nil))
                    return
                }
                var options = MapInitOptions()
                if let uri = args["styleUri"] as? String {
                    options = MapInitOptions(styleURI: StyleURI(rawValue: uri))
                }
                let suffix = (args["channelSuffix"] as? Int) ?? 9000
                let id = HeadlessMapTexture.create(
                    size: CGSize(width: width, height: height),
                    channelSuffix: suffix,
                    options: options,
                    registrar: registrar
                )
                result(id)
            case "pump":
                if let id = args["textureId"] as? Int64 ?? (args["textureId"] as? Int).map(Int64.init) {
                    HeadlessMapTexture.pump(textureId: id)
                }
                result(nil)
            case "ornaments":
                let id = Int64((args["textureId"] as? Int) ?? -1)
                result(HeadlessMapTexture.ornaments(textureId: id))
            case "resize":
                let id = Int64((args["textureId"] as? Int) ?? -1)
                HeadlessMapTexture.resize(
                    textureId: id,
                    size: CGSize(width: args["width"] as? Double ?? 0,
                                 height: args["height"] as? Double ?? 0)
                )
                result(nil)
            case "panBegin", "panUpdate", "panEnd", "zoomBy", "rotateBy", "pitchBy":
                let id = Int64((args["textureId"] as? Int) ?? -1)
                let x = args["x"] as? Double ?? 0
                let y = args["y"] as? Double ?? 0
                let point = CGPoint(x: x, y: y)
                switch call.method {
                case "panBegin": HeadlessMapTexture.panBegin(textureId: id, at: point)
                case "panUpdate": HeadlessMapTexture.panUpdate(textureId: id, to: point)
                case "panEnd": HeadlessMapTexture.panEnd(textureId: id)
                case "rotateBy":
                    HeadlessMapTexture.rotateBy(textureId: id,
                                                radians: args["radians"] as? Double ?? 0,
                                                at: point)
                case "pitchBy":
                    HeadlessMapTexture.pitchBy(textureId: id,
                                               delta: args["delta"] as? Double ?? 0)
                default:
                    HeadlessMapTexture.zoomBy(textureId: id,
                                              delta: args["delta"] as? Double ?? 0,
                                              at: point)
                }
                result(nil)
            case "dispose":
                if let id = args["textureId"] as? Int64 ?? (args["textureId"] as? Int).map(Int64.init) {
                    HeadlessMapTexture.dispose(textureId: id)
                }
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private static func setupStaticChannels(with registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger()

        let mapboxOptionsController = MapboxOptionsController(assetKeyLookup: registrar.lookupKey(forAsset:))
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
