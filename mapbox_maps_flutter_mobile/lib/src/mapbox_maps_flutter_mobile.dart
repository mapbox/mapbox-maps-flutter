part of '../mapbox_maps_flutter_mobile.dart';

base class MapboxMapsFlutterMobile extends MapboxMapsFlutterPlatform {
  @override
  Widget buildView({
    CameraOptions? cameraOptions,
    OnMapCreated? onMapCreated,
  }) {
    return MapWidget(
      cameraOptions: cameraOptions,
      onMapCreated: (MapboxMap mapboxMap) {
        if (onMapCreated != null) {
          onMapCreated(mapboxMap);
        }
      },
    );
  }

  @override
  Future<String> getAccessToken() {
    return MapboxOptions.getAccessToken();
  }

  @override
  void setAccessToken(String token) {
    MapboxOptions.setAccessToken(token);
  }

  /// Registers the platform implementation.
  static void registerWith() {
    MapboxMapsFlutterPlatform.instance = MapboxMapsFlutterMobile();
  }
}
