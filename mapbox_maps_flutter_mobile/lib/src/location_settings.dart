part of mapbox_maps_flutter_mobile;

/// Shows a location puck on the map.
class LocationSettings implements LocationSettingsPlatformInterface {
  final _LocationComponentSettingsInterface _api;

  LocationSettings._(this._api);

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
    final useDefaultPuck2D = settings.locationPuck == null ||
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
