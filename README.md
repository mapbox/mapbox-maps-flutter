# Mapbox Maps SDK Flutter Plugin

The Mapbox Maps SDK Flutter Plugin is an officially developed solution from Mapbox that enables use of our latest Maps SDK product (v10.13.0). It is currently in beta, but can be used in production. The plugin allows developers to embed highly customized maps using a Flutter widget on Android and iOS. 

Web and desktop are not supported. 

Contributions welcome!

## Supported API

| Feature | Android | iOS |
| ------ | ------ | ----- |
| Style | :white_check_mark:   | :white_check_mark: |
| Camera position | :white_check_mark:   | :white_check_mark: |
| Camera animations | :white_check_mark:   | :white_check_mark: |
| Events | :white_check_mark:   | :white_check_mark: |
| Gestures | :white_check_mark:   | :white_check_mark: |
| User Location | :white_check_mark: | :white_check_mark: |
| Circle Layer | :white_check_mark:   | :white_check_mark: |
| Fill Layer | :white_check_mark:   | :white_check_mark: |
| Fill extrusion Layer | :white_check_mark:   | :white_check_mark: |
| Line Layer | :white_check_mark:   | :white_check_mark: |
| Circle Layer | :white_check_mark:   | :white_check_mark: |
| Raster Layer  | :white_check_mark:  | :white_check_mark:  |
| Symbol Layer | :white_check_mark:   | :white_check_mark: |
| Hillshade Layer | :white_check_mark:   | :white_check_mark: |
| Heatmap Layer   | :white_check_mark:  | :white_check_mark:  |
| Sky Layer | :white_check_mark:   | :white_check_mark: |
| GeoJson Source  | :white_check_mark:   | :white_check_mark: |
| Image Source   | :white_check_mark:   | :white_check_mark: |
| Vector Source   |  :white_check_mark:  | :white_check_mark:  |
| Raster Source  |  :white_check_mark:  | :white_check_mark:  |
| Rasterdem Source  |  :white_check_mark:  | :white_check_mark:  |
| Circle Annotations | :white_check_mark:   | :white_check_mark: |
| Point Annotations | :white_check_mark:   | :white_check_mark: |
| Line Annotations | :white_check_mark:   | :white_check_mark: |
| Fill Annotations | :white_check_mark:   | :white_check_mark: |
| Offline | :x: | :x: |
| Viewport | :x: | :x: |
| Style DSL   | :x:  | :x:  |
| Expression DSL   | :x:  | :x:  |
| View Annotations   | :x:  | :x:  |

## Requirements

The Maps Flutter Plugin is compatible with applications:

- Deployed on iOS 11 or higher
- Built using the Android SDK 21 or higher
- Built using the Dart SDK 2.17.1 or higher

## Installation

