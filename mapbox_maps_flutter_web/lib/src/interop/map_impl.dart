import 'package:js/js.dart';

@JS('mapboxgl.Map')
@staticInterop
class MapJsImpl {
  external factory MapJsImpl(MapOptionsJsImpl options);
}

extension on MapJsImpl {
  external MapJsImpl setStyle(String url, Object? options);
}

@JS()
@anonymous
@staticInterop
class MapOptionsJsImpl {
  external factory MapOptionsJsImpl({
    Object container,
    String style,
    List<double> center,
    double zoom,
    String accessToken,
  });
}

extension on MapOptionsJsImpl {
  external set container(Object value);
  external set style(String value);
  external set center(List<double> value);
  external set zoom(double value);
}
