@JS('mapboxgl')
library;

import 'dart:js_interop';

import 'package:web/web.dart';

@JS()
external String accessToken;

@JS()
@anonymous
extension type MapOptions._(JSObject _) implements JSObject {
  external factory MapOptions({required HTMLDivElement container});
}

extension type Map._(JSObject _) implements JSObject {
  external Map(MapOptions container);
  external void on(String event, JSFunction callback);
}
