# Migrate to v1 from v0

The Mapbox Maps Flutter Plugin v1 is the first stable release of a solution from Mapbox enabling developers to embed highly customized maps using a Flutter widget on iOS and Android. This document summarizes the most important changes - such as new features, deprecated APIs, and breaking changes - and walks you through how to upgrade an application using v0 of the Mapbox Maps Flutter Plugin to v1.

## Version Compatibility

| Version | Flutter Version | Dart Version | iOS Version | Android Version   |
|---------|-----------------|--------------|-------------|-------------------|
| 1.0.0   | 3.10.0+         | 3.0.0+       | 12+         | 5.0(API level 21) |

## 1. Explore New Features

### 1.1 The Mapbox Standard Style

We're excited to announce the launch of Mapbox Standard, our latest Mapbox style, now accessible to all customers in a beta version. The new Mapbox Standard core style enables a highly performant and elegant 3D mapping experience with powerful dynamic lighting capabilities, landmark 3D buildings, and an expertly crafted symbolic aesthetic. With Mapbox Standard, we are also introducing a new paradigm for how to interact with map styles based around style importing (see below section for more details).

To set Mapbox Standard as the style for your map in v1 you can use the same `MapboxStyles` convenience variables from v0 like below. Mapbox Standard is the new default style, so not setting a `StyleManager.styleURI` means your map will use Mapbox Standard.

```dart
mapboxMap.style.setStyleURI(MapboxStyles.STANDARD);
```

The Mapbox Standard style features 4 light presets: `day`, `dusk`, `dawn`, and `night`. The style light preset can be changed from the default, `day`, to another preset with a single line of code. Here you identify which imported style (`basemap`) you want to change the `lightPresent` config on, as well as the value (`dusk`) you want to change it to.


```dart
mapboxMap.style.setStyleImportConfigProperty("basemap", "lightPreset", "dusk");
```

Changing the light preset will alter the colors and shadows on your map to reflect the time of day. For more information, check out the New 3D Lighting API section.

Similarly, you can set other configuration properties on the Standard style such as showing POIs, place labels, or specific fonts:

```dart
mapboxMap.style.setStyleImportConfigProperty("basemap", "showPointOfInterestLabels", false);
```

The Standard style offers 6 configuration properties for developers to change when they import it into their own style:

Property | Type | Description
--- | --- | ---
`showPlaceLabels` | `Bool` | Shows and hides place label layers.
`showRoadLabels` | `Bool` | Shows and hides all road labels, including road shields.
`showPointOfInterestLabels` | `Bool` | Shows or hides all POI icons and text.
`showTransitLabels` | `Bool` | Shows or hides all transit icons and text.
`lightPreset` | `String` | Switches between 4 time-of-day states: `dusk`, `dawn`, `day`, and `night`.
`font` | `List` | Defines font family for the style from predefined options.

Mapbox Standard is making adding your own data layers easier for you through the concept of `slot`s. `Slot`s are pre-specified locations in the style where your layer will be added to (such as on top of existing land layers, but below all labels). To do this, we've added a new `slot` property to each `Layer`. This property allows you to identify which `slot` in the Mapbox Standard your new layer should be placed in. To add custom layers in the appropriate location in the Standard style layer stack, we added 3 carefully designed slots that you can leverage to place your layer. These slots will remain stable, so you can be sure that your own map won't break even as the basemap evolves automatically.

Slot | Description
--- | ---
`bottom` | Above polygons (land, landuse, water, etc.)
`middle` | Above lines (roads, etc.) and behind 3D buildings
`top` | Above POI labels and behind Place and Transit labels
not specified | Above all existing layers in the style

```dart
final layer = LineLayer(id: "line-layer", sourceId: "line-source", slot: "middle");
mapboxMap.style.addLayer(layer);
```

- Important: For the new Standard style, you can only add layers to these three slots (`bottom`, `middle`, `top`) within the Standard style basemap.

Similar to the classic Mapbox styles, you can still use the layer position in `StyleManager.addLayer()` method when importing the Standard Style. However, this method is only applicable to custom layers you have added yourself. If you add two layers to the same slot with a specified layer position the latter will define the order of the layers in that slot.

Standard is aware of the map lighting configuration using the `measure-light` expression, which returns you an aggregated value of your light settings. This returns a value which ranges from 0 (darkest) to 1 (brightest). In darker lights, you make the individual layers light up by using the new `*-emissive-stength` expressions, which allow you to add emissive light to different layer types and for example keep texts legible in all light settings. If your custom layers seem too dark, try adjusting the emissive strength of these layers. 

