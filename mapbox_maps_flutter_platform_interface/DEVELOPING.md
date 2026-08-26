# Developing mapbox_maps_flutter_platform_interface

This package holds the shared interfaces and data types used by every
package in the federated Flutter plugin.

## Folders under `lib/src/`

- `public/` — App-facing data and support types.
- `pigeons/` — Codegen output shared across the platform boundary.
- `interfaces/` — The `*PlatformInterface` contracts that platform
  implementation packages (`mapbox_maps_flutter_mobile`,
  `mapbox_maps_flutter_web`) must implement.
- `internal/` — Platform-registration plumbing for the federated plugin.

## The two barrel files

- `mapbox_maps_flutter_platform_interface.dart` — the public API of this
  package. Exports everything under `public/` and `pigeons/`. This is what
  `package:mapbox_maps_flutter` re-exports to app developers.
- `mapbox_maps_flutter_platform_interface_internal.dart` — the full API of
  this package. Re-exports the public barrel above, plus everything under
  `interfaces/` and `internal/`. Platform implementation packages (mobile,
  web) import this file instead of the public barrel.
