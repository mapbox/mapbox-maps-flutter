import 'package:flutter/widgets.dart';

import '../mapbox_maps_flutter_interface.dart';

abstract base class MapboxMapsFlutterPlatform {
  static MapboxMapsFlutterPlatform? _instance;

  /// The default instance of [MapboxMapsFlutterPlatform] to use.
  ///
  /// This is the default instance that will be used by the [MapboxMapsFlutterPlatform] class.
  static MapboxMapsFlutterPlatform get instance {
    if (_instance == null) {
      throw Exception(
        'No default instance of MapboxMapsFlutterPlatform has been set. '
        'Ensure that you have called MapboxMapsFlutterPlatform.setInstance() '
        'before using the MapboxMapsFlutterPlatform instance.',
      );
    }
    return _instance!;
  }

  static set instance(MapboxMapsFlutterPlatform instance) {
    _instance = instance;
  }

  /// Constructs a MapboxMapsFlutterPlatform.
  MapboxMapsFlutterPlatform();

  /// The public access token that is used to access resources provided by Mapbox services.
  /// For more information about public access tokens, see
  /// [Mapbox Access Tokens](https://docs.mapbox.com/help/getting-started/access-tokens/#public-tokens).
  Future<String> getAccessToken();

  /// The public access token that is used to access resources provided by Mapbox services.
  /// For more information about public access tokens, see
  /// [Mapbox Access Tokens](https://docs.mapbox.com/help/getting-started/access-tokens/#public-tokens).
  void setAccessToken(String token);

  /// Builds a platform-specific view for displaying the map.
  ///
  /// This method is responsible for creating the widget that integrates
  /// with the underlying platform's view system to render the map.
  Widget buildView({
    CameraOptions? cameraOptions,
    OnMapCreated? onMapCreated,
  });
}
