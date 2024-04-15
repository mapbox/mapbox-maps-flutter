### main

* Introduce `TileCacheBudget`, a property to set per-source cache budgets in either megabytes or tiles. 
* Expose `iconColorSaturation`, `rasterArrayBand`, `rasterElevation`, `rasterEmissiveStrength`, `hillshadeEmissiveStrength`, and `fillExtrusionEmissiveStrength` on their respective layers. 
* Mark `MapboxMapsOptions.get/setWorldview()` and `MapboxMapsOptions.get/setLanguage()` as experimental.
* Bump Pigeon to 17.1.2
* [iOS] Fix crash in `onStyleImageMissingListener`.
* Deprecate `cameraForCoordinates`, please use `cameraForCoordinatesPadding` instead.
* Add a way to disable default puck's image(s) when using `DefaultLocationPuck2D`. By passing an empty byte array, for example, the following code shows a puck 2D with custom top image, default bearing image and no shadow image.
```
mapboxMap?.location.updateSettings(LocationComponentSettings(
    enabled: true,
    puckBearingEnabled: true,
    locationPuck:
        LocationPuck(locationPuck2D: DefaultLocationPuck2D(topImage: list, shadowImage: Uint8List.fromList([]))))
);
```

#### ⚠️ Breaking changes

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


* Fix camera center not applied from map init options.
* [iOS] Free up resources upon map widget disposal. This should help to reduce the amount of used memory when previously shown map widget is removed from the widget tree.

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
