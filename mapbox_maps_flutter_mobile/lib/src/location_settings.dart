part of mapbox_maps_flutter_mobile;

/// Shows a location puck on the map.
class LocationSettings implements LocationSettingsPlatformInterface {
  final _LocationComponentSettingsInterface _api;

  LocationSettings._(this._api);

  /// Returns [LocationComponentSettings] allowing to show location indicator on the map,
  /// customize indicator's appearance and position.
  @override
  Future<LocationComponentSettings> getSettings() async {
    return _api.getSettings();
  }

  /// Accepts an instance of [LocationComponentSettings] allowing to apply location.
  /// indicator configuration changes.
  ///
  /// Note: By default [DefaultLocationPuck2D] is used if no [LocationComponentSettings.locationPuck] specified.
  @override
  Future<void> updateSettings(LocationComponentSettings settings) async {
    if (settings.locationPuck == null) {
      // If locationPuck is not set, fallback to use DefaultLocationPuck2D.
      settings.locationPuck = LocationPuck(
        locationPuck2D: DefaultLocationPuck2D(),
      );
    } else {
      settings.locationPuck?.locationPuck3D?.modelUri =
          await MapboxMapsOptions.getFlutterAssetPath(
            settings.locationPuck?.locationPuck3D?.modelUri,
          );
    }
    _api.updateSettings(
      settings,
      settings.locationPuck?.locationPuck2D is DefaultLocationPuck2D,
    );
  }
}

// `DefaultLocationPuck2D` was lifted to
// `packages/mapbox_maps_flutter_platform_interface/lib/src/default_location_puck_2d.dart`
// in WS4f when `location_example` needed it from the facade. Mobile's
// `is DefaultLocationPuck2D` check above continues to work via the
// platform-interface re-export already imported by mobile's barrel.
