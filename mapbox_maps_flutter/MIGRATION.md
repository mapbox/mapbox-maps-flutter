# Migrating to mapbox_maps_flutter v3

This guide helps you upgrade from **mapbox_maps_flutter v2.x** to **v3.x**.

**mapbox_maps_flutter v3** is a major release. It introduces a **federated plugin architecture**, **first-class web support**, and a cleaner public API surface. Most day-to-day map code continues to import `package:mapbox_maps_flutter/mapbox_maps_flutter.dart` — you do not need to depend on the platform packages directly unless you are building a custom platform implementation.

> **Note:** v3 is currently in **public preview**.

## What's new in v3

- **Federated plugin layout** — `mapbox_maps_flutter` is the app-facing package; Android and iOS ship in `mapbox_maps_flutter_mobile`, web in `mapbox_maps_flutter_web`, and shared types in `mapbox_maps_flutter_platform_interface`. Mobile and web packages are **endorsed automatically** when you add the main dependency.
- **Web support** — run the same `MapWidget` and most APIs on Flutter Web via Mapbox GL JS.
- **ViewportController** — imperative, animated camera changes replace the old `setStateWithViewportAnimation` pattern.
- **Unified gesture observability** — pan, zoom, rotate, and pitch each expose a typed `gestureEvents` stream.
- **Settings managers** — ornament and gesture settings are accessed through `*SettingsManager` wrappers (for example `mapboxMap.compass` is now a `CompassSettingsManager`).

## Requirements

| | v2 (latest) | v3 |
|---|---|---|
| Flutter | ≥ 3.27.0 | ≥ **3.38.1** |
| Dart | ≥ 3.4.4 | ≥ **3.10.0** |
| Android minSdk | 21 | 21 |
| iOS | 14+ | 14+ |
| Web | Not supported | Mapbox GL JS required |

## Quick start

