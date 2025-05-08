import 'dart:js_interop';
import 'dart:ui_web';

import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:mapbox_maps_flutter_interface/mapbox_maps_flutter_interface.dart';
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
  Widget buildView({OnPlatformViewCreated? onPlatformViewCreated}) {
    final viewType = 'mapbox-maps-flutter-web/$hashCode';

    // Attach the mapDiv to the DOM
    platformViewRegistry.registerViewFactory(viewType, (int id) {
      _mapElement =
          document.createElement("div") as HTMLDivElement
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
      onPlatformViewCreated: (int viewId) {
        if (onPlatformViewCreated != null) {
          onPlatformViewCreated(viewId);
        }
      },
    );
  }

  _initMap() async {
    final link =
        document.createElement('link') as HTMLLinkElement
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
}
