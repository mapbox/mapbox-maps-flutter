import MapboxMaps
import Flutter

final class OfflineController: _OfflineManager {
    enum `Error`: Swift.Error {
        case invalidStyleURI
        case invalidStylePackLoadOptions
    }

    private lazy var offlineManager = MapboxCoreMaps.OfflineManager()
    private var progressHandlers: [String: AnyFlutterStreamHandler] = [:]
    private let messenger: SuffixBinaryMessenger

    init(messenger: SuffixBinaryMessenger) {
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
            loadOptions: loadOptions) { [weak self] progress in
                self?.progressHandlers[uri]?.eventSink?(progress.toFLTStylePackLoadProgress().toList())
            } completion: { [weak self] result in
                executeOnMainThread(completion)(result.map { $0.toFLTStylePack() })
                self?.progressHandlers.removeValue(forKey: uri)
            }
    }

    func addStylePackLoadProgressListener(styleURI: String) {
        let handler = AnyFlutterStreamHandler()
        let eventChannel = FlutterEventChannel(name: "com.mapbox.maps.flutter/\(messenger.suffix)/\(styleURI)", binaryMessenger: messenger.messenger)
        eventChannel.setStreamHandler(handler)
        progressHandlers[styleURI] = handler
    }

    func removeStylePack(styleURI: String, completion: @escaping (Result<StylePack, Swift.Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: styleURI) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        offlineManager.removeStylePack(for: styleURI) { result in
            executeOnMainThread(completion)(result.map { $0.toFLTStylePack() })
        }
    }

    func stylePack(styleURI: String, completion: @escaping (Result<StylePack, Swift.Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: styleURI) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        offlineManager.stylePack(for: styleURI) { result in
            executeOnMainThread(completion)(result.map { $0.toFLTStylePack() })
        }
    }

    func stylePackMetadata(styleURI: String, completion: @escaping (Result<[String: Any], Swift.Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: styleURI) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        offlineManager.stylePackMetadata(for: styleURI) { result in
            executeOnMainThread(completion)(result.map { $0 as? [String: Any] ?? [:] })
        }
    }

    func allStylePacks(completion: @escaping (Result<[StylePack], Swift.Error>) -> Void) {
        offlineManager.allStylePacks { result in
            executeOnMainThread(completion)(result.mapElement { $0.toFLTStylePack() })
        }
    }
}

extension OfflineSwitch: _OfflineSwitch {
    func setMapboxStackConnected(connected: Bool) throws {
        isMapboxStackConnected = connected
    }

    func isMapboxStackConnected() throws -> Bool {
        return isMapboxStackConnected
    }

    func reset() throws {}
}
