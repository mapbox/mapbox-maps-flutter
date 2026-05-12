import 'dart:js_interop';
import 'dart:ui_web';

import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/src/bindings.dart';
import 'package:web/web.dart';

const mapboxGlCss = 'https://api.mapbox.com/mapbox-gl-js/v3.11.1/mapbox-gl.css';

base class MapboxMapsFlutterWeb extends MapboxMapsFlutterPlatform {
  /// Registers the platform implementation.
  static void registerWith(Registrar registrar) {
    MapboxMapsFlutterPlatform.instance = MapboxMapsFlutterWeb();
  }

  late HTMLDivElement _mapElement;

  @override
  Widget buildView({MapCreatedCallback? onMapCreated}) {
    final viewType = 'mapbox-maps-flutter-web/$hashCode';

    // Attach the mapDiv to the DOM
    platformViewRegistry.registerViewFactory(viewType, (int id) {
      _mapElement = document.createElement("div") as HTMLDivElement
        ..style.position = 'absolute'
        ..style.top = '0'
        ..style.bottom = '0'
        ..style.height = '100%'
        ..style.width = '100%';

      _initMap();
      return _mapElement;
    });
    return HtmlElementView(
      viewType: viewType,
      // TODO(MAPSFLT-XXX): Call onMapCreated once a web MapboxMapInterface
      // implementation exists and the JS map is initialised.
      onPlatformViewCreated: (int viewId) {},
    );
  }

  Future<void> _initMap() async {
    final link = document.createElement('link') as HTMLLinkElement
      ..rel = 'stylesheet'
      ..href = mapboxGlCss
      ..type = 'text/css';
    _mapElement.append(link);

    await link.onLoad.first;

    final options = MapOptions(container: _mapElement);
    final nativeMap = Map(options);

    nativeMap.on('load', (() {}).toJS);
  }

  @override
  Future<String> getAccessToken() {
    return Future.value(accessToken);
  }

  @override
  void setAccessToken(String token) {
    accessToken = token;
  }

  @override
  Future<String> getBaseUrl() => throw UnimplementedError('getBaseUrl() is not implemented on web.');

  @override
  void setBaseUrl(String url) => throw UnimplementedError('setBaseUrl() is not implemented on web.');

  @override
  Future<String> getDataPath() => throw UnimplementedError('getDataPath() is not implemented on web.');

  @override
  void setDataPath(String path) => throw UnimplementedError('setDataPath() is not implemented on web.');

  @override
  Future<String> getAssetPath() => throw UnimplementedError('getAssetPath() is not implemented on web.');

  @override
  void setAssetPath(String path) => throw UnimplementedError('setAssetPath() is not implemented on web.');

  @override
  Future<TileStoreUsageMode> getTileStoreUsageMode() => throw UnimplementedError('getTileStoreUsageMode() is not implemented on web.');

  @override
  void setTileStoreUsageMode(TileStoreUsageMode mode) => throw UnimplementedError('setTileStoreUsageMode() is not implemented on web.');

  @override
  Future<String?> getWorldview() => throw UnimplementedError('getWorldview() is not implemented on web.');

  @override
  void setWorldview(String? worldview) => throw UnimplementedError('setWorldview() is not implemented on web.');

  @override
  Future<String?> getLanguage() => throw UnimplementedError('getLanguage() is not implemented on web.');

  @override
  void setLanguage(String? language) => throw UnimplementedError('setLanguage() is not implemented on web.');

  @override
  Future<void> clearData() => throw UnimplementedError('clearData() is not implemented on web.');
}
