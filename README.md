# Mapbox Maps SDK Flutter SDK

The Mapbox Maps SDK Flutter SDK is an officially developed solution from Mapbox that enables use of our latest Maps SDK product (v11.9.0-beta.1). The SDK allows developers to embed highly-customized maps using a Flutter widget on Android and iOS.

Web and desktop are not supported. 

Contributions welcome!

## Supported API

| Feature | Android            | iOS |
| ------ |--------------------| -- |
| Style | :white_check_mark: | :white_check_mark: |
| Camera position | :white_check_mark: | :white_check_mark: |
| Camera animations | :white_check_mark: | :white_check_mark: |
| Events | :white_check_mark: | :white_check_mark: |
| Gestures | :white_check_mark: | :white_check_mark: |
| User Location | :white_check_mark: | :white_check_mark: |
| Circle Layer | :white_check_mark: | :white_check_mark: |
| Fill Layer | :white_check_mark: | :white_check_mark: |
| Fill extrusion Layer | :white_check_mark: | :white_check_mark: |
| Line Layer | :white_check_mark: | :white_check_mark: |
| Circle Layer | :white_check_mark: | :white_check_mark: |
| Raster Layer  | :white_check_mark: | :white_check_mark: |
| Symbol Layer | :white_check_mark: | :white_check_mark: |
| Hillshade Layer | :white_check_mark: | :white_check_mark: |
| Heatmap Layer   | :white_check_mark: | :white_check_mark: |
| Sky Layer | :white_check_mark: | :white_check_mark: |
| GeoJson Source  | :white_check_mark: | :white_check_mark: |
| Image Source   | :white_check_mark: | :white_check_mark: |
| Vector Source   | :white_check_mark: | :white_check_mark: |
| Raster Source  | :white_check_mark: | :white_check_mark: |
| Rasterdem Source  | :white_check_mark: | :white_check_mark: |
| Circle Annotations | :white_check_mark: | :white_check_mark: |
| Point Annotations | :white_check_mark: | :white_check_mark: |
| Line Annotations | :white_check_mark: | :white_check_mark: |
| Fill Annotations | :white_check_mark: | :white_check_mark: |
| Snapshotter | :white_check_mark: | :white_check_mark: |
| Offline | :white_check_mark: | :white_check_mark: |
| Viewport | :x:                | :x: |
| Style DSL   | :x:                | :x: |
| Expression DSL   | :x:                | :x: |
| View Annotations   | :x:                | :x: |

## Requirements

The Maps Flutter SDK is compatible with applications:

- Deployed on iOS 12 or higher
- Built using the Android SDK 21 or higher
- Built using the Flutter SDK 3.22.3/Dart SDK 3.4.4 or higher

## Installation

