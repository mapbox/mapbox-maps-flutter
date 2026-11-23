import 'dart:convert';

import 'package:turf/turf.dart';

/// An entry, dwell, or exit of a monitored feature.
final class GeofencingEvent {
  /// The monitored feature.
  final Feature feature;

  /// When the event happened.
  final DateTime timestamp;

  /// Creates an entry, dwell, or exit event.
  const GeofencingEvent({required this.feature, required this.timestamp});

  Object encode() {
    return [feature.toJson(), timestamp.millisecondsSinceEpoch];
  }

  static GeofencingEvent decode(Object result) {
    result as List<Object?>;
    return GeofencingEvent(
      feature: _decodeFeature(result[0]),
      timestamp: DateTime.fromMillisecondsSinceEpoch(result[1]! as int),
    );
  }
}

/// A monitored feature and, while the user is inside it, when they entered.
final class GeofenceState {
  /// The monitored feature.
  final Feature feature;

  /// When the user entered. Null while the user is outside.
  final DateTime? timestamp;

  /// Creates a geofence state.
  const GeofenceState({required this.feature, this.timestamp});

  Object encode() {
    return [feature.toJson(), timestamp?.millisecondsSinceEpoch];
  }

  static GeofenceState decode(Object result) {
    result as List<Object?>;
    final timestamp = result[1] as int?;
    return GeofenceState(
      feature: _decodeFeature(result[0]),
      timestamp: timestamp == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }
}

// Codec maps are `Map<Object?, Object?>` at every level, and turf expects
// `Map<String, dynamic>`.
Feature _decodeFeature(Object? json) {
  return Feature.fromJson(
    (jsonDecode(jsonEncode(json)) as Map).cast<String, dynamic>(),
  );
}

/// Failure reported by the geofencing service.
///
/// New types may be added in minor releases.
final class GeofencingErrorType {
  const GeofencingErrorType._(this.name);

  /// The type name.
  final String name;

  /// Generic error.
  static const generic = GeofencingErrorType._('generic');

  /// The geofencing service is not available.
  static const notAvailable = GeofencingErrorType._('notAvailable');

  /// The default radius is too large.
  static const defaultRadiusTooLarge = GeofencingErrorType._(
    'defaultRadiusTooLarge',
  );

  /// The maximum number of monitored features has been reached.
  static const monitoredFeaturesLimitReached = GeofencingErrorType._(
    'monitoredFeaturesLimitReached',
  );

  /// The location service is unavailable.
  static const locationServiceUnavailable = GeofencingErrorType._(
    'locationServiceUnavailable',
  );

  /// The user has not authorized location.
  static const locationServiceUnauthorized = GeofencingErrorType._(
    'locationServiceUnauthorized',
  );

  /// The location fix is too inaccurate.
  static const locationServiceInaccurate = GeofencingErrorType._(
    'locationServiceInaccurate',
  );

  /// The device location provider failed.
  static const deviceLocationProviderError = GeofencingErrorType._(
    'deviceLocationProviderError',
  );

  /// The feature is already monitored.
  static const featureAlreadyAdded = GeofencingErrorType._(
    'featureAlreadyAdded',
  );

  /// The feature is not monitored.
  static const featureNotFound = GeofencingErrorType._('featureNotFound');

  /// The feature is invalid.
  static const featureInvalid = GeofencingErrorType._('featureInvalid');

  /// The feature could not be stored.
  static const featureNotStored = GeofencingErrorType._('featureNotStored');

  @override
  String toString() => name;
}

/// An error from the geofencing service.
final class GeofencingError implements Exception {
  /// The error kind.
  final GeofencingErrorType type;

  /// The native error message.
  final String message;

  /// Creates an error reported by the geofencing service.
  const GeofencingError({required this.type, required this.message});

  @override
  String toString() => 'GeofencingError($type, $message)';
}
