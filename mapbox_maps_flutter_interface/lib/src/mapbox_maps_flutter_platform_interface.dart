part of 'package:mapbox_maps_flutter_interface/mapbox_maps_flutter_interface.dart';

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
  ///
  /// The [onPlatformViewCreated] callback is invoked when the platform-specific
  /// view is created. It provides a way to interact with the platform view
  /// after it has been initialized.
  ///
  /// - [onPlatformViewCreated]: A callback function that is triggered when the
  ///   platform view is created. It can be used to perform additional setup
  ///   or configuration.
  Widget buildView({OnPlatformViewCreated? onPlatformViewCreated});
}
