part of mapbox_maps_flutter_web;

class MapboxMapsFlutterPlugin {
  /// Registers this class as the default instance of [MapboxGlPlatform].
  static void registerWith(Registrar registrar) {
    MapboxMapsPlatformInterface.instance = MapboxMapsPlatformWeb();
  }
}
