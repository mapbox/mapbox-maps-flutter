part of 'package:mapbox_maps_flutter_v3/mapbox_maps_flutter_v3.dart';

class MapWidget extends StatelessWidget {
  final MapboxMapsFlutterPlatform _platform;

  MapWidget({super.key}) : _platform = MapboxMapsFlutterPlatform.instance;

  @override
  Widget build(BuildContext context) {
    return _platform.buildView();
  }
}
