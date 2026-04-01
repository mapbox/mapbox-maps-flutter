import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import 'mapbox_map.dart';
import 'mapbox_styles.dart';

typedef MapCreatedCallback = MapboxMapCreatedCallback<MapboxMap>;

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
class MapWidget extends StatelessWidget {
  final MapboxMapsFlutterPlatform _platform;

  /// The styleUri will applied for the MapWidget in the onStart lifecycle event if no style is set. Default is [MapboxStyles.STANDARD].
  final String styleUri;

  /// Called when the map is created and ready for interaction.
  final MapCreatedCallback? onMapCreated;

  MapWidget({
    super.key,
    this.styleUri = MapboxStyles.STANDARD,
    this.onMapCreated,
  }) : _platform = MapboxMapsFlutterPlatform.instance;

  @override
  Widget build(BuildContext context) {
    return _platform.buildView(
      styleUri: styleUri,
      onMapCreated: onMapCreated != null
          ? (map) => onMapCreated!(MapboxMap(map))
          : null,
    );
  }
}
