import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter_interface/mapbox_maps_flutter_interface.dart';

typedef MapboxMap = MapboxMapInterface;

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
///
/// ### Example:
/// ```dart
/// MapWidget(
///   cameraOptions: CameraOptions(
///     center: LatLng(37.7749, -122.4194),
///     zoom: 12.0,
///   ),
///   onMapCreated: (controller) {
///     // Handle map creation logic here.
///   },
/// )
/// ```
class MapWidget extends StatelessWidget {
  final MapboxMapsFlutterPlatform _platform;

  /// The initial Camera options when creating a MapWidget.
  final CameraOptions? cameraOptions;

  /// Callback that is triggered when the map has been successfully created.
  ///
  /// This provides an opportunity to perform additional setup or configuration
  /// once the map is ready. The [OnMapCreated] callback can be used to access
  /// the [MapboxMap] instance and interact with it.
  final OnMapCreated? onMapCreated;

  MapWidget({
    super.key,
    this.cameraOptions,
    this.onMapCreated,
  }) : _platform = MapboxMapsFlutterPlatform.instance;

  @override
  Widget build(BuildContext context) {
    return _platform.buildView(
      cameraOptions: cameraOptions,
      onMapCreated: onMapCreated,
    );
  }
}
