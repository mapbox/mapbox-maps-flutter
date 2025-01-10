# main

* Add support for Swift Package Manager.
* Introduce the experimental Interactions API, a toolset that allows you to handle interactions on both layers and basemap features for styles. This API introduces a new concept called `Featureset`, which allows Evolving Basemap styles, such as Standard, to export an abstract set of features, such as POI, buildings, and place labels, regardless of which layers they are rendered on. An `Interaction` can then be targeted to these features, modifying their state when interacted with. For example, you can add a `TapInteraction` to your map which targets the `buildings` `Featureset`. When a user taps on a building, the building will be highlighted and its color will change to blue. 

```dart
var tapInteraction = TapInteraction(Featureset.standardBuildings())
mapboxMap.addInteraction(tapInteraction, 
  (_, FeaturesetFeature feature) {
    mapboxMap.setFeatureStateForFeaturesetFeature(feature, 
    StandardBuildingState(highlight: true));
  }
);
```

Specific changes: 
  * Introduce the experimental `MapboxMap.addInteractions` method, which allows you to add interactions to the map. 
  * Introduce `TapInteraction` and `LongTapInteraction`, which allow you to add tap and longTap interactions to the map.
  * Introduce `FeaturesetDescriptor` -- and convenience descriptors for `StandardBuildings`, `StandardPOIs`, and `StandardPlaceLabels` -- which allow you to describe the featureset you want `Interactions` to target.
  * Introduce low-level methods for creating and manipulating interactive features: `queryRenderedFeatures`, `querySourceFeatures`, `setFeatureState`, `getFeatureState`, `removeFeatureState`, `resetFeatureState`
* For more guidance with using these new features see `interactive_features_example.dart`.

### 2.5.0

* Mark `ClipLayer` as stable.
* Updated our generated code to align with iOS and Android platforms. Specifically, the changes:
  * Update experimental `symbolElevationReference` property on `SymbolLayer`. 
  * Introduce `backgroundPitchAlignment` property on `BackgroundLayer`.
  * Introduce experimental `fillZOffset` property on `FillLayer`.
  * Introduce experimental `fillExtrusionBaseAlignment` and `fillExtrusionHeightAlignment` properties on `FillExtrusionLayer`.
  * Mark get and set `ZOffset` methods on `PolygonAnnotationManager`, `PolylineAnnotationManager`, and `PointAnnotationManager` as experimental.
  * Mark get and set `symbolElevationReference` methods on `PointAnnotationManager` as experimental.
  * Mark get and set line trim methods on `PolylineAnnotationManager` as experimental.
  * Add a property `emphasisCircleGlowRange` to `LocationIndicatorLayer` to control the glow effect of the emphasis circle – from the solid start to the fully transparent end.  
  * Add experimental `ZOffset` properties to `PolylineAnnotationMessenger`, `PolygonAnnotationMessenger`, and `PointAnnotationMessenger`. 
  * Introduce `FillExtrusionBaseAlignment` and `FillExtrusionHeightAlignment`, and `BackgroundPitchAlignment` enums.
* Added viewport support to `MapWidget`. Control the camera’s initial position and behavior by specifying a ViewportState subclass in the viewport parameter. This allows for centering on specific locations, following the user’s position, or showing an overview of a geometry. If no viewport is provided, the map uses its default camera settings.
  ```dart
  MapWidget(
    viewport: CameraViewportState(
      center: Point(coordinates: Position(-117.918976, 33.812092)),
      zoom: 15.0,
    ),
  );
  ```

### 2.4.1

* Fix annotation click listeners not working.

### 2.4.0

> [!IMPORTANT]
> Configuring Mapbox's secret token is no longer required when installing our SDKs.

* Update Maps SDK to 11.8.0
* Updated the minimum required Flutter SDK to version 3.22.3 and Dart to version 3.4.4. With the fix for Virtual Display hosting mode on Android in Flutter 3.22, we’ve changed the default map view hosting mode to Virtual Display composition. This update should eliminate the brief visibility of the map after it has been dismissed.
* Introduce experimental property `MapboxMap.styleGlyphURL`. Use this property to apply custom fonts to the map at runtime, without modifying the base style.
* Expose current map's camera state on `CameraChanged` event. [#704](https://github.com/mapbox/mapbox-maps-flutter/pull/704)

