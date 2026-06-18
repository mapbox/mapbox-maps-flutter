### 3.0.0-alpha.1

* iOS and Android implementation of the Mapbox Maps Flutter plugin, endorsed by `mapbox_maps_flutter`.
* [iOS] Fix iOS compass ignoring `CompassSettings.fadeWhenFacingNorth` (and visibility in general) unless `enabled` was also set. `enabled` and `fadeWhenFacingNorth` are now applied independently, matching the Android behaviour ([#602](https://github.com/mapbox/mapbox-maps-flutter/issues/602)).
* [Android] Use flutter.compileSdkVersion to align Android compileSdk with Flutter SDK
