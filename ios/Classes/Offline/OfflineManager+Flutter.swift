import MapboxMaps
import Flutter

final class OfflineController: _OfflineManager {
    enum `Error`: Swift.Error {
        case invalidStyleURI
        case invalidStylePackLoadOptions
    }

    private lazy var offlineManager = MapboxCoreMaps.OfflineManager()
    private var progressHandlers: [String: AnyFlutterStreamHandler] = [:]
    private let messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
    }

    func loadStylePack(
        styleURI uri: String,
        loadOptions: StylePackLoadOptions,
        completion: @escaping (Result<StylePack, Swift.Error>) -> Void
    ) {
        guard let styleURI = StyleURI(rawValue: uri) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        guard let loadOptions = MapboxCoreMaps.StylePackLoadOptions(fltValue: loadOptions) else {
            completion(.failure(Error.invalidStylePackLoadOptions))
            return
        }

        offlineManager.loadStylePack(
            for: styleURI,
            loadOptions: loadOptions,
            progress: { [weak self] progress in
                self?.progressHandlers[uri]?.eventSink?(progress.toFLTStylePackLoadProgress().toList())
            }) { [weak self] result in
                completion(result.map { $0.toFLTStylePack() })
                self?.progressHandlers.removeValue(forKey: uri)
            }
    }

    func addStylePackLoadProgressListener(styleURI: String) {
        let handler = AnyFlutterStreamHandler()
        let eventChannel = FlutterEventChannel(name: "com.mapbox.maps.flutter/offline/\(styleURI)", binaryMessenger: messenger)
        eventChannel.setStreamHandler(handler)
        progressHandlers[styleURI] = handler
    }

    func removeStylePack(styleURI: String, completion: @escaping (Result<StylePack, Swift.Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: styleURI) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        offlineManager.removeStylePack(for: styleURI) { result in
            completion(result.map { $0.toFLTStylePack() })
        }
    }

    func stylePack(styleURI: String, completion: @escaping (Result<StylePack, Swift.Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: styleURI) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        offlineManager.stylePack(for: styleURI) { result in
            completion(result.map { $0.toFLTStylePack() })
        }
    }

    func stylePackMetadata(styleURI: String, completion: @escaping (Result<[String?: Any?]?, Swift.Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: styleURI) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        offlineManager.stylePackMetadata(for: styleURI) { result in
            completion(result.map { $0 as? [String: Any] })
        }
    }
}