### Configure credentials
To run the Maps Flutter SDK you will need to configure the Mapbox Access Token.
Read more about access tokens in the platform [Android](https://docs.mapbox.com/android/maps/guides/install/#configure-credentials) or [iOS](https://docs.mapbox.com/ios/maps/guides/install/#step-4-configure-your-public-token) docs.

#### Access token
You can set the access token for Mapbox Maps Flutter SDK(as well as for every Mapbox SDK) via `MapboxOptions`:
```
  MapboxOptions.setAccessToken(ACCESS_TOKEN);
```

It's a good practice to retrieve the access token from some external source.

You can pass access token via the command line arguments when either building : 

```
flutter build <platform> --dart-define ACCESS_TOKEN=...
```

or running the application : 

```
flutter run --dart-define ACCESS_TOKEN=...
```

You can also persist token in launch.json : 
```
"configurations": [
    {
        ...
        "args": [
            "--dart-define", "ACCESS_TOKEN=..."
        ],
    }
]
```

Then to retrieve the token from the environment in the application :
```
String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");
```

### Add the dependency
To use the Maps Flutter SDK add the git dependency to the pubspec.yaml:

```
dependencies:
  mapbox_maps_flutter: ^2.5.0-beta.1
```

### Configure permissions
You will need to grant location permission in order to use the location component of the Maps Flutter SDK.

You can use an existing library to request location permission, e.g. with [permission_handler](https://pub.dev/packages/permission_handler) `await Permission.locationWhenInUse.request();` will trigger permission request. 

You also need to declare the permission for both platforms : 

#### Android
Add the following permissions to the manifest:
```
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

#### iOS
Add the following key/value pair to the `Runner/Info.plist`. In the value field, explain why you need access to location:

```
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>[Your explanation here]</string>
```

### Add a map
Import `mapbox_maps_flutter` library and add a simple map: 
```
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  runApp(MaterialApp(home: MapWidget()));
}
```

#### MapWidget widget
The `MapWidget` widget provides options to customize the map - you can set `MapOptions`, `CameraOptions`, `styleURL`, etc.

You can also add listeners for various events related to style loading, map rendering, map loading. 

#### MapboxMap controller
The `MapboxMap` controller instance is provided with `MapWidget.onMapCreated` callback.

`MapboxMap` exposes an entry point to the most of the APIs Maps Flutter SDK provides. It allows to control the map, camera, styles, observe map events, 
query rendered features, etc.

It's organized similarly to the [Android](https://docs.mapbox.com/android/maps/api/11.7.0/mapbox-maps-android/com.mapbox.maps/-mapbox-map/) and [iOS](https://docs.mapbox.com/ios/maps/api/11.7.0/documentation/mapboxmaps/mapboxmap) counterparts.

To interact with the map after it's created store the MapboxMap object somewhere : 
```
class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: MapWidget(
      key: ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
    ));
  }
}
```

## User location
To observe the user's location and show the location indicator on the map use `LocationComponentSettingsInterface` accessible via `MapboxMap.location`. 

For more information, please see the User Location guides in our [Flutter](https://docs.mapbox.com/flutter/maps/guides/user-location), [Android](https://docs.mapbox.com/android/maps/guides/user-location/), and [iOS](https://docs.mapbox.com/ios/maps/guides/user-location/) documentation.

You need to grant location permission prior to using location component (as explained [before](#configure-permissions)).

### Location puck
To customize the appearance of the location puck call `MapboxMap.location.updateSettings` method.

To use the 3D puck with model downloaded from Uri instead of the default 2D puck:

```
  mapboxMap.location.updateSettings(LocationComponentSettings(
      locationPuck: LocationPuck(
          locationPuck3D: LocationPuck3D(
              modelUri:
                  "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",))));
```

You can find more examples of customization in the sample [app](example/lib/location.dart).

## Markers and annotations
Additional information is available in our [Flutter](https://docs.mapbox.com/flutter/maps/guides/markers-and-annotations/), [Android](https://docs.mapbox.com/android/maps/guides/annotations/), and [iOS](https://docs.mapbox.com/ios/maps/guides/annotations/) documentation.

You have several options to add annotations on the map.

1. Use the AnnotationManager APIs to create circle, point, polygon, and polyline annotations. 

To create 5 point annotations using custom icon: 
```
  mapboxMap.annotations.createPointAnnotationManager().then((pointAnnotationManager) async {
    final ByteData bytes =
        await rootBundle.load('assets/symbols/custom-icon.png');
    final Uint8List list = bytes.buffer.asUint8List();
    var options = <PointAnnotationOptions>[];
    for (var i = 0; i < 5; i++) {
      options.add(PointAnnotationOptions(
          geometry: createRandomPoint().toJson(), image: list));
    }
    pointAnnotationManager?.createMulti(options);
  });
