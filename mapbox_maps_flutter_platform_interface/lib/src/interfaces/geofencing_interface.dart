import 'package:turf/turf.dart';

import '../public/geofencing.dart';

/// Native geofencing service.
///
/// Failures are thrown as [GeofencingError]s.
abstract interface class GeofencingPlatformInterface {
  /// Sets the maximum number of monitored features.
  Future<void> configure(int maximumMonitoredFeatures);

  /// The maximum number of monitored features.
  Future<int> getOptions();

  /// Adds or replaces [feature]. Returns the feature id.
  Future<String> addFeature(Feature feature);

  /// The monitored feature and, while the user is inside it, when they entered.
  Future<GeofenceState> getFeature(String identifier);

  /// Stops monitoring [identifier].
  Future<void> removeFeature(String identifier);

  /// Removes every monitored feature and returns how many were removed.
  Future<int> clearFeatures();

  /// Whether the user has consented to geofencing.
  Future<bool> get consent;

  /// Whether geofencing is monitoring features.
  Future<bool> get isActive;

  /// Entry events.
  ///
  /// A broadcast stream without errors. The native observer is registered
  /// while any geofencing stream has listeners.
  Stream<GeofencingEvent> get entryEvents;

  /// Dwell events. Behaves like [entryEvents].
  Stream<GeofencingEvent> get dwellEvents;

  /// Exit events. Behaves like [entryEvents].
  Stream<GeofencingEvent> get exitEvents;

  /// Observer errors, as events. Behaves like [entryEvents].
  Stream<GeofencingError> get errors;

  /// Consent changes. Behaves like [entryEvents].
  Stream<bool> get consentChanges;
}
