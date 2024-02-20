import MapboxMaps
import MapboxCommon
import Flutter

final class MapboxOptionsController: _MapboxOptions, _MapboxMapsOptions {
    private static let errorCode = "0"

    func getBaseUrl() throws -> String {
        MapboxMapsOptions.baseURL.absoluteString
    }

    func setBaseUrl(url: String) throws {
        guard let url = URL(string: url) else {
            throw FlutterError(code: MapboxOptionsController.errorCode, message: "Invalid url", details: nil)
        }
        MapboxMapsOptions.baseURL = url
    }

    func getDataPath() throws -> String {
        MapboxMapsOptions.dataPath.absoluteString
    }

    func setDataPath(path: String) throws {
        guard let url = URL(string: path) else {
            throw FlutterError(code: MapboxOptionsController.errorCode, message: "Invalid url", details: nil)
        }
        MapboxMapsOptions.dataPath = url
    }

    func getAssetPath() throws -> String {
        MapboxMapsOptions.assetPath.absoluteString
    }

    func setAssetPath(path: String) throws {
        guard let url = URL(string: path) else {
            throw FlutterError(code: MapboxOptionsController.errorCode, message: "Invalid url", details: nil)
        }
        MapboxMapsOptions.assetPath = url
    }

    func getTileStoreUsageMode() throws -> TileStoreUsageMode {
        TileStoreUsageMode(rawValue: MapboxMapsOptions.tileStoreUsageMode.rawValue)!
    }

    func setTileStoreUsageMode(mode: TileStoreUsageMode) throws {
        guard let mode = MapboxMaps.TileStoreUsageMode(rawValue: mode.rawValue) else {
            throw FlutterError(code: MapboxOptionsController.errorCode, message: "Invalid tile store usage mode", details: nil)
        }
        MapboxMapsOptions.tileStoreUsageMode = mode
    }

    func getAccessToken() throws -> String {
        MapboxOptions.accessToken
    }

    func setAccessToken(token: String) throws {
        MapboxOptions.accessToken = token
    }
}
