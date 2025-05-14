import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter_interface/mapbox_maps_flutter_interface.dart';

class MapWidget extends StatelessWidget {
  final MapboxMapsFlutterPlatform _platform;

  /// The initial Camera options when creating a MapWidget.
  final CameraOptions? cameraOptions;

  MapWidget({
    super.key,
    this.cameraOptions,
  }) : _platform = MapboxMapsFlutterPlatform.instance;

  @override
  Widget build(BuildContext context) {
    return _platform.buildView(cameraOptions: cameraOptions);
  }
}
