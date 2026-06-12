### main

* Add `MapboxMap.httpService.setMaxRequestsPerHost` to cap the number of concurrent HTTP requests per host issued by the underlying HTTP service. Useful for reducing the chance of hitting per-token rate limits during offline tile region downloads.
* [iOS] Fix iOS compass ignoring `CompassSettings.fadeWhenFacingNorth` (and visibility in general) unless `enabled` was also set. `enabled` and `fadeWhenFacingNorth` are now applied independently, matching the Android behaviour ([#602](https://github.com/mapbox/mapbox-maps-flutter/issues/602)).

### 3.0.0-beta.1
