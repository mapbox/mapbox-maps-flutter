part of mapbox_maps_flutter;

class LocationSettings {
  final _LocationComponentSettingsInterface _api;

  LocationSettings(this._api);

  Future<LocationComponentSettings> getSettings() async {
    return _api.getSettings();
  }

  Future<void> updateSettings(LocationComponentSettings settings) async {
    if (settings.locationPuck == null) {
      // If locationPuck is not set, fallback to use DefaultLocationPuck2D.
      settings.locationPuck = LocationPuck(locationPuck2D: DefaultLocationPuck2D());
    }
    _api.updateSettings(settings, settings.locationPuck?.locationPuck2D is DefaultLocationPuck2D);
  }
}

class DefaultLocationPuck2D extends LocationPuck2D {
  DefaultLocationPuck2D({super.topImage, super.bearingImage, super.shadowImage, super.scaleExpression, super.opacity});
}