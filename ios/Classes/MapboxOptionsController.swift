import MapboxMaps
import MapboxCommon
import Flutter

final class MapboxOptionsController: _MapboxOptions, _MapboxMapsOptions {
    private static let errorCode = "0"

    private let settingsService = SettingsServiceFactory.getInstanceFor(.persistent)
    private let assetKeyLookup: (String) -> String

    init(assetKeyLookup: @escaping (String) -> String) {
        self.assetKeyLookup = assetKeyLookup
    }

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

    func getFlutterAssetPath(flutterAssetUri: String?) throws -> String? {
        let flutterAssetRegex = "^asset://(.*?)"
        return flutterAssetUri?.replacingOccurrences(of: flutterAssetRegex, with: "$0\(assetKeyLookup("$1"))", options: .regularExpression)
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

    func getWorldview() throws -> String? {
        return try? settingsService.get(
            key: MapboxCommonSettings.worldview,
            type: String.self)
        .get()
    }

    func setWorldview(worldview: String?) throws {
        _ = settingsService.set(key: MapboxCommonSettings.worldview, value: worldview)
    }

    func getLanguage() throws -> String? {
        return try? settingsService.get(
            key: MapboxCommonSettings.language,
            type: String.self)
        .get()
    }

    func setLanguage(language: String?) throws {
        _ = settingsService.set(key: MapboxCommonSettings.language, value: language)
    }

    func clearData(completion: @escaping (Result<Void, any Error>) -> Void) {
        MapboxMap.clearData { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
