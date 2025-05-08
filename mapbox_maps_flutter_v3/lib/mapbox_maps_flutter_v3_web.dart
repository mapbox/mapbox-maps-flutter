// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'mapbox_maps_flutter_v3_platform_interface.dart';

/// A web implementation of the MapboxMapsFlutterV3Platform of the MapboxMapsFlutterV3 plugin.
class MapboxMapsFlutterV3Web extends MapboxMapsFlutterV3Platform {
  /// Constructs a MapboxMapsFlutterV3Web
  MapboxMapsFlutterV3Web();

  static void registerWith(Registrar registrar) {
    MapboxMapsFlutterV3Platform.instance = MapboxMapsFlutterV3Web();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = web.window.navigator.userAgent;
    return version;
  }
}