You can now observe the map's camera updates with `onCameraChangeListener`

```dart
onCameraChangeListener(CameraChangedEventData data) {
  print("CameraChangedEventData: timestamp: ${data.timestamp}, cameraState: ${data.cameraState}");
}
```
* Print to console native Maps SDK logs in debug configuration. [#710](https://github.com/mapbox/mapbox-maps-flutter/pull/710)
Logs are proxied only in debug configuration and can be disabled completely by passing environment flag `MAPBOX_LOG_DEBUG` with false value.
* Fix rare crash in `Snapshotter`. The crash could happen when creating/destroying multiple instances of `Snapshotter` in succession. [#728](https://github.com/mapbox/mapbox-maps-flutter/pull/728)
* Fix a crash that occurs when the widget state is updated before the platform view is created. [#724](https://github.com/mapbox/mapbox-maps-flutter/pull/724)
* Fix a crash in Snapshotter when GlyphsRasterizationMode is specified in MapSnapshotOptions. [#738](https://github.com/mapbox/mapbox-maps-flutter/pull/738)
* Remove `ProxyBinaryMessenger`, instead setup channel with a `messageChannelSuffix`. [#715](https://github.com/mapbox/mapbox-maps-flutter/pull/715).

# 2.3.0

* Deprecate untyped default constructor of `RenderedQueryGeometry` with typed constructors: `RenderedQueryGeometry.fromList()/fromScreenBox()/fromScreenCoordinate()`.

This change improves type safety and clarity in the code. By using specific constructors, you can ensure that the `RenderedQueryGeometry` is created with the correct type of data, reducing the risk of runtime errors and making the code easier to understand and maintain.

**Example:**

*Before:*
```dart
// Using the untyped default constructor
final geometry = RenderedQueryGeometry(type: Type.SCREEN_COORDINATE, value jsonEncode(screenCoordinate.encode()));
```

*After:*
```dart
// Using a typed constructor
final geometry = RenderedQueryGeometry.fromScreenCoordinate(screenCoordinate);
```
* Expose API to clear map data, and to set options to `TileStore`.

You can now clear temporary map data from the data path defined in the given resource options, which is useful when you want reduce the disk usage or in case the disk cache contains invalid data.
```dart
await MapboxMapsOptions.clearData();
```
And you can now set additional options to a `TileStore`, for example, a maximum amount of bytes TileStore can use to store files., base URL to use for requests to the Mapbox API, or URL template for making tile requests.
```dart
// Set the disk quota to zero, so that tile regions are fully evicted
// when removed.
// This removes the tiles from the predictive cache.
tileStore.setDiskQuota(0);
```
* Add support for partial GeoJSON updates. 

Instead of setting a whole new GeoJSON object anew every time a single feature has changed, now you can apply more granular, partial GeoJSON updates.
If your features have associated identifiers - you can add, update, and remove them on individual basis in your ``GeoJSONSource``. This is especially beneficial for ``GeoJSONSource``s hosting a large amount of features - in this case adding a feature can be up to 4x faster with the partial GeoJSON update API.

```dart
mapboxMap.style.addGeoJSONSourceFeatures(sourceId, dataId, features)
mapboxMap.style.updateGeoJSONSourceFeatures(sourceId, dataId, features)
mapboxMap.style.removeGeoJSONSourceFeatures(sourceId, dataId, featureIds)
```
* Fix `StyleManager.getLayer()` failing for `ModelLayer`, `RasterParticleLayer` and `SlotLayer`.
* Expose data-driven properties on annotation managers. Now it's possible to set data-driven properties globally on annotation manager and specify per-annotation overrides.
Previously user had to specify those properties on each annotation and couldn't specify them globally.

In this case each even annotation will have random color, but others will use the global default specified in the annotation manager.
```dart
final circleAnnotationManager = await mapboxMap.annotations.createCircleAnnotationManager();
var annotations = <CircleAnnotationOptions>[];
for (var i = 0; i < 2000; i++){
  var annotation = CircleAnnotationOptions(
    geometry: createRandomPoint(),
    circleColor: (i % 2 == 0) ? createRandomColor() : null,
    );

  annotations.add(annotation);
}
circleAnnotationManager.setCircleColor(Colors.blue.value);
```
* Expose `autoMaxZoom` property for `GeoJsonSource` to fix rendering issues with `FillExtrusionLayer` in some cases.
* Expose experimental `ClipLayer` to remove 3D data (fill extrusions, landmarks, trees) and symbols.
* Deprecate `SlotLayer.sourceId` and `SlotLayer.sourceLayer` as they have no effect in this layer.
* Expose experimental `SymbolLayer.symbolElevationReference` and `SymbolLayer.symbolZOffset`.
* Add missing `@experimental` annotations to `Layer`'s `Expression` properties.
* Remove experimental `model-front-cutoff` property from `ModelLayer`.
* Expose experimental `lineTrimColor` and `lineTrimFadeRange` on `LineLayer` which allow to set custom color for trimmed line and fade effect for trim.
* Add experimental `FillExtrusionLayer.fillExtrusionLineWidth` that can switch fill extrusion rendering into wall rendering mode. Use this property to render the feature with the given width over the outlines of the geometry.
* Add experimental `MapboxMap.setSnapshotLegacyMode()` to help avoiding `MapboxMap.snapshot()` native crash on some Samsung devices running Android 14. `MapboxMap.setSnapshotLegacyMode()` has no effect on iOS.
* Fix build errors when using Flutter SDK 3.24.
* Add `GestureState` to `MapContentGestureContext` to indicate whether gesture has been started, its touches have changed or it has ended.
* Bump Maps SDK to 11.7.0.

### 2.2.0

* Bump Maps SDK to 11.6.0
* Update Pigeon to `21.1.0`

### 2.2.0-rc.1

* Expose `MapboxStyles.STANDARD_SATELLITE` style.
* `MapDebugOptions` is superseded by `MapWidgetDebugOptions`, expanding existing debug options with the new `light`, `camera`, and `padding` debug options in addition to the new Android-specific options: `layers2DWireframe` and `layers3DWireframe`.
* Bump Maps SDK to 11.6.0-rc.1

### 2.2.0-beta.1

* Support local assets for 3D puck and `ModelLayer`. To use a local assets, please specify it with `asset://` scheme in the uri.
* Fix map view crashing upon host activity destruction when using a cached Flutter engine.
* Fix a rare crash happening when map widget is being disposed.

### 2.1.0

* Add ModelLayer API.
* Support for offline map, allowing users to download and store map data on their devices for use in environments with limited or no internet connectivity.
* Layer expressions support. Specify expressions when constructing a layer with all new expression support for layers.
*Before:*
```dart
mapboxMap.style.setStyleLayerProperty("layer", "line-gradient",
    '["interpolate",["linear"],["line-progress"],0.0,["rgb",255,0,0],0.4,["rgb",0,255,0],1.0,["rgb",0,0,255]]');

```
*After:*
```dart
LineLayer(
  ...
  lineGradientExpression: [
    "interpolate",
    ["linear"],
    ["line-progress"],
    0.0,
    ["rgb", 255, 0, 0],
    0.4,
    ["rgb", 0, 255, 0],
    1.0,
    ["rgb", 0, 0, 255]
  ],
);
```
* Expose `text-occlusion-opacity`, `icon-occlusion-opacity`, `line-occlusion-opacity`, `model-front-cutoff`, `lineZOffset` as experimental.
* Add min/max/default values for most of the style properties.
* Expose `clusterMinPoints` property for `GeoJSONSource`.
* Expose `SlotLayer` and `RasterParticleLayer`.
* Expose `LocationComponentSettings.slot`.
* Add `@experimental` annotation to relevant APIs.
* Expose `LineJoin.NONE`.
* Bump Maps SDK to 11.5.0 for Android and 11.5.1 for iOS.

### 2.1.0-rc.1

* Bump Maps SDK to 11.5.0-rc.1
* Expose `text-occlusion-opacity`, `icon-occlusion-opacity`, `line-occlusion-opacity`, `model-front-cutoff`, `lineZOffset` as experimental.
* Add min/max/default values for most of the style properties.
* Expose `clusterMinPoints` property for `GeoJSONSource`.
* Expose `SlotLayer` and `RasterParticleLayer`.
* Expose `LocationComponentSettings.slot`.
* Add `@experimental` annotation to relevant APIs.

### 2.1.0-beta.1

* Add ModelLayer API.
* Support for offline map, allowing users to download and store map data on their devices for use in environments with limited or no internet connectivity.
* Layer expressions support. Specify expressions when constructing a layer with all new expression support for layers.
*Before:*
```dart
mapboxMap.style.setStyleLayerProperty("layer", "line-gradient",
    '["interpolate",["linear"],["line-progress"],0.0,["rgb",255,0,0],0.4,["rgb",0,255,0],1.0,["rgb",0,0,255]]');

```
*After:*
```dart
LineLayer(
  ...
  lineGradientExpression: [
    "interpolate",
    ["linear"],
    ["line-progress"],
    0.0,
    ["rgb", 255, 0, 0],
    0.4,
    ["rgb", 0, 255, 0],
    1.0,
    ["rgb", 0, 0, 255]
  ],
);
```
* Bump Maps SDK to 11.5.0-beta.1

### 2.0.0

#### ⚠️ Breaking changes

##### Leveraging [Turf](https://pub.dev/packages/turf)'s geometries as a replacement for Map<String, Any?>

You now have the convenience of directly initializing annotations with Turf's geometries, eliminating the need for converting geometry to JSON.

##### Geographical position represented by `Point`s

Geographical positions denoted by `Map<String?, Object?>?` are migrated to [`Point`](https://pub.dev/documentation/turf/latest/turf/Point-class.html) type from [turf](https://pub.dev/packages/turf) package.
Pass `Point`s directly instead of converting them to JSON.
*Before:*
```dart
CameraOptions(
    center: Point(
        coordinates: Position(
        -0.11968,
        51.50325,
    )).toJson())
```
*After:*
```dart
CameraOptions(
    center: Point(
        coordinates: Position(
        -0.11968,
        51.50325,
    )))
```

##### Screen and geographical positions in map interaction(gestures) callbacks
`MapWidget`'s `onTapListener`/`onLongTapListener`/`onScrollListener` now receive `MapContentGestureContext` containing both touch position of the gesture, as well as the projected map coordinate corresponding to the touch position.
*Before:*
```dart
onTapListener: { (coordinate)
    final lat = coordinate.x;
    final lng = coordinate.y;
    ...
}
```

*After:*
```dart
onTapListener: { (context)
    final coordinates = context.point.coordinates; // Position
    final touchPosition = context.touchPosition; // ScreenCoordinate
    ...
}
```
##### Creating an annotation with a given geometry
*Before:*
```dart
PointAnnotationOptions(
  geometry: Point(
    coordinates: Position(0.381457, 6.687337)
  ).toJson()
)
PolygonAnnotationOptions(
  geometry: Polygon(coordinates: [
    [
      Position(-3.363937, -10.733102),
      Position(1.754703, -19.716317),
      Position(-15.747196, -21.085074),
      Position(-3.363937, -10.733102)
    ]
  ]).toJson()
)
PolylineAnnotationOptions(
  geometry: LineString(coordinates: [
    Position(1.0, 2.0),
    Position(10.0, 20.0)
  ]).toJson()
)
```

*After:*
```dart
PointAnnotationOptions(
  geometry: Point(
    coordinates: Position(0.381457, 6.687337)
  )
)
PolygonAnnotationOptions(
  geometry: Polygon(coordinates: [
    [
      Position(-3.363937, -10.733102),
      Position(1.754703, -19.716317),
      Position(-15.747196, -21.085074),
      Position(-3.363937, -10.733102)
    ]
  ])
)
PolylineAnnotationOptions(
  geometry: LineString(coordinates: [
    Position(1.0, 2.0),
    Position(10.0, 20.0)
  ])
)
```
##### Snapshots

###### Standalone snapshotter

Show multiple maps at the same time with no performance penalty. With the all new `Snapshotter` you can get image snapshots of the map, styled the same way as `MapWidget`.

The `Snapshotter` class is highly configurable. You can set the final result at the time of construction using the `MapSnapshotOptions`. Once you've configured your snapshot, you can start the snapshotting process.

One of the key features of the `Snapshotter` class is the `style` object. This object can be manipulated to set different styles for your snapshot, as well as to apply runtime styling to the style, giving you the flexibility to create a snapshot that fits your needs.

```dart
final snapshotter = await Snapshotter.create(
  options: MapSnapshotOptions(
      size: Size(width: 400, height: 400),
      pixelRatio: MediaQuery.of(context).devicePixelRatio),
  onStyleLoadedListener: (_) {
    // apply runtime styling
    final layer = CircleLayer(id: "circle-layer", sourceId: "poi-source");
    snapshotter?.style.addLayer(layer);
  },
);
snapshotter.style.setStyleURI(MapboxStyles.STANDARD);
snapshotter.setCamera(CameraOptions(center: Point(...)));

...

final snapshotImage = await snapshotter.start()
```
##### Map widget snapshotting

Create snapshots of the map displayed in the `MapWidget` with `MapboxMap.snapshot()`. This new feature allows you to capture a static image of the current map view.

The `snapshot()` method captures the current state of the Mapbox map, including all visible layers, markers, and user interactions.

To use the snapshot() method, simply call it on your Mapbox map instance. The method will return a Future that resolves to the image of the current map view.

```dart
final snapshotImage = await mapboxMap.snapshot();
```

Please note that the `snapshot()` method works best if the Mapbox Map is fully loaded before capturing an image. If the map is not fully loaded, the method might return a blank image.

* Fix camera center not applied from map init options.
* [iOS] Free up resources upon map widget disposal. This should help to reduce the amount of used memory when previously shown map widget is removed from the widget tree.
* Fix multi-word enum cases decoding/encoding when being sent to/from the platform side.
* [Android] Add Gradle 8 compatibility.
* Introduce experimental `RasterArraySource`, note that `rasterLayers` is a get-only property and cannot be set.
* Introduce `TileCacheBudget`, a property to set per-source cache budgets in either megabytes or tiles.
* Expose `iconColorSaturation`, `rasterArrayBand`, `rasterElevation`, `rasterEmissiveStrength`, `hillshadeEmissiveStrength`, and `fillExtrusionEmissiveStrength` on their respective layers.
* Mark `MapboxMapsOptions.get/setWorldview()` and `MapboxMapsOptions.get/setLanguage()` as experimental.
* Bump Pigeon to 17.1.2
* [iOS] Fix crash in `onStyleImageMissingListener`.
* Deprecate `cameraForCoordinates`, please use `cameraForCoordinatesPadding` instead.
* Add a way to disable default puck's image(s) when using `DefaultLocationPuck2D`. By passing an empty byte array, for example, the following code shows a puck 2D with custom top image, default bearing image and no shadow image.
```dart
mapboxMap?.location.updateSettings(LocationComponentSettings(
    enabled: true,
    puckBearingEnabled: true,
    locationPuck:
        LocationPuck(locationPuck2D: DefaultLocationPuck2D(topImage: list, shadowImage: Uint8List.fromList([]))))
);
```
* Update Maps SDK to 11.4.0.

### 1.1.0

* [Android] Fix `maps-lifecycle` plugin crash with `java.lang.IllegalStateException: Please ensure that the hosting activity/fragment is a valid LifecycleOwner`.
* Mark `MapboxMapsOptions.get/setWorldview()` and `MapboxMapsOptions.get/setLanguage()` as experimental.
* Update Maps SDK to 11.3.0.

### 1.0.0

* Add `MapboxMapsOptions.get/setWorldview()` and `MapboxMapsOptions.get/setLanguage()`. Use this to to adjust administrative boundaries/map language based on the map's audience.
Read more about [Mapbox worldviews](https://docs.mapbox.com/help/glossary/worldview/) and [language support](https://docs.mapbox.com/help/troubleshooting/change-language/).
* Add a way to specify custom id for annotation manager(and subsequently its backing layer's and source's ids).
* Add `below` parameter to `createAnnotationManager()`, use this to control the position of the annotation layer in relation to other style layers.
* Add `DefaultLocationPuck2D` type interchangeable with `LocationPuck2D` that allows customization of the default location indicator appearance.
* Add `_AnnotationManager.removeAnnotationManagerById()` allowing to remove annotation manager by its id, without having to store a reference to the manager.
* Fix point annotation image disappearing after update on iOS.
* Bump Pigeon to v16.0.0.
* Updater minimum Flutter SDK version to 3.10.0 and above.
* Update minumum Dart SDK version to 3.0.0 and above.
* Convert `MapboxMapsOptions.setBaseUrl()`, `MapboxMapsOptions.getDataPath()`, `MapboxMapsOptions.setDataPath()`, `MapboxMapsOptions.getAssetPath()`, `MapboxMapsOptions.setAssetPath()`, `MapboxMapsOptions.getTileStoreUsageMode()` and `MapboxMapsOptions.setTileStoreUsageMode()` to static methods.
* Fix 2D puck's opacity not being respected on iOS.
* Make `padding` parameter optional in `MapboxMap.cameraForCoordinateBounds()` and `MapboxMap.cameraForCoordinates()`.
* Fix initial camera options passed to `MapWidget` not being applied on Android.
* Add an example representing a traffic route with color based on traffic volumes using LineLayer and Expression.
* [Android] Fix MapOptions incorrect index access at map creation, leading to map not being created(blank view).
* [Android] Use hybrid composition(HC) as the default platform view hosting mode on Android.
* [Android] Add experimental `androidHostingMode` constructor parameter to `MapWidget`. Use this to change the way platform MapView is being hosted by Flutter on Android. This changes the way map view is composited with Flutter UI, read more on this in [Android Platform Views](https://github.com/flutter/flutter/wiki/Android-Platform-Views) guide from the Flutter team.
* [iOS] `MapboxMap`: `isGestureInProgress()`, `isUserAnimationInProgress()`, `setConstrainMode()`, `setNorthOrientation()`, `setViewportMode()` and `reduceMemoryUse()` are now available on iOS.
* Add `LogConfiguration` allowing to intercept logs produced by the plugin. Pass your custom `LogWriterBackend` to `LogConfiguration.registerLogWriterBackend()` to redirect logs produced by the mapping engine to your desired destination.
* Add `MapWidget.onResourceRequestListener` that can be used to subscribe to resource requests made by the map.
* [iOS] Re-wire `MapWidget`'s `onScroll` event to be triggered whenever map is being panned instead of triggering it only after pan ends.
* [iOS] Address crashes on iOS happening when user location is being shown.
* Bump platform Maps SDK dependencies to 11.1.0.

### 1.0.0-rc.1

* Add `LogConfiguration` allowing to intercept logs produced by the plugin. Pass your custom `LogWriterBackend` to `LogConfiguration.registerLogWriterBackend()` to redirect logs produced by the mapping engine to your desired destination.
* Add `MapWidget.onResourceRequestListener` that can be used to subscribe to resource requests made by the map.
* [iOS] Re-wire `MapWidget`'s `onScroll` event to be triggered whenever map is being panned instead of triggering it only after pan ends.
* [iOS] Address crashes on iOS happening when user location is being shown.

### 1.0.0-beta.3

* Add an example representing a traffic route with color based on traffic volumes using LineLayer and Expression.
* [Android] Fix MapOptions incorrect index access at map creation, leading to map not being created(blank view).
* [Android] Use hybrid composition(HC) as the default platform view hosting mode on Android.
* [Android] Add experimental `androidHostingMode` constructor parameter to `MapWidget`. Use this to change the way platform MapView is being hosted by Flutter on Android. This changes the way map view is composited with Flutter UI, read more on this in [Android Platform Views](https://github.com/flutter/flutter/wiki/Android-Platform-Views) guide from the Flutter team.
* [iOS] `MapboxMap`: `isGestureInProgress()`, `isUserAnimationInProgress()`, `setConstrainMode()`, `setNorthOrientation()`, `setViewportMode()` and `reduceMemoryUse()` are now available on iOS.
* Bump platform Maps SDK dependencies to 11.2.0-beta.1.

### 1.0.0-beta.2

* Add a way to specify custom id for annotation manager(and subsequently its backing layer's and source's ids).
* Add `below` parameter to `createAnnotationManager()`, use this to control the position of the annotation layer in relation to other style layers.
* Add `DefaultLocationPuck2D` type interchangeable with `LocationPuck2D` that allows customization of the default location indicator appearance.
* Add `_AnnotationManager.removeAnnotationManagerById()` allowing to remove annotation manager by its id, without having to store a reference to the manager.
* Fix point annotation image disappearing after update on iOS.
* Bump Pigeon to v16.0.0.
* Updater minimum Flutter SDK version to 3.10.0 and above.
* Update minumum Dart SDK version to 3.0.0 and above.
* Convert `MapboxMapsOptions.setBaseUrl()`, `MapboxMapsOptions.getDataPath()`, `MapboxMapsOptions.setDataPath()`, `MapboxMapsOptions.getAssetPath()`, `MapboxMapsOptions.setAssetPath()`, `MapboxMapsOptions.getTileStoreUsageMode()` and `MapboxMapsOptions.setTileStoreUsageMode()` to static methods.
* Fix 2D puck's opacity not being respected on iOS.
* Make `padding` parameter optional in `MapboxMap.cameraForCoordinateBounds()` and `MapboxMap.cameraForCoordinates()`.
* Fix initial camera options passed to `MapWidget` not being applied on Android.
* Bump platform Maps SDK dependencies to 11.1.0.

### 1.0.0-beta.1

Bump platform Maps SDK dependencies to 11.0.0.

### 0.5.1
### Android

* Fix registry token lookup failing with an unrelated error in certain circumstances.

## 0.5.0
### Common

* Screen-related units(screen coordinates, dimentions, etc.) are expected to be provided in logical pixels.
We have matched screen-related units expected by the maps plugin to the units that Flutter operates with(logical pixels).

## 0.4.5
### Common

* Update pigeon to v11 ([#248](https://github.com/mapbox/mapbox-maps-flutter/pull/234)).
* Fix typecasting exeption when trying to access nested collections [#249](https://github.com/mapbox/mapbox-maps-flutter/pull/249)).
* Set default style to `MapboxStyles.MAPBOX_STREETS` ([#248](https://github.com/mapbox/mapbox-maps-flutter/pull/234)).

### iOS
* Add support for 2d puck pulsing ([#253](https://github.com/mapbox/mapbox-maps-flutter/pull/253)).
* Fix attribution button color not being applied ([#252](https://github.com/mapbox/mapbox-maps-flutter/pull/252)).

### Android
* Fix scale bar and location component settings color decoding ([#255](https://github.com/mapbox/mapbox-maps-flutter/pull/255)).

## 0.4.4
### Android
* Bump platform Maps SDK to 10.13.0.

### iOS
* Bump platform Maps SDK to 10.13.1.
* Fix 2d puck bearing not displayed.
* Fix pinchZoomEnabled gesture setting not applied.

## 0.4.3
### Common
* Fix multiple memory leaks.

## 0.4.2
### Common
* Add methods to set gesture listeners dynamically.

### iOS
* Apply scale factor to UIImage.
* Apply scale factor to UIEdgeInsets.
* Fix vertical scrollMode lock on gesture settings update.

### Android
* Fix ImageStretches mapping.

## 0.4.1

### Common
* Expose `package:turf/helpers.dart`.
* Bump platform Maps SDK dependencies to 10.10.0.
* Fix issue with multiple maps overriding platform channels of the previous instances.
* Fix exception accessing `style.getLayer` when layer property is an Expression.

### iOS
* Fix `pixelsForCoordinates` implementation.

## 0.4.0

### Common
* Expose `style.localizeLabels`.
* Expose `mapboxMap.attribution`, `mapboxMap.logo`, `mapboxMap.compass` and `mapboxMap.scaleBar` settings.

### iOS
* Fix deployment target for iOS to 11.

## 0.3.0

### Common
* Rename library to `mapbox_maps_flutter` due to naming conflict to be able publish to `pub.dev`.

### Android
* Align Kotlin version 1.5.31 with the Maps SDK.

## 0.2.0

### Common
* Rename `MapView` to `MapWidget`.
* Remove `RenderCacheOptions`.
* Rename `MapboxMap.cameraForCoordinates2` to `MapboxMap.cameraForCoordinatesCameraOptions`.
* Rename `styles.dart` to `mapbox_styles.dart`.
* Rename `fill-extrusion_layer.dart` to `fill_extrusion_layer.dart`,
`location-indicator_layer.dart` to `location_indicator_layer.dart`.
* Fix exception thrown by `MapboxMap.coordinatesForPixels`.
* Fix camera example `_coordinateForPixel`.
* Add gesture listeners `MapWidget.onTapListener`, `MapWidget.onLongTapListener`, `MapWidget.onScrollListener`.

## 0.1.1

### Common
* Decrease min flutter version to 2.10.5.

## 0.1.0

### Common
* Initial release.
