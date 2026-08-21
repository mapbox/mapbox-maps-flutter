# mapbox_maps_flutter

Official [Mapbox](https://www.mapbox.com/maps) Maps SDK for Flutter. Add a `MapWidget` to your app. It renders native, GPU-accelerated, cross-platform maps on Android, iOS, and Web. It builds maps from Mapbox Vector Tiles (MVT), GeoJSON, and other data sources. Use a ready-made style, such as Standard, Satellite, or Streets. Or use your own custom style, with layer types such as circle, line, fill, raster, heatmap, hillshade, sky, and 3D fill-extrusion. Add map markers and other annotations, with marker clustering for large datasets. Show a live location puck, and control the camera with gestures. Listen for map, camera, and style events. On Android and iOS, you can also cache maps for offline use and take a map snapshot.

This is the app-facing plugin package. It endorses:

- [`mapbox_maps_flutter_mobile`](../mapbox_maps_flutter_mobile) for Android and iOS.
- [`mapbox_maps_flutter_web`](../mapbox_maps_flutter_web) for Web.

## Requirements

- Flutter 3.38.1 / Dart 3.10.0 or higher
- Android: minSdk 21 or higher
- iOS: 14 or higher
- Web: Mapbox GL JS 3.29.0

## Installation

### 1. Add the dependency

```yaml
dependencies:
  mapbox_maps_flutter: ^3.0.0-alpha.29
```

Then run `flutter pub get`.

### 2. Configure your access token

Set a Mapbox access token once at app startup, before creating any `MapWidget`:

```dart
import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(const String.fromEnvironment('ACCESS_TOKEN'));
  runApp(const MyApp());
}
```

Pass the token via `--dart-define`:

```
flutter run --dart-define=ACCESS_TOKEN=<your token>
```

See the [access token docs](https://docs.mapbox.com/help/getting-started/access-tokens/) for how to provision tokens and scopes.

### 3. Platform setup

**Android** — add to `android/app/src/main/AndroidManifest.xml` if you use the location component:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

**iOS** — add to `ios/Runner/Info.plist` if you use the location component:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Explain why your app needs location access.</string>
```

**Web** — no setup needed: Mapbox GL JS is loaded automatically. If your app has a strict Content-Security-Policy, allow script/style sources from `api.mapbox.com`.

### 4. Add a map

```dart
import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapWidget();
  }
}
```

For the full API surface — camera, gestures, styles, sources and layers, annotations, viewport, location component — see the platform package READMEs linked above.

## Migrating from v2

If you are upgrading from mapbox_maps_flutter v2.x, see the [v3 migration guide](./MIGRATION.md).
