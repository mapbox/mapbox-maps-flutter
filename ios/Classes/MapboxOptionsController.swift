import MapboxMaps
import MapboxCommon

final class MapboxOptionsController: NSObject, FLT_MapboxOptions, FLT_MapboxMapsOptions {
    private static let errorCode = "0"

    func getBaseUrlWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> String? {
        MapboxMapsOptions.baseURL.absoluteString
    }

    func setBaseUrlUrl(_ url: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        guard let url = URL(string: url) else {
            error.pointee = FlutterError(code: MapboxOptionsController.errorCode, message: "Invalid url", details: nil)
            return
        }
        MapboxMapsOptions.baseURL = url
    }

    func getDataPathWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> String? {
        MapboxMapsOptions.dataPath.absoluteString
    }

    func setDataPathPath(_ path: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        guard let url = URL(string: path) else {
            error.pointee = FlutterError(code: MapboxOptionsController.errorCode, message: "Invalid url", details: nil)
            return
        }
        MapboxMapsOptions.dataPath = url
    }

    func getAssetPathWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> String? {
        MapboxMapsOptions.assetPath.absoluteString
    }

    func setAssetPathPath(_ path: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        guard let url = URL(string: path) else {
            error.pointee = FlutterError(code: MapboxOptionsController.errorCode, message: "Invalid url", details: nil)
            return
        }
        MapboxMapsOptions.assetPath = url
    }

    func getTileStoreUsageModeWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> FLTTileStoreUsageModeBox? {
        FLTTileStoreUsageModeBox(value: FLTTileStoreUsageMode(rawValue: UInt(MapboxMapsOptions.tileStoreUsageMode.rawValue))!)
    }

    func setTileStoreUsageModeMode(_ mode: FLTTileStoreUsageMode, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        guard let mode = TileStoreUsageMode(rawValue: Int(mode.rawValue)) else {
            error.pointee = FlutterError(code: MapboxOptionsController.errorCode, message: "Invalid tile store usage mode", details: nil)
            return
        }
        MapboxMapsOptions.tileStoreUsageMode = mode
    }

    func getAccessTokenWithError(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) -> String? {
        MapboxOptions.accessToken
    }

    func setAccessTokenToken(_ token: String, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        MapboxOptions.accessToken = token
    }
}
