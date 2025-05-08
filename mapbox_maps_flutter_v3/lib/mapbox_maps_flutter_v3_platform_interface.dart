import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mapbox_maps_flutter_v3_method_channel.dart';

abstract class MapboxMapsFlutterV3Platform extends PlatformInterface {
  /// Constructs a MapboxMapsFlutterV3Platform.
  MapboxMapsFlutterV3Platform() : super(token: _token);

  static final Object _token = Object();

  static MapboxMapsFlutterV3Platform _instance = MethodChannelMapboxMapsFlutterV3();

  /// The default instance of [MapboxMapsFlutterV3Platform] to use.
  ///
  /// Defaults to [MethodChannelMapboxMapsFlutterV3].
  static MapboxMapsFlutterV3Platform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MapboxMapsFlutterV3Platform] when
  /// they register themselves.
  static set instance(MapboxMapsFlutterV3Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
