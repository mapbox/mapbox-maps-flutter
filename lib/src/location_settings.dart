part of mapbox_maps_flutter;

/// Shows a location puck on the map.
class LocationSettings {
  final _LocationComponentSettingsInterface _api;

  LocationSettings._(this._api);

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