```
You can find more examples of the AnnotationManagers usage in the sample app : [point annotations](example/lib/point_annotations.dart), [circle annotations](example/lib/circle_annotations.dart), [polygon annotations](example/lib/polygon_annotations.dart), [polyline annotations](example/lib/polyline_annotations.dart). 

1. Use style layers. This will require writing more code but is more flexible and provides better performance for the large amount of annotations (e.g. hundreds and thousands of them). More about adding style layers in the [Map styles section](#map-styles).

## Map styles
Additional information is available in our [Flutter](https://docs.mapbox.com/flutter/maps/guides/styles/), [Android](https://docs.mapbox.com/android/maps/guides/styles/), and [iOS](https://docs.mapbox.com/ios/maps/guides/styles/) documentation.

The Mapbox Maps Flutter SDK allows full customization of the look of the map used in your application. 

### Set a style
You can specify the initial style uri at `MapWidget.styleUri`, or load it at runtime using `MapboxMap.loadStyleURI` / `MapboxMap.loadStyleJson`: 

```
mapboxMap.loadStyleURI(Styles.LIGHT);
```

### Work with layers
You can familiarize with the concept of sources, layers and their supported types in the documentation for [Flutter](https://docs.mapbox.com/flutter/maps/guides/styles/work-with-layers), [iOS](https://docs.mapbox.com/ios/maps/guides/styles/work-with-layers/), and [Android](https://docs.mapbox.com/android/maps/guides/styles/work-with-layers/).

To add, remove or change a source or a layer, use the `MapboxMap.style` object.

To add a `GeoJsonSource` and a `LineLayer` using the source : 
```
  var data = await rootBundle.loadString('assets/polyline.geojson');
  await mapboxMap.style.addSource(GeoJsonSource(id: "line", data: data));
  await mapboxMap.style.addLayer(LineLayer(
      id: "line_layer",
      sourceId: "line",
      lineJoin: LineJoin.ROUND,
      lineCap: LineCap.ROUND,
      lineOpacity: 0.7,
      lineColor: Colors.red.value,
      lineWidth: 8.0));
```

### Using expressions
You can change the appearance of a layer based on properties in the layer's data source or zoom level.
Refer to the [documentation](https://docs.mapbox.com/mapbox-gl-js/style-spec/expressions/) for the description of supported expressions. You can also learn more in the documentation for [Flutter](https://docs.mapbox.com/flutter/maps/guides/styles/style-layers#work-with-expressions), [iOS](https://docs.mapbox.com/ios/maps/guides/styles/style-layers/#work-with-expressions), and [Android](https://docs.mapbox.com/android/maps/guides/styles/style-layers/#work-with-expressions). 

To apply an expression to interpolate gradient color to a line layer:
```
  mapboxMap.style.setStyleLayerProperty("layer", "line-gradient",
      '["interpolate",["linear"],["line-progress"],0.0,["rgb",6,1,255],0.5,["rgb",0,255,42],0.7,["rgb",255,252,0],1.0,["rgb",255,30,0]]');
```

## Camera and animations
Platform docs: [Android](https://docs.mapbox.com/android/maps/guides/camera-and-animation/), [iOS](https://docs.mapbox.com/ios/maps/guides/camera-and-animation/). 

The camera is the user's viewpoint above the map. The Maps Flutter SDK provides you with options to set and adjust the camera position, listen for camera changes, get the camera position, and restrict the camera position to set bounds.

### Camera position
You can set the starting camera position using `MapWidget.cameraOptions`:

```
MapWidget(
  key: ValueKey("mapWidget"),
  cameraOptions: CameraOptions(
      center: Point(coordinates: Position(-80.1263, 25.7845)).toJson(),
      zoom: 12.0),
));
```

or update it at runtime using `MapboxMap.setCamera` : 

```
MapboxMap.setCamera(CameraOptions(
  center: Point(coordinates: Position(-80.1263, 25.7845)).toJson(),
  zoom: 12.0));
```

You can find more examples of interaction with the camera in the sample [app](example/lib/camera.dart).

### Camera animations
Camera animations are the means by which camera settings are changed from old values to new values over a period of time. You can animate the camera using `flyTo` or `easeTo` and move to a new center location, update the bearing, pitch, zoom, padding, and anchor. 

To start a `flyTo` animation to the specific camera options :
```
  mapboxMap?.flyTo(
    CameraOptions(
        anchor: ScreenCoordinate(x: 0, y: 0),
        zoom: 17,
        bearing: 180,
        pitch: 30),
    MapAnimationOptions(duration: 2000, startDelay: 0));
```
You can find more examples of animations in the sample [app](example/lib/animation.dart).

## User interaction
Platform docs: [Android](https://docs.mapbox.com/android/maps/guides/user-interaction/), [iOS](https://docs.mapbox.com/ios/maps/guides/user-interaction/).

Users interacting with the map in your application can explore the map by performing standard gestures. 

You can retrieve or update the `GestureSettings` using `MapboxMap.gestures`.

You can observe gesture events using `MapWidget.onTapListener`, `MapWidget.onLongTapListener`, `MapWidget.onScrollListener`.


