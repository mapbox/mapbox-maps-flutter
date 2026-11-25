import MapboxMaps
import Flutter

final class OfflineController: _OfflineManager {
    enum `Error`: Swift.Error {
        case invalidStyleURI
        case invalidStylePackLoadOptions
    }

    private lazy var offlineManager = MapboxCoreMaps.OfflineManager()
    private var progressHandlers: [Int64: AnyFlutterStreamHandler] = [:]
    private let messenger: SuffixBinaryMessenger
    private let cancelableOperationRegistry: CancelableOperationRegistry

    init(messenger: SuffixBinaryMessenger, cancelableOperationRegistry: CancelableOperationRegistry) {
        self.messenger = messenger
        self.cancelableOperationRegistry = cancelableOperationRegistry
    }

    func loadStylePack(
        styleURI uri: String,
        loadOptions: StylePackLoadOptions,
        operationId: Int64,
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

        let cancelable = offlineManager.loadStylePack(
            for: styleURI,
            loadOptions: loadOptions) { [weak self] progress in
                DispatchQueue.main.async {
                    self?.progressHandlers[operationId]?.eventSink?(progress.toFLTStylePackLoadProgress().toList())
                }
            } completion: { [weak self] result in
                DispatchQueue.main.async {
                    completion(result.map { $0.toFLTStylePack() }.mapPigeonError())
                    self?.cancelableOperationRegistry.unregister(operationId: operationId)
                    self?.progressHandlers.removeValue(forKey: operationId)?.eventSink?(FlutterEndOfEventStream)
                }
            }
        cancelableOperationRegistry.register(operationId: operationId, cancelable: cancelable)
    }

    func addStylePackLoadProgressListener(styleURI: String, operationId: Int64) {
        let eventChannel = FlutterEventChannel(name: "com.mapbox.maps.flutter/\(messenger.suffix)/style-pack-\(operationId)", binaryMessenger: messenger.messenger)
        let handler = AnyFlutterStreamHandler { [weak self] in
            self?.progressHandlers.removeValue(forKey: operationId)
            eventChannel.setStreamHandler(nil)
        }
        eventChannel.setStreamHandler(handler)
        progressHandlers[operationId] = handler
    }

    func removeStylePack(styleURI: String, completion: @escaping (Result<StylePack, Swift.Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: styleURI) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        offlineManager.removeStylePack(for: styleURI) { result in
            executeOnMainThread(completion)(result.map { $0.toFLTStylePack() }.mapPigeonError())
        }
    }

    func stylePack(styleURI: String, completion: @escaping (Result<StylePack, Swift.Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: styleURI) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        offlineManager.stylePack(for: styleURI) { result in
            executeOnMainThread(completion)(result.map { $0.toFLTStylePack() }.mapPigeonError())
        }
    }

    func stylePackMetadata(styleURI: String, completion: @escaping (Result<[String: Any], Swift.Error>) -> Void) {
        guard let styleURI = StyleURI(rawValue: styleURI) else {
            completion(.failure(Error.invalidStyleURI))
            return
        }
        offlineManager.stylePackMetadata(for: styleURI) { result in
            executeOnMainThread(completion)(result.map { $0 as? [String: Any] ?? [:] }.mapPigeonError())
        }
    }

    func allStylePacks(completion: @escaping (Result<[StylePack], Swift.Error>) -> Void) {
        offlineManager.allStylePacks { result in
            executeOnMainThread(completion)(result.mapElement { $0.toFLTStylePack() }.mapPigeonError())
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
