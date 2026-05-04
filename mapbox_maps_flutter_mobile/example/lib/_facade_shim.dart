// WS1 patch — DELETE IN WS4 when the example app migrates to the facade.
//
// In WS1 the typed style layer/source classes plus their `addLayer`/
// `addSource`/`getLayer`/`getSource` helpers moved from
// `mapbox_maps_flutter_mobile` into the federated facade
// `mapbox_maps_flutter`. The example files in this directory still target
// mobile, so this file re-exports the relocated types and re-attaches the
// typed style helpers on mobile's Pigeon `StyleManager` via an extension
// that wraps it in a facade `StyleManager` on demand.
//
// To remove: WS4 moves `lib/*.dart` to `packages/mapbox_maps_flutter/example/lib/`
// and switches imports to the facade directly. At that point delete this
// file, the `import '_facade_shim.dart';` lines from each example, and
// the `mapbox_maps_flutter` dep added to this example's pubspec.yaml.

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mbx;
import 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

export 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart'
    show
        // Layer hierarchy
        Layer,
        BackgroundLayer,
        CircleLayer,
        ClipLayer,
        FillExtrusionLayer,
        FillLayer,
        HeatmapLayer,
        HillshadeLayer,
        LineLayer,
        LocationIndicatorLayer,
        ModelLayer,
        RasterLayer,
        RasterParticleLayer,
        SkyLayer,
        SlotLayer,
        SymbolLayer,
        // Source hierarchy
        Source,
        GeoJsonSource,
        ImageSource,
        RasterArraySource,
        RasterDemSource,
        RasterSource,
        VectorSource,
        // Hand-written style types lifted from mobile/src/style/style.dart
        Visibility,
        TileCacheBudget,
        TileCacheBudgetType,
        RasterDataLayer,
        StyleTransition,
        LayerSlot,
        // Codegen-emitted enums (generated_enums.dart) used by examples
        Scheme,
        Encoding,
        ModelType,
        SkyType,
        RasterResampling,
        HillshadeIlluminationAnchor,
        FillExtrusionTranslateAnchor;

/// Restores the typed style helpers (`addLayer`/`addSource`/`getLayer`/
/// `getSource`/`updateLayer`/`updateSource`/`addPersistentLayer`)
/// that pre-WS1 lived directly on mobile's
/// `StyleManager` via the (now-deleted) `StyleLayer` and `StyleSource`
/// extensions. Implemented by wrapping `this` (the mobile Pigeon
/// `StyleManager`, which `implements StylePlatformInterface`) in a facade
/// `StyleManager` on every call.
extension StyleManagerWS1CompatShim on StyleManager {
  Future<void> addLayer(mbx.Layer layer) =>
      mbx.StyleManager(this).addLayer(layer);

  Future<void> addPersistentLayer(mbx.Layer layer) =>
      mbx.StyleManager(this).addPersistentLayer(layer);

  Future<void> updateLayer(mbx.Layer layer) =>
      mbx.StyleManager(this).updateLayer(layer);

  Future<mbx.Layer?> getLayer(String layerId) =>
      mbx.StyleManager(this).getLayer(layerId);

  Future<void> addSource(mbx.Source source) =>
      mbx.StyleManager(this).addSource(source);

  Future<void> updateSource(mbx.Source source) =>
      mbx.StyleManager(this).updateSource(source);

  Future<mbx.Source?> getSource(String sourceId) =>
      mbx.StyleManager(this).getSource(sourceId);
}
