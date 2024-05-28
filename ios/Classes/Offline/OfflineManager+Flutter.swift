import MapboxMaps
import Flutter

final class OfflineController: _OfflineManager {

    enum `Error`: Swift.Error {
        case invalidStyleURI
        case invalidStylePackLoadOptions
    }

    private lazy var offlineManager = MapboxCoreMaps.OfflineManager()
    private var progressHandlers: [String: StylePackLoadProgressHandler] = [:]
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
                self?.progressHandlers[uri]?.progress = progress.toFLTStylePackLoadProgress()
            }) { [weak self] result in
                completion(result.map { $0.toFLTStylePack() })
                self?.progressHandlers.removeValue(forKey: uri)
            }
    }

    func addStylePackLoadProgressListener(styleURI: String) {
        let handler = StylePackLoadProgressHandler()
        let eventChannel = FlutterEventChannel(name: "com.mapbox.maps.flutter/offline/\(styleURI)", binaryMessenger: messenger)
        eventChannel.setStreamHandler(handler)
        progressHandlers[styleURI] = handler
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

private class StylePackLoadProgressHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    var progress: StylePackLoadProgress! {
        didSet {
            guard let progress else { return }
            eventSink?(progress.toList())
        }
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