### Customizing Standard

The underlying design paradigm to the Standard style is different from what you know from the classic core styles. Mapbox manages the basemap experience and surfaces key global styling configurations - in return, you get a cohesive visual experience and an evergreen map, always featuring the latest data, styling and rendering features compatible with your SDK. The configuration options make interactions with the basemap simpler than before.

You can customize the overall color of your Standard experience easily by adjusting the 3D light settings. Individual basemap layers and/or color values can’t be adjusted, but all the flexibility offered by the style specification can be applied to custom layers while keeping interaction with the basemap simple through `slot`s.

#### 1.1.1 Style Imports

To work with styles like Mapbox Standard, we've introduced new Style APIs that allow you to import other styles into the main style you display to your users. These styles will be imported by reference, so updates to them will be reflected in your main style without additional work needed on your side. For example, imagine you have style A and style B. The Style API will allow you to import A into B. Upon importing, you can set configurations that apply to A and adjust them at runtime. The configuration properties for the imported style A will depend on what the creator of style A chooses to be configurable. For the Standard style, 6 configuration properties are available for setting lighting, fonts, and label display options (see The Mapbox Standard Style section above).

To import a style, you should add an "imports" section to your [Style JSON](https://docs.mapbox.com/help/glossary/style/). In the above example, you would add this "imports" section to your Style JSON for B to import style A and set various configurations such as `Montserrat` for the `font` and `dusk` for the `lightPreset`.

```
...
"imports": [
    {
        "id": "A",
        "url": "STYLE_URL_FOR_A",
        "config": {
            "font": "Montserrat",
            "lightPreset": "dusk",
            "showPointOfInterestLabels": true,
            "showTransitLabels": false,
            "showPlaceLabels": true,
            "showRoadLabels": false
        }
    }
],
...
```

<!-- TODO: create a Flutter example -->
For a full example of importing a style, please check out our Standard style example on [iOS](https://github.com/mapbox/mapbox-maps-ios/blob/main/Apps/Examples/Examples/All%20Examples/StandardStyleExample.swift) or [Android](https://github.com/mapbox/mapbox-maps-android/blob/main/app/src/main/java/com/mapbox/maps/testapp/examples/StandardStyleActivity.kt). This example imports the Standard style into another style [Real Estate New York](https://github.com/mapbox/mapbox-maps-ios/blob/main/Apps/Examples/Examples/All%20Examples/Sample%20Data/fragment-realestate-NY.json). It then modifies the configurations for the imported Standard style at runtime using the following APIs we've introduced on the `StyleManager` object:

- `StyleManager.getStyleImports()`, which returns all of the styles you have imported into your main style
- `StyleManager.removeStyleImport()`, which removes the style import with the passed Id
- `StyleManager.getStyleImportSchema()`, which returns the full schema describing the style import with the passed Id
- `StyleManager.getStyleImportConfigProperties()`, which returns all of the configuration properties of the style import with the passed Id
- `StyleManager.getStyleImportConfigProperty()`, which returns the specified configuration property of the style import with the passed Id
- `StyleManager.setStyleImportConfigProperties()`, which sets all of the configuration properties of the style import with the passed Id
- `StyleManager.setStyleImportConfigProperty()`, which sets the specified configuration property of the style import with the passed Id

In addition to modifying the configuration properties of the imported styles, you can add your own layers to the imported style through the concept of `slot`s. `Slot`s are pre-specified locations in the imported style where your layer will be added to (such as on top of existing land layers, but below all labels). To do this, we've added a new `slot` property to each `Layer`. This property allows you to identify which `slot` in the imported style your new layer should be placed in.

```dart
final layer = LineLayer(id: "line-layer", sourceId: "line-source", slot: "middle");
mapboxMap.style.addLayer(layer);
```

### 1.2 Access Token and Map Options management

The access token for every Mapbox SDK can now be set via single call of `MapboxOptions.setAccessToken()`. By default, Mapbox SDKs will try to initialize it upon framework initialization time from:

- On iOS: `MBXAccessToken` property list value in the app bundle;
- On Android: `MapboxAccessToken` file in the app bundle.

If you wish to set access token programmatically, it is required to set it before initializing a `MapWidget`.

**v1:**

```dart
MapboxOptions.setAccessToken(accessToken);
```

Configurations for the external resources used by Maps API can now be set via `MapboxMapsOptions`:

**v1:**

```dart
MapboxMapsOptions.setBaseUrl(customBaseURL);
MapboxMapsOptions.setDataPath(customDataPathURL);
MapboxMapsOptions.setAssetPath(customAssetPathURL);
MapboxMapsOptions.setTileStoreUsageMode(TileStoreUsageMode.READ_ONLY);
```

To clear the temporary map data, use the `MapboxMap.clearData()` method.

As part of this change `ResourceOptions` have been removed.

### 1.3 New 3D Lighting API

In v1 we've introduced new experimental lighting APIs to give you control of lighting and shadows in your map when using 3D objects: `AmbientLight` and `DirectionalLight`. We've also added new APIs on `FillExtrusionLayer` and `LineLayer`s to support this 3D lighting styling and enhance your ability to work with 3D model layers. Together, these properties can illuminate your 3D objects such as buildings and terrain to provide a more realistic and immersive map experience for your users. These properties can be set at runtime to follow the time of day, a particular mood, or other lighting goals in your map. Check out our example [here(iOS)](https://github.com/mapbox/mapbox-maps-ios/blob/main/Apps/Examples/Examples/All%20Examples/Lab/Lights3DExample.swift) for reference implementation.
<!-- TODO: provide a Flutter example for lighting -->

### 1.4 Camera API

In v1, we have refined the Camera API introduced in v0 to improve developer ergonomics.

The cameraFor methods (`MapboxMap.cameraForCoordinates()`, `MapboxMap.cameraForCoordinatesPadding()`, and `MapboxMap.cameraForCoordinateBounds()`) have been simplified and aligned with our mobile and Web SDKs. Passing a padding parameter is now optional, and additional optional maxZoom and offset parameters are available for `MapboxMap.cameraForCoordinateBounds()`.

### 1.5 Other minor ergonomic improvements

### 1.5.1 Gestures

##### Breaking change ⚠️

`MapboxMap.dragStart()` and `MapboxMap.dragEnd()` are not in use anymore and got removed.

While maintaing the existing gesture approach we made minor improvements. In v1 we now:

- allow animation during any ongoing gestures
- enable zoom during a drag gesture

#### 1.5.2 Cache Management

Experimental API `MapboxMap/setMemoryBudget(_:)` was renamed to ``MapboxMap/setTileCacheBudget(_:)`` and promoted to stable.

#### 1.5.3 Puck3D's scaling behavior

To further improve the performance of 3D model layer, we have replaced Puck 3D's default `model-scale` expression with a new API `LocationPuck3D.modelScaleMode`. By default this property is `ModelScaleMode.VIEWPORT`, which will keep the 3D model size constant across different zoom levels.
While this means that Puck 3D's size should render similarly to v0, it does introduces a behavior breaking change - that `LocationPuck3D.modelScale` needs to be adjusted to correctly render the puck (in testing we found the adjustment to be around 100x of v0 `model-scale` value, but that could vary depending on other properties etc.).

#### 1.5.4 Bearing updates are disabled by default.

The default value for `LocationComponentSettings.puckBearingEnabled` option has changed from `true` to `false`. That practially means that
MapView wouldn't redraw on each device compass update and should significantly reduce CPU usage for applications that 
only display user location without bearing/heading indication.
If your application still need to rotate puck image according to device heading or location course, enable the option as:

```dart
mapboxMap.location.updateSettings(LocationComponentSettings(puckBearingEnabled: true));
```

## 4. Replace Deprecated APIs and Address Breaking Changes

Check for any deprecated APIs in your code and replace them with the recommended alternatives. Deprecated APIs may be removed in future releases.

### 4.1 Removing `MapboxMap.subscribe()` API

Following a vision of unifing event subscriptions APIs, `MapboxMap.subscribe()` method got removed in favor of `MapWidget`'s `onXListener`.

### 4.2 Update APIs deprecated in v0 which have been removed in v1

- `textLineHeight` property has been removed from `PointAnnotationManager`. Instead, use the data-driven `PointAnnotation.textLineHeight`.
- `PuckBearingSource` has been renamed to `PuckBearing`.

## 5. Review other changes

- The `MapOptions.optimizeForTerrain` option was removed, whenever terrain is present layer order is now automatically adjusted for better performance. Previously, optimization was the default. 

## 7. Test Your App

Test your app thoroughly after making the changes to ensure everything is working as expected.

## 8. Conclusion

Following the above steps will help you migrate your app to the latest version of the Mapbox Maps Flutter Plugin. If you encounter any issues during the migration process, refer to the [Mapbox Maps Flutter Plugin examples](https://github.com/mapbox/mapbox-maps-flutter/tree/main/example/lib) or reach out to the Mapbox support team for assistance.