Follow the [Get Started v3 guide](https://docs.mapbox.com/flutter/maps/guides/install-v3/) for dependency setup, access token configuration, web setup, and adding your first map.

Then work through the [Breaking API changes](#breaking-api-changes) section below. Most apps only need a handful of edits — especially if you already adopted APIs that were deprecated in v2.

---

## Breaking API changes

### Configuration

#### Access token retrieval

`MapboxOptions.getAccessToken()` was removed. Use the async getter instead:

```dart
// Before (v2)
final token = await MapboxOptions.getAccessToken();

// After (v3)
final token = await MapboxOptions.accessToken;
```

`MapboxOptions.setAccessToken(...)` is unchanged.

### MapWidget

#### `MapWidget.getMapboxMap()` removed

Use the `onMapCreated` callback:

```dart
MapWidget(
  onMapCreated: (mapboxMap) {
    // store and use mapboxMap
  },
)
```

### Viewport & camera

#### Initial camera: `cameraOptions` → `viewport`

`MapWidget.cameraOptions` was removed (it was deprecated in v2.23). Use the viewport API:

```dart
// Before (v2)
MapWidget(
  cameraOptions: CameraOptions(
    center: Point(coordinates: Position(-80.1263, 25.7845)),
    zoom: 12.0,
  ),
)

// After (v3)
MapWidget(
  viewport: CameraViewportState(
    center: Point(coordinates: Position(-80.1263, 25.7845)),
    zoom: 12.0,
  ),
)
```

#### Animated viewport changes: `setStateWithViewportAnimation` → `ViewportController`

`MapWidget` is now a `StatelessWidget`. Imperative viewport animations use `ViewportController`:

```dart
// Before (v2) — inside a StatefulWidget wrapping MapWidget
setStateWithViewportAnimation(
  () => _viewport = CameraViewportState(center: nyc, zoom: 12),
  transition: FlyViewportTransition(duration: Duration(seconds: 2)),
);

// After (v3)
final _viewportController = ViewportController();

_viewportController.moveTo(
  CameraViewportState(center: nyc, zoom: 12),
  transition: FlyViewportTransition(duration: Duration(seconds: 2)),
  completion: (finished) => print('done: $finished'),
);

// Pass to MapWidget
MapWidget(viewportController: _viewportController, ...)

// Don't forget to dispose
@override
void dispose() {
  _viewportController.dispose();
  super.dispose();
}
```

See `example/lib/viewport_example.dart` for a full sample.

#### `coordinatesForPixels` nullability

The `pixels` parameter is now `List<ScreenCoordinate>` (non-nullable elements). Remove null entries from lists you pass in.

### Gestures & interactions

#### Map tap / long tap: widget listeners → Interaction API

`MapWidget.onTapListener`, `MapWidget.onLongTapListener`, and the corresponding `MapboxMap.onMapTapListener` / `onMapLongTapListener` setters were removed (deprecated in v2.23–2.25). Use `addInteraction`:

```dart
// Before (v2)
MapWidget(
  onTapListener: (context) => print(context.point),
  onLongTapListener: (context) => print(context.point),
)

// After (v3) — register inside onMapCreated
void _onMapCreated(MapboxMap mapboxMap) {
  mapboxMap.addInteraction(
    TapInteraction.onMap((context) {
      print('tap at ${context.point}');
    }),
  );
  mapboxMap.addInteraction(
    LongTapInteraction.onMap((context) {
      print('long tap at ${context.point}');
    }),
  );
}
```

For featureset-specific interactions (Standard POIs, buildings, custom layers), pass a `FeaturesetDescriptor` to `TapInteraction` / `LongTapInteraction`. See `example/lib/standard_style_interactions_example.dart`.

> **Web note:** `LongTapInteraction` is not supported on web yet.

#### Scroll / zoom gesture listeners

`MapWidget.onScrollListener`, `MapWidget.onZoomListener`, and the `MapboxMap.onMapScrollListener` / `onMapZoomListener` setters are deprecated in v3 and will be removed in a future release. Subscribe to typed gesture streams instead:

```dart
// Before (v2)
MapWidget(
  onScrollListener: (context) => print('scroll: ${context.point}'),
  onZoomListener: (context) => print('zoom: ${context.point}'),
)

// or on MapboxMap
mapboxMap.onMapScrollListener = (context) => print('scroll: ${context.point}');
mapboxMap.onMapZoomListener = (context) => print('zoom: ${context.point}');

// After (v3)
void _onMapCreated(MapboxMap mapboxMap) {
  mapboxMap.gestures.pan.gestureEvents.listen((context) {
    print('pan: ${context.point}');
  });
  mapboxMap.gestures.zoom.gestureEvents.listen((context) {
    print('zoom: ${context.point}');
  });
}
```

See `example/lib/gestures_example.dart` for pan, zoom, rotate, and pitch examples with cancellation via `Cancelable`.

### Annotations

#### Annotation click listeners → `tapEvents`

The deprecated `addOn*AnnotationClickListener` methods and `On*AnnotationClickListener` interfaces were removed. Use `tapEvents`:

```dart
// Before (v2)
manager.addOnPointAnnotationClickListener(
  (annotation) => print(annotation.id),
);

// After (v3)
manager.tapEvents(onTap: (annotation) {
  print(annotation.id);
});
```

### Style

#### Style type renames

| v2 | v3 |
|---|---|
| `StyleLayer` | `Layer` |
| `StyleSource` | `Source` |

Layer and source subclasses (`LineLayer`, `GeoJsonSource`, etc.) are unchanged aside from the base class names.

#### `StyleManager.addStyleImage` optional parameters

Optional parameters are now **named**:

```dart
// Before (v2)
await style.addStyleImage(id, width, height, data, sdf, stretchX, stretchY, content);

// After (v3)
await style.addStyleImage(
  id, width, height, data,
  sdf: sdf,
  stretchX: stretchX,
  stretchY: stretchY,
  content: content,
);
```

### Events

#### Resource request event types

Generic event types were renamed to avoid colliding with Dart core types:

| v2 | v3 |
|---|---|
| `Request` | `ResourceRequest` |
| `Response` | `ResourceResponse` |
| `Error` | `ResponseError` |

Update type annotations in `onResourceRequestListener` callbacks.

### Settings & ornaments

#### Settings interface renames

Sub-interfaces on `MapboxMap` now return `*SettingsManager` types. Method names (`getSettings`, `updateSettings`) are the same:

| v2 field type | v3 field type |
|---|---|
| `LocationSettings` | `LocationSettingsManager` |
| `GesturesSettingsInterface` | `GesturesSettingsManager` |
| `CompassSettingsInterface` | `CompassSettingsManager` |
| `ScaleBarSettingsInterface` | `ScaleBarSettingsManager` |
| `AttributionSettingsInterface` | `AttributionSettingsManager` |
| `LogoSettingsInterface` | `LogoSettingsManager` |
| `IndoorSelectorSettingsInterface` | `IndoorSelectorSettingsManager` |

Deprecated typedef aliases (for example `typedef LocationSettings = LocationSettingsManager`) remain on the facade for now, but prefer the `*Manager` names in new code.

### MapboxMap

#### `MapboxMap` no longer extends `ChangeNotifier`

`MapboxMap` no longer implements `Listenable`. It never called `notifyListeners()` in v2, so code that added listeners had no effect. Remove any `Listenable`/`ChangeNotifier` usage on `MapboxMap`.

#### `MapboxMap.fromNativeController` removed

`MapboxMap.fromNativeController` was removed from the public `mapbox_maps_flutter` package. For typical apps, obtain a `MapboxMap` from `MapWidget.onMapCreated`.

If you embed a native map programmatically (for example, a navigation plugin that registers its own `MapView` and exposes the standard Dart API), use the mobile implementation and wrap it in the facade:

```dart
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart'
    as mapbox_mobile;

final impl = mapbox_mobile.MapboxMap.fromNativeController(channelSuffix);
// ignore: invalid_use_of_internal_member
final mapboxMap = MapboxMap(impl);
```

### Debug

#### Debug API rename

Legacy debug types and methods were removed:

| v2 | v3 |
|---|---|
| `MapDebugOptions` / `MapDebugOptionsData` | `MapWidgetDebugOptions` |
| `mapboxMap.getDebug(...)` | `mapboxMap.getDebugOptions(...)` |
| `mapboxMap.setDebug(...)` | `mapboxMap.setDebugOptions(...)` |

---

## No import changes needed

These symbols moved into `mapbox_maps_flutter_platform_interface` internally but are **still exported** from `package:mapbox_maps_flutter/mapbox_maps_flutter.dart`. If you only changed your version constraint, the following continue to work without new imports:

- Core types: `CameraOptions`, `CameraState`, `MapOptions`, `ViewportState` and its subclasses, annotation types, offline types, style enums, event data classes, etc.
- Geometry types from turf: `Point`, `Polygon`, `LineString`, `Position`, etc.
- `MapWidget`, `MapboxMap`, `StyleManager`, annotation managers, viewport transitions

You only need a direct `mapbox_maps_flutter_platform_interface` dependency if you are implementing a custom platform package.

---

## Migration checklist

Use this as a final pass before shipping:

- [ ] Bump `mapbox_maps_flutter` to the latest v3 public preview
- [ ] Upgrade Flutter to ≥ 3.38.1 and Dart to ≥ 3.10.0
- [ ] Replace `cameraOptions` with `viewport` on `MapWidget`
- [ ] Replace `setStateWithViewportAnimation` with `ViewportController`
- [ ] Replace tap/long-tap listeners with `addInteraction`
- [ ] Replace scroll/zoom listeners with `gestures.*.gestureEvents`
- [ ] Replace annotation click listeners with `tapEvents`
- [ ] Update debug API calls (`getDebugOptions` / `setDebugOptions`)
- [ ] Rename `StyleLayer` / `StyleSource` references to `Layer` / `Source`
- [ ] Rename `Request` / `Response` / `Error` in resource callbacks
- [ ] Use named arguments for `addStyleImage` optional parameters
- [ ] Run `flutter analyze` and fix remaining compile errors
- [ ] Test on Android and iOS

## Getting help

- [Example app](./example/) — runnable samples for viewport, gestures, interactions, annotations, offline, and more
- [CHANGELOG](./CHANGELOG.md) — full release notes
- [GitHub issues](https://github.com/mapbox/mapbox-maps-flutter/issues)
