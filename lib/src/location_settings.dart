part of mapbox_maps_flutter;

/// Shows a location puck on the map.
class LocationSettings {
  final _LocationComponentSettingsInterface _api;

  // Native location-provider override channel. Plain MethodChannel, not
  // Pigeon-generated: Mapbox doesn't ship the Pigeon input specs for this
  // plugin publicly, only the generated output, so this is a small
  // hand-written channel kept isolated from the generated code to stay easy
  // to rebase. Names must match `LocationController.swift`
  // (`setUpExternalLocationChannel`) and `LocationComponentController.kt`
  // (`setUpExternalLocationChannel`) exactly.
  final MethodChannel _externalLocationChannel;

  LocationSettings._(this._api, {required String messageChannelSuffix, BinaryMessenger? binaryMessenger})
      : _externalLocationChannel = MethodChannel(
          'plugins.flutter.io.mapbox_maps_flutter.externalLocation.$messageChannelSuffix',
          const StandardMethodCodec(),
          binaryMessenger,
        );

  /// Pushes an externally-sourced location into the native location-provider
  /// override, replacing whatever Mapbox's default location provider (GPS)
  /// would otherwise show. Registers the override on first call; the map
  /// behaves exactly as it does today until this is called at least once.
  ///
  /// [timestamp] defaults to now if omitted. [floor] is only meaningful on
  /// iOS (Mapbox's native `Location` type carries it; the Android
  /// `LocationConsumer` API has no floor concept at all, so it's dropped on
  /// that platform — callers needing floor-aware behavior on Android should
  /// track it themselves alongside the location).
  ///
  /// Example:
  /// ```dart
  /// mapboxMap.location.setExternalLocation(
  ///     latitude: 37.775,
  ///     longitude: -122.418,
  ///     heading: 90.0,
  ///     accuracy: 5.0);
  /// ```
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
      if (accuracy != null) 'accuracy': accuracy,
      if (heading != null) 'heading': heading,
      if (headingAccuracy != null) 'headingAccuracy': headingAccuracy,
      if (floor != null) 'floor': floor,
      'timestamp':
          (timestamp ?? DateTime.now()).toUtc().millisecondsSinceEpoch.toDouble(),
    });
  }

  /// Clears the override and restores Mapbox's default location provider
  /// (i.e. back to normal GPS).
  Future<void> clearExternalLocation() {
    return _externalLocationChannel.invokeMethod<void>('clearExternalLocation');
  }

  /// Returns the currently applied settings, populated with default
  /// values for any fields not explicitly modified via [updateSettings].
  Future<LocationComponentSettings> getSettings() async {
    return _api.getSettings();
  }

  /// Partially updates the configuration, modifying only explicitly provided fields in [settings] while preserving the rest.
  ///
  /// Call [getSettings] to retrieve the full resulting configuration.
  ///
  /// Note: If no [LocationComponentSettings.locationPuck] is specified and none has been
  /// configured yet, Mapbox's built-in default puck is shown.
  Future<void> updateSettings(LocationComponentSettings settings) async {
    // Omitting locationPuck leaves the current puck untouched, meaning after
    // update puck is at its previous value or platform default if no puck has
    // been set yet.
    final useDefaultPuck2D = settings.locationPuck == null ||
        settings.locationPuck?.locationPuck2D is DefaultLocationPuck2D;
    settings.locationPuck?.locationPuck3D?.modelUri =
        await MapboxMapsOptions._getFlutterAssetPath(
      settings.locationPuck?.locationPuck3D?.modelUri,
    );
    await _api.updateSettings(settings, useDefaultPuck2D);
  }
}

/// Default 2D location indicator appearance.
class DefaultLocationPuck2D extends LocationPuck2D {
  /// Creates an instance of the default 2D location indicator,
  /// allowing to customize apects of it([topImage], [bearingImage], [opacity] etc.).
  DefaultLocationPuck2D(
      {super.topImage,
      super.bearingImage,
      super.shadowImage,
      super.scaleExpression,
      super.opacity});
}
