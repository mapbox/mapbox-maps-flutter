part of 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

base class MapboxMapsFlutterMobile extends MapboxMapsFlutterPlatform {
  @override
  Widget buildView({
    CameraOptions? cameraOptions,
    OnMapCreated? onMapCreated,
  }) {
    if (cameraOptions?.center != null) {
      cameraOptions?.center = Point._from(cameraOptions.center!);
    }
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
