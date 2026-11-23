part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

/// Mobile implementation of [GeofencingPlatformInterface].
final class _GeofencingMobile implements GeofencingPlatformInterface {
  final _messenger = _GeofencingMessenger();

  // Each stream is created once. A second stream on the same channel would
  // take the channel over from the first.
  late final _events = _geofencingEvents();

  @override
  late final Stream<GeofencingEvent> entryEvents =
      _eventsOf<GeofencingEventWireEntry>();

  @override
  late final Stream<GeofencingEvent> dwellEvents =
      _eventsOf<GeofencingEventWireDwell>();

  @override
  late final Stream<GeofencingEvent> exitEvents =
      _eventsOf<GeofencingEventWireExit>();

  @override
  late final Stream<GeofencingError> errors = _events.transform(
    StreamTransformer.fromHandlers(
      handleData: (event, sink) {},
      handleError: (error, stackTrace, sink) => sink.add(
        error is PlatformException
            ? _geofencingError(error.code, error.message ?? '')
            : GeofencingError(
                type: GeofencingErrorType.generic,
                message: '$error',
              ),
      ),
    ),
  );

  @override
  late final Stream<bool> consentChanges = _geofencingConsentChanges();

  @override
  Future<void> configure(int maximumMonitoredFeatures) {
    return _guard(() => _messenger.configure(maximumMonitoredFeatures));
  }

  @override
  Future<int> getOptions() => _guard(_messenger.getOptions);

  @override
  Future<String> addFeature(Feature feature) {
    return _guard(() => _messenger.addFeature(feature));
  }

  @override
  Future<GeofenceState> getFeature(String identifier) {
    return _guard(() => _messenger.getFeature(identifier));
  }

  @override
  Future<void> removeFeature(String identifier) {
    return _guard(() => _messenger.removeFeature(identifier));
  }

  @override
  Future<int> clearFeatures() => _guard(_messenger.clearFeatures);

  @override
  Future<bool> get consent => _guard(_messenger.consent);

  @override
  Future<bool> get isActive => _guard(_messenger.active);

  Stream<GeofencingEvent> _eventsOf<T extends GeofencingEventWire>() => _events
      .handleError((Object _) {})
      .where((wire) => wire is T)
      .map(
        (wire) => switch (wire) {
          GeofencingEventWireEntry(:final event) => event,
          GeofencingEventWireDwell(:final event) => event,
          GeofencingEventWireExit(:final event) => event,
        },
      );

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on PlatformException catch (error) {
      throw _geofencingError(error.code, error.message ?? '');
    }
  }
}

/// Maps a Common error type name, such as `FEATURE_NOT_FOUND`.
GeofencingError _geofencingError(String code, String message) {
  final type = switch (code) {
    'NOT_AVAILABLE' => GeofencingErrorType.notAvailable,
    'DEFAULT_RADIUS_TOO_LARGE' => GeofencingErrorType.defaultRadiusTooLarge,
    'MONITORED_FEATURES_LIMIT_REACHED' =>
      GeofencingErrorType.monitoredFeaturesLimitReached,
    'LOCATION_SERVICE_UNAVAILABLE' =>
      GeofencingErrorType.locationServiceUnavailable,
    'LOCATION_SERVICE_UNAUTHORIZED' =>
      GeofencingErrorType.locationServiceUnauthorized,
    'LOCATION_SERVICE_INACCURATE' =>
      GeofencingErrorType.locationServiceInaccurate,
    'DEVICE_LOCATION_PROVIDER_ERROR' =>
      GeofencingErrorType.deviceLocationProviderError,
    'FEATURE_ALREADY_ADDED' => GeofencingErrorType.featureAlreadyAdded,
    'FEATURE_NOT_FOUND' => GeofencingErrorType.featureNotFound,
    'FEATURE_INVALID' => GeofencingErrorType.featureInvalid,
    'FEATURE_NOT_STORED' => GeofencingErrorType.featureNotStored,
    _ => GeofencingErrorType.generic,
  };
  return GeofencingError(type: type, message: message);
}
