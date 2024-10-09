part of mapbox_maps_flutter;

/// Shows a location puck on the map.
class LocationSettings {
  final _LocationComponentSettingsInterface _api;

  LocationSettings._(this._api);

  /// Returns [LocationComponentSettings] allowing to show location indicator on the map,
  /// customize indicator's appearance and position.
  Future<LocationComponentSettings> getSettings() async {
    return _api.getSettings();
  }

  /// Accepts an instance of [LocationComponentSettings] allowing to apply location.
  /// indicator configuration changes.
  ///
  /// Note: By default [DefaultLocationPuck2D] is used if no [LocationComponentSettings.locationPuck] specified.
  Future<void> updateSettings(LocationComponentSettings settings) async {
    if (settings.locationPuck == null) {
      // If locationPuck is not set, fallback to use DefaultLocationPuck2D.
      settings.locationPuck =
          LocationPuck(locationPuck2D: DefaultLocationPuck2D());
    } else {
      settings.locationPuck?.locationPuck3D?.modelUri =
          await MapboxMapsOptions._getFlutterAssetPath(
              settings.locationPuck?.locationPuck3D?.modelUri);
    }
    _api.updateSettings(settings,
        settings.locationPuck?.locationPuck2D is DefaultLocationPuck2D);
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
