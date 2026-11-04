import Flutter
import MapboxCommon
import Turf

final class GeofencingController: NSObject, _GeofencingMessenger, GeofencingObserver {
    private var service: GeofencingService?
    private var observing = false
    private let events = GeofencingEvents()
    private let consentChanges = GeofencingConsentChanges()

    init(binaryMessenger: FlutterBinaryMessenger) {
        super.init()
        events.onChange = { [weak self] in self?.updateObserver() }
        consentChanges.onChange = { [weak self] in self?.updateObserver() }
        GeofencingEventsStreamHandler.register(with: binaryMessenger, streamHandler: events)
        GeofencingConsentChangesStreamHandler.register(with: binaryMessenger, streamHandler: consentChanges)
    }

    func configure(maximumMonitoredFeatures: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let maximum = UInt32(exactly: maximumMonitoredFeatures) else {
            completion(.failure(GeofencingMessengerError(
                code: "GENERIC",
                message: "maximumMonitoredFeatures is out of range",
                details: nil
            )))
            return
        }
        geofencing().configure(options: GeofencingOptions(maximumMonitoredFeatures: maximum)) { result in
            DispatchQueue.main.async {
                completion(result.map { _ in () }.mapError { $0.pigeonError() })
            }
        }
    }

    func getOptions(completion: @escaping (Result<Int64, Error>) -> Void) {
        geofencing().getOptions { result in
            DispatchQueue.main.async {
                completion(result.map { Int64($0.maximumMonitoredFeatures) }.mapError { $0.pigeonError() })
            }
        }
    }

    func addFeature(feature: Turf.Feature, completion: @escaping (Result<String, Error>) -> Void) {
        geofencing().addFeature(feature: feature) { result in
            DispatchQueue.main.async {
                completion(result.mapError { $0.pigeonError() })
            }
        }
    }

    func getFeature(identifier: String, completion: @escaping (Result<GeofenceState, Error>) -> Void) {
        geofencing().getFeature(identifier: identifier) { result in
            DispatchQueue.main.async {
                completion(result.mapError { $0.pigeonError() })
            }
        }
    }

    func removeFeature(identifier: String, completion: @escaping (Result<Void, Error>) -> Void) {
        geofencing().removeFeature(identifier: identifier) { result in
            DispatchQueue.main.async {
                completion(result.map { _ in () }.mapError { $0.pigeonError() })
            }
        }
    }

    func clearFeatures(completion: @escaping (Result<Int64, Error>) -> Void) {
        geofencing().clearFeatures { result in
            DispatchQueue.main.async {
                completion(result.map { Int64($0) }.mapError { $0.pigeonError() })
            }
        }
    }

    func consent() throws -> Bool {
        GeofencingUtils.getUserConsent()
    }

    func active() throws -> Bool {
        GeofencingUtils.isActive()
    }

    func onEntry(event: GeofencingEvent) {
        send(GeofencingEventWireEntry(event: event))
    }

    func onDwell(event: GeofencingEvent) {
        send(GeofencingEventWireDwell(event: event))
    }

    func onExit(event: GeofencingEvent) {
        send(GeofencingEventWireExit(event: event))
    }

    func onError(error: GeofencingError) {
        DispatchQueue.main.async { [weak self] in self?.send(error) }
    }

    func onUserConsentChanged(isConsentGiven: Bool) {
        DispatchQueue.main.async { [consentChanges] in consentChanges.sink?.success(isConsentGiven) }
    }

    private func updateObserver() {
        let listening = events.sink != nil || consentChanges.sink != nil
        guard listening != observing else { return }
        observing = listening
        if listening {
            geofencing().addObserver(observer: self) { [weak self] result in
                guard case .failure(let error) = result else { return }
                DispatchQueue.main.async {
                    self?.observing = false
                    self?.send(error)
                }
            }
        } else {
            geofencing().removeObserver(observer: self) { _ in }
        }
    }

    private func send(_ event: GeofencingEventWire) {
        DispatchQueue.main.async { [events] in events.sink?.success(event) }
    }

    private func send(_ error: GeofencingError) {
        events.sink?.error(code: error.type.wireName, message: error.message, details: nil)
    }

    private func geofencing() -> GeofencingService {
        if let service { return service }
        let created = GeofencingFactory.getOrCreate()
        service = created
        return created
    }
}

private final class GeofencingEvents: GeofencingEventsStreamHandler {
    var sink: PigeonEventSink<GeofencingEventWire>?
    var onChange: () -> Void = {}

    override func onListen(withArguments _: Any?, sink: PigeonEventSink<GeofencingEventWire>) {
        self.sink = sink
        onChange()
    }

    override func onCancel(withArguments _: Any?) {
        sink = nil
        onChange()
    }
}

private final class GeofencingConsentChanges: GeofencingConsentChangesStreamHandler {
    var sink: PigeonEventSink<Bool>?
    var onChange: () -> Void = {}

    override func onListen(withArguments _: Any?, sink: PigeonEventSink<Bool>) {
        self.sink = sink
        onChange()
    }

    override func onCancel(withArguments _: Any?) {
        sink = nil
        onChange()
    }
}

extension GeofencingError {
    fileprivate func pigeonError() -> GeofencingMessengerError {
        GeofencingMessengerError(code: type.wireName, message: message, details: nil)
    }
}

extension GeofencingErrorType {
    fileprivate var wireName: String {
        switch self {
        case .generic: return "GENERIC"
        case .notAvailable: return "NOT_AVAILABLE"
        case .defaultRadiusTooLarge: return "DEFAULT_RADIUS_TOO_LARGE"
        case .monitoredFeaturesLimitReached: return "MONITORED_FEATURES_LIMIT_REACHED"
        case .locationServiceUnavailable: return "LOCATION_SERVICE_UNAVAILABLE"
        case .locationServiceUnauthorized: return "LOCATION_SERVICE_UNAUTHORIZED"
        case .locationServiceInaccurate: return "LOCATION_SERVICE_INACCURATE"
        case .deviceLocationProviderError: return "DEVICE_LOCATION_PROVIDER_ERROR"
        case .featureAlreadyAdded: return "FEATURE_ALREADY_ADDED"
        case .featureNotFound: return "FEATURE_NOT_FOUND"
        case .featureInvalid: return "FEATURE_INVALID"
        case .observerAlreadyAdded: return "OBSERVER_ALREADY_ADDED"
        case .observerNotFound: return "OBSERVER_NOT_FOUND"
        case .featureNotStored: return "FEATURE_NOT_STORED"
        @unknown default: return "GENERIC"
        }
    }
}
