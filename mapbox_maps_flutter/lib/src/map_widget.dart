import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// A widget that displays a Mapbox map using the Mapbox Maps Flutter SDK.
///
/// You use this class to display map information and to manipulate the map contents from your application.
/// You can center the map on a given coordinate, specify the size of the area you want to display,
/// and style the features of the map to fit your application's use case.
///
/// Use of MapWidget requires a Mapbox API access token.
/// Obtain an access token on the [Mapbox account page](https://www.mapbox.com/studio/account/tokens/).
///
/// <strong>Warning:</strong> Please note that you are responsible for getting permission to use the map data,
/// and for ensuring your use adheres to the relevant terms of use.
/// ```
class MapWidget extends StatelessWidget {
  final MapboxMapsFlutterPlatform _platform;

  MapWidget({super.key}) : _platform = MapboxMapsFlutterPlatform.instance;

  @override
  Widget build(BuildContext context) {
    return _platform.buildView();
  }
}
