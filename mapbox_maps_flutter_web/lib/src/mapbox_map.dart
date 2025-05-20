import 'package:mapbox_maps_flutter_interface/mapbox_maps_flutter_interface.dart';
import 'package:mapbox_maps_flutter_web/src/bindings.dart' as gl_js;
import 'package:mapbox_maps_flutter_web/src/conversion.dart';

final class MapboxMap extends MapboxMapInterface {
  final gl_js.Map nativeMap;

  MapboxMap(this.nativeMap);

  @override
  Future<CameraState> getCameraState() {
    final camera = CameraState(
      center: nativeMap.getCenter().toPoint(),
      padding: nativeMap.getPadding().toMbxEdgeInsets(),
      zoom: nativeMap.getZoom(),
      bearing: nativeMap.getBearing(),
      pitch: nativeMap.getPitch(),
    );
    return Future.value(camera);
  }

  @override
  Future<void> setCamera(CameraOptions cameraOptions) {
    final options = gl_js.CameraOptions();
    if (cameraOptions.center != null) {
      options.center = cameraOptions.center!.toLngLat();
    }
    if (cameraOptions.padding != null) {
      options.padding = cameraOptions.padding!.toPaddingOptions();
    }
    if (cameraOptions.zoom != null) {
      options.zoom = cameraOptions.zoom;
    }
    if (cameraOptions.bearing != null) {
      options.bearing = cameraOptions.bearing;
    }
    if (cameraOptions.pitch != null) {
      options.pitch = cameraOptions.pitch;
    }
    nativeMap.jumpTo(options);
    return Future.value();
  }
}
