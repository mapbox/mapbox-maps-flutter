part of 'package:mapbox_maps_flutter_v3/mapbox_maps_flutter_v3.dart';

/// A class that provides options and configurations for Mapbox services.
///
/// This class includes methods to get and set the public access token, which is
/// required to access Mapbox resources. The access token can be retrieved or
/// updated using the static methods provided.
final class MapboxOptions {
  /// The public access token that is used to access resources provided by Mapbox services.
  /// For more information about public access tokens, see
  /// [Mapbox Access Tokens](https://docs.mapbox.com/help/getting-started/access-tokens/#public-tokens).
  static Future<String> get accessToken async {
    return MapboxMapsFlutterPlatform.instance.getAccessToken();
  }

  /// The public access token that is used to access resources provided by Mapbox services.
  /// For more information about public access tokens, see
  /// [Mapbox Access Tokens](https://docs.mapbox.com/help/getting-started/access-tokens/#public-tokens).
  static setAccessToken(String token) {
    MapboxMapsFlutterPlatform.instance.setAccessToken(token);
  }
}
