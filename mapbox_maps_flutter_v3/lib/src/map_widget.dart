part of 'package:mapbox_maps_flutter_v3/mapbox_maps_flutter_v3.dart';

class MapWidget extends StatelessWidget {
  final MapboxMapsFlutterPlatform _platform;

  MapWidget({
    super.key,
    this.cameraOptions,
  }) : _platform = MapboxMapsFlutterPlatform.instance;

  /// The initial Camera options when creating a MapWidget.
  final CameraOptions? cameraOptions;

  @override
  Widget build(BuildContext context) {
    return _platform.buildView(cameraOptions: cameraOptions);
  }
}
