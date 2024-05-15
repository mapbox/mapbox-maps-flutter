import MapboxMaps
import Flutter

final class OfflineController: _OfflineManager {

    enum `Error`: Swift.Error {
        case invalidStyleURI
        case invalidStylePackLoadOptions
    }

    private lazy var offlineManager = MapboxCoreMaps.OfflineManager()

    func loadStylePack(styleURI: String, loadOptions: StylePackLoadOptions, completion: @escaping (Result<StylePack, any Swift.Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: styleURI) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        guard let loadOptions = MapboxCoreMaps.StylePackLoadOptions(fltValue: loadOptions) else {
            completion(.failure(Error.invalidStylePackLoadOptions))
            return
        }

        offlineManager.loadStylePack(
            for: styleURI,
            loadOptions: loadOptions) { result in
                completion(result.map { $0.toFLTStylePack() })
            }
    }

    func removeStylePack(styleURI: String, completion: @escaping (Result<StylePack, any Swift.Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: styleURI) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        offlineManager.removeStylePack(for: styleURI) { result in
            completion(result.map { $0.toFLTStylePack() })
        }
    }

    func stylePack(styleURI: String, completion: @escaping (Result<StylePack, any Swift.Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: styleURI) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        offlineManager.stylePack(for: styleURI) { result in
            completion(result.map { $0.toFLTStylePack() })
        }
    }

    func stylePackMetadata(styleURI: String, completion: @escaping (Result<String?, any Swift.Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: styleURI) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        offlineManager.stylePackMetadata(for: styleURI) { result in
            completion(result.map { String(json: $0) })
        }
    }
}
