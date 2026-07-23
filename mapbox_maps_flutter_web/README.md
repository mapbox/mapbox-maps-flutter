# mapbox_maps_flutter_web

The web platform implementation of the `mapbox_maps_flutter` plugin, powered by Mapbox GL JS.

## Mapbox GL JS version

This package loads **Mapbox GL JS v3.27.0-rc.1** from the Mapbox CDN at runtime, injecting the `<script>`/`<link>` tags into the page automatically on first use.

If your app has a strict Content-Security-Policy, allow script/style sources from `api.mapbox.com`.
