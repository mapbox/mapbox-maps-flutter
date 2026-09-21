part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

/// Shows a location puck on the map.
class LocationSettings implements LocationSettingsPlatformInterface {
  final _LocationComponentSettingsInterface _api;

  // Native location-provider override channel. A plain MethodChannel rather
  // than Pigeon-generated: this repo ships the generated Pigeon output but
  // not the input specs, so the channel is hand-written and kept isolated
  // from the generated code. Names must match `LocationController.swift`
  // and `LocationComponentController.kt` (`setUpExternalLocationChannel`)
  // exactly.
  final MethodChannel _externalLocationChannel;

  LocationSettings._(
    this._api, {
    required String messageChannelSuffix,
    BinaryMessenger? binaryMessenger,
  }) : _externalLocationChannel = MethodChannel(
         'plugins.flutter.io.mapbox_maps_flutter.externalLocation.$messageChannelSuffix',
         const StandardMethodCodec(),
         binaryMessenger,
       );

  @override
  Future<void> setExternalLocation({
    required double latitude,
    required double longitude,
    double? accuracy,
    double? heading,
    double? headingAccuracy,
    int? floor,
    DateTime? timestamp,
  }) {
    return _externalLocationChannel.invokeMethod<void>('setExternalLocation', {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': ?accuracy,
      'heading': ?heading,
      'headingAccuracy': ?headingAccuracy,
      'floor': ?floor,
      'timestamp': (timestamp ?? DateTime.now())
          .toUtc()
          .millisecondsSinceEpoch
          .toDouble(),
    });
  }

  @override
  Future<void> clearExternalLocation() {
    return _externalLocationChannel.invokeMethod<void>('clearExternalLocation');
  }

  /// Returns the currently applied settings, populated with default
  /// values for any fields not explicitly modified via [updateSettings].
  @override
  Future<LocationComponentSettings> getSettings() async {
    return _api.getSettings();
  }

  /// Partially updates the configuration, modifying only explicitly provided fields in [settings] while preserving the rest.
  ///
  /// Call [getSettings] to retrieve the full resulting configuration.
  ///
  /// Note: If no [LocationComponentSettings.locationPuck] is specified and none has been
  /// configured yet, Mapbox's built-in default puck is shown.
  @override
  Future<void> updateSettings(LocationComponentSettings settings) async {
    // Omitting locationPuck leaves the current puck untouched, meaning after
    // update puck is at its previous value or platform default if no puck has
    // been set yet.
    final useDefaultPuck2D =
        settings.locationPuck == null ||
        settings.locationPuck?.locationPuck2D is DefaultLocationPuck2D;
    settings.locationPuck?.locationPuck3D?.modelUri =
        await MapboxMapsOptions.getFlutterAssetPath(
          settings.locationPuck?.locationPuck3D?.modelUri,
        );
    await _api.updateSettings(settings, useDefaultPuck2D);
  }
}

// `DefaultLocationPuck2D` was lifted to
// `packages/mapbox_maps_flutter_platform_interface/lib/src/default_location_puck_2d.dart`
// in WS4f when `location_example` needed it from the facade. Mobile's
// `is DefaultLocationPuck2D` check above continues to work via the
// platform-interface re-export already imported by mobile's barrel.
