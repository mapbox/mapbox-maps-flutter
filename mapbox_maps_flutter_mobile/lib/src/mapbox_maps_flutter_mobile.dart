part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

base class MapboxMapsFlutterMobile extends MapboxMapsFlutterPlatform {
  @override
  Widget buildView() {
    return MapWidget();
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
