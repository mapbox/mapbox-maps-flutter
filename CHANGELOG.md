## 0.7.0

> [!NOTE] 
> This release adds support for Android 16KB page size requirements and iOS compatibility improvements. 

### Android
* Update Android Maps SDK version to v10.19.1
* Add support for 16KB page size requirements for Google Play Store compliance

### iOS
* Update iOS Maps SDK version to v10.19.4
* Change minimum iOS version to 12.0

## 0.6.0

> [!NOTE] 
> This release contains fixes to the Privacy Manifest on iOS. Upgrade to avoid issues in the App Store app submission starting from May 1st.

### Android
* Fix map being pixelated on some devices when ContextMode.SHARED is used (e.g. in AndroidAuto extension).
* Fix incorrect widget position and scale when resizing the drawing surface.
* Fix a crash in MapView.snapshot happening on specific devices.

### iOS
* Fix the issue with invalid privacy manifest

## 0.5.1
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
