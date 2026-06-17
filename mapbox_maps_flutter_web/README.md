# mapbox_maps_flutter_web

The web platform implementation of the `mapbox_maps_flutter` plugin, powered by Mapbox GL JS.

## Minimum Mapbox GL JS version

This package targets **Mapbox GL JS v3.25.0 or newer**. Load it from `web/index.html`:

```html
<link href='https://api.mapbox.com/mapbox-gl-js/v3.25.0/mapbox-gl.css' rel='stylesheet' />
<script src='https://api.mapbox.com/mapbox-gl-js/v3.25.0/mapbox-gl.js'></script>
```

Older versions are missing options the package relies on (e.g. `GeolocateControl.showButton`, added in v3.18.0 and used by the location component).
