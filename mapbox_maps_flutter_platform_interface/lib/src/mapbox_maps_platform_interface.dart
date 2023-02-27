part of mapbox_maps_flutter_platform_interface;

typedef OnPlatformViewCreatedCallback = void Function(int);

abstract class MapboxMapsPlatformInterface extends PlatformInterface {
  MapboxMapsPlatformInterface() : super(token: _token);

  static MapboxMapsPlatformInterface _instance = MapboxMapsPlatform();

  static final Object _token = Object();

  static MapboxMapsPlatformInterface get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [MapboxMapsPlatformInterface] when they register themselves.
  static set instance(MapboxMapsPlatformInterface instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  //

  void initPlatform(String channelSuffix);

  Widget buildView(
      Map<String, dynamic> creationParams,
      OnPlatformViewCreatedCallback onPlatformViewCreated,
      Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers);

  void dispose();

  // TODO add rest of platform methods
}