### Configure credentials
To run the Maps Flutter Plugin you will need to configure the Mapbox Access Tokens. 
Read more about access tokens and public/secret scopes at the platform [Android](https://docs.mapbox.com/android/maps/guides/install/#configure-credentials) or [iOS](https://docs.mapbox.com/ios/maps/guides/install/#configure-credentials) docs.

#### Secret token
To access platform SDKs you will need to create a secret access token with the `Downloads:Read` scope and then:
 - to download the Android SDK add the token configuration to `~/.gradle/gradle.properties` : 
```
  SDK_REGISTRY_TOKEN=YOUR_SECRET_MAPBOX_ACCESS_TOKEN
```
 - to download the iOS SDK add the token configuration to `~/.netrc` :
```
  machine api.mapbox.com
  login mapbox
  password YOUR_SECRET_MAPBOX_ACCESS_TOKEN
```

#### Public token
To instantiate the `MapWidget` widget pass the public access token with `ResourceOptions`:
```
  MapWidget(
    resourceOptions:
        ResourceOptions(accessToken: PUBLIC_ACCESS_TOKEN))));
```

It's a good practice to retrieve access tokens from some external source.

You can pass access token via the command line arguments when either building : 

```
flutter build <platform> --dart-define PUBLIC_ACCESS_TOKEN=...
```

or running the application : 

```
flutter run --dart-define PUBLIC_ACCESS_TOKEN=...
```

You can also persist token in launch.json : 
```
"configurations": [
    {
        ...
        "args": [
            "--dart-define", "PUBLIC_ACCESS_TOKEN=..."
        ],
    }
]
```

Then to retrieve the token from the environment in the application :
```
String ACCESS_TOKEN = String.fromEnvironment("PUBLIC_ACCESS_TOKEN");
```

### Add the dependency
To use the Maps Flutter Plugin add the git dependency to the pubspec.yaml:

```
dependencies:
  mapbox_maps_flutter: ^0.4.4
```

### Configure permissions
You will need to grant location permission in order to use the location component of the Maps Flutter Plugin.

You can use an existing library to request location permission, e.g. with [permission_handler](https://pub.dev/packages/permission_handler) `await Permission.locationWhenInUse.request();` will trigger permission request. 

You also need to declare the permission for both platforms : 

#### Android
Add the following permissions to the manifest:
```
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

#### iOS
Add the following to the `Runner/Info.plist` to explain why you need access to the location data:

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
  runApp(MaterialApp(
      home: MapWidget(
          resourceOptions: ResourceOptions(accessToken: YOUR_ACCESS_TOKEN))));
}
```

#### MapWidget widget
The `MapWidget` widget provides options to customize the map - you can set `ResourceOptions`, `MapOptions`, `CameraOptions`, `styleURL`.

It also allows or add listeners for various events - related to style loading, map rendering, map loading. 

#### MapboxMap controller
The `MapboxMap` controller instance is provided with `MapWidget.onMapCreated` callback.

`MapboxMap` exposes an entry point to the most of the APIs Maps Flutter Plugin provides. It allows to control the map, camera, styles, observe map events, 
query rendered features, etc.

It's organized similarly to the [Android](https://docs.mapbox.com/android/maps/api/10.8.0/mapbox-maps-android/com.mapbox.maps/-mapbox-map/) and [iOS](https://docs.mapbox.com/ios/maps/api/10.8.1/Classes/MapboxMap.html) counterparts.

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
      resourceOptions: ResourceOptions(accessToken: ACCESS_TOKEN),
      onMapCreated: _onMapCreated,
    ));
  }
}
```

## User location
Platform docs : [Android](https://docs.mapbox.com/android/maps/guides/user-location/), [iOS](https://docs.mapbox.com/ios/maps/guides/user-location/).

To observe the user's location and show the location indicator on the map use `LocationComponentSettingsInterface` accessible via `MapboxMap.location`.

You need to grant location permission prior to using location component (as explained [before](#configure-permissions)).

### Location puck
To customize the appearance of the location puck call `MapboxMap.location.updateSettings` method.

To use the 3D puck with model downloaded from Uri instead of the default 2D puck :

```
  mapboxMap.location.updateSettings(LocationComponentSettings(
      locationPuck: LocationPuck(
          locationPuck3D: LocationPuck3D(
              modelUri:
                  "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",))));
```

You can find more examples of customization in the sample [app](example/lib/location.dart).

## Markers and annotations
Platform docs : [Android](https://docs.mapbox.com/android/maps/guides/annotations/), [iOS](https://docs.mapbox.com/ios/maps/guides/annotations/).

You have several options to add annotations on the map.

1. Use the AnnotationManager APIs to create circle/point/polygon/polyline annotations. 

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
Platform docs : [Android](https://docs.mapbox.com/android/maps/guides/styles/), [iOS](https://docs.mapbox.com/ios/maps/guides/styles/).

The Mapbox Maps Flutter Plugin allows full customization of the look of the map used in your application. 

### Set a style
You can specify the initial style uri at `MapWidget.styleUri`, or load it at runtime using `MapboxMap.loadStyleURI` / `MapboxMap.loadStyleJson` : 

```
  mapboxMap.loadStyleURI(Styles.LIGHT);
```

### Work with layers
You can familiarize with the concept of sources, layers and their supported types in the platform documentation.

To add, remove or change a source or a layer use the `MapboxMap.style` object. 

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
Refer to the [documentation](https://docs.mapbox.com/mapbox-gl-js/style-spec/expressions/) for the description of supported expressions.
To apply an expression to interpolate gradient color to a line layer:
```
  mapboxMap.style.setStyleLayerProperty("layer", "line-gradient",
      '["interpolate",["linear"],["line-progress"],0.0,["rgb",6,1,255],0.5,["rgb",0,255,42],0.7,["rgb",255,252,0],1.0,["rgb",255,30,0]]');
```

## Camera and animations
Platform docs : [Android](https://docs.mapbox.com/android/maps/guides/camera-and-animation/), [iOS](https://docs.mapbox.com/ios/maps/guides/camera-and-animation/). 
The camera is the user's viewpoint above the map. The Maps Flutter Plugin provides you with options to set and adjust the camera position, listen for camera changes, get the camera position, and restrict the camera position to set bounds.

### Camera position
You can set the starting camera position using `MapWidget.cameraOptions` :

```
MapWidget(
  key: ValueKey("mapWidget"),
  resourceOptions: ResourceOptions(accessToken: ACCESS_TOKEN),
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
Platform docs : [Android](https://docs.mapbox.com/android/maps/guides/user-interaction/), [iOS](https://docs.mapbox.com/ios/maps/guides/user-interaction/).

Users interacting with the map in your application can explore the map by performing standard gestures. 

You can retrieve or update the `GestureSettings` using `MapboxMap.gestures`.

You can observe gesture events using `MapWidget.onTapListener`, `MapWidget.onLongTapListener`, `MapWidget.onScrollListener`.


