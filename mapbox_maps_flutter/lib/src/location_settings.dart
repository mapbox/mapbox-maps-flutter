import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

/// Shows a location puck on the map.
class LocationSettingsManager {
  final LocationSettingsPlatformInterface _impl;

  @internal
  LocationSettingsManager(this._impl);

  /// Returns [LocationComponentSettings] allowing to show location indicator on the map,
  /// customize indicator's appearance and position.
  Future<LocationComponentSettings> getSettings() => _impl.getSettings();

  /// Accepts an instance of [LocationComponentSettings] allowing to apply
  /// location indicator configuration changes. Fields and the platforms
  /// each applies to:
  ///
  /// ```dart
  /// LocationComponentSettings(
  ///   enabled: true,                       // Android, iOS, web
  ///   pulsingEnabled: true,                // Android, iOS  (web: always on)
  ///   pulsingColor: 0xFFFF0000,            // Android, iOS
  ///   pulsingMaxRadius: 20.0,              // Android, iOS
  ///   showAccuracyRing: true,              // Android, iOS, web
  ///   accuracyRingColor: 0xFF00FF00,       // Android, iOS
  ///   accuracyRingBorderColor: 0xFF000000, // Android, iOS
  ///   layerAbove: 'some-layer',            // Android
  ///   layerBelow: 'some-layer',            // Android
  ///   puckBearingEnabled: true,            // Android, iOS, web
  ///   puckBearing: PuckBearing.HEADING,    // Android, iOS  (web: always HEADING)
  ///   slot: 'top',                         // Android, iOS
  ///   locationPuck: LocationPuck(...),     // Android, iOS
  /// )
  /// ```
  Future<void> updateSettings(LocationComponentSettings settings) =>
      _impl.updateSettings(settings);

  /// Pushes an externally-sourced location into the native location-provider
  /// override, replacing whatever the platform's default location provider
  /// (GPS) would otherwise show. Useful when the location comes from
  /// something other than the device's GNSS receiver — an indoor-positioning
  /// SDK, a simulation, or a vehicle's own sensors.
  ///
  /// The override is registered lazily on the first call; until this is
  /// called at least once the puck behaves exactly as it does today.
  ///
  /// [timestamp] defaults to now if omitted. [floor] is only meaningful on
  /// iOS, whose native `Location` type carries it; Android's
  /// `LocationConsumer` API has no floor concept at all, so it is dropped on
  /// that platform — callers needing floor-aware behaviour on Android should
  /// track it themselves alongside the location.
  ///
  /// Supported on Android and iOS. Throws [UnsupportedError] on web.
  ///
  /// Example:
  /// ```dart
  /// mapboxMap.location.setExternalLocation(
  ///   latitude: 37.775,
  ///   longitude: -122.418,
  ///   heading: 90.0,
  ///   accuracy: 5.0,
  /// );
  /// ```
  Future<void> setExternalLocation({
    required double latitude,
    required double longitude,
    double? accuracy,
    double? heading,
    double? headingAccuracy,
    int? floor,
    DateTime? timestamp,
  }) => _impl.setExternalLocation(
    latitude: latitude,
    longitude: longitude,
    accuracy: accuracy,
    heading: heading,
    headingAccuracy: headingAccuracy,
    floor: floor,
    timestamp: timestamp,
  );

  /// Clears the override set by [setExternalLocation] and restores the
  /// platform's default location provider (i.e. back to normal GPS).
  ///
  /// Supported on Android and iOS. Throws [UnsupportedError] on web.
  Future<void> clearExternalLocation() => _impl.clearExternalLocation();
}

/// Deprecated: Use [LocationSettingsManager] instead.
@Deprecated('Use LocationSettingsManager instead.')
typedef LocationSettings = LocationSettingsManager;
