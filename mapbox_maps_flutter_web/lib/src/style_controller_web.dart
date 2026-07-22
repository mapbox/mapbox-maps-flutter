import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:js_interop';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart' show Feature, Point, Position;

import 'bindings/map_bindings.dart';
import 'bindings/style_bindings.dart';
import 'style/expression_operators.dart';

/// Web [StylePlatformInterface] implementation backed by Mapbox GL JS.
final class StyleController implements StylePlatformInterface {
  final JSMap _map;

  StyleController(this._map);

  // ===== Style loading =====

  @override
  Future<void> setStyleURI(String uri) async => _map.setStyle(uri.toJS);

  @override
  Future<String> getStyleURI() =>
      throw UnsupportedError("Style.getStyleURI() is not supported on web");

  @override
  Future<void> setStyleJSON(String json) async =>
      _map.setStyle(jsonParse(json));

  @override
  Future<String> getStyleJSON() async => jsonStringify(_map.getStyle());

  @override
  Future<CameraOptions> getStyleDefaultCamera() async {
    final spec = _map.getStyle();
    final pair = spec.center;
    final point = pair != null
        ? Point(coordinates: Position(pair.lng, pair.lat))
        : null;
    return CameraOptions(
      center: point,
      zoom: spec.zoom,
      bearing: spec.bearing,
      pitch: spec.pitch,
    );
  }

  @override
  Future<bool> isStyleLoaded() async => _map.isStyleLoaded();

  // ===== Transition =====

  @override
  Future<TransitionOptions> getStyleTransition() => throw UnsupportedError(
    "Style.getStyleTransition() is not supported on web",
  );
  @override
  Future<void> setStyleTransition(TransitionOptions transitionOptions) =>
      throw UnsupportedError(
        "Style.setStyleTransition() is not supported on web",
      );

  // ===== Style imports =====

  @override
  Future<void> addStyleImportFromJSON(
    String importId,
    String json, {
    Map<String, Object>? config,
    ImportPosition? importPosition,
  }) async {
    _map.addImport(
      JSImportSpecification(
        id: importId,
        url: '',
        data: jsonParse(json),
        config: config?.jsify(),
      ),
      _resolveBeforeImportId(importPosition),
    );
  }

  @override
  Future<void> addStyleImportFromURI(
    String importId,
    String uri, {
    Map<String, Object>? config,
    ImportPosition? importPosition,
  }) async {
    _map.addImport(
      JSImportSpecification(id: importId, url: uri, config: config?.jsify()),
      _resolveBeforeImportId(importPosition),
    );
  }

  @override
  Future<void> updateStyleImportWithJSON(
    String importId,
    String json, {
    Map<String, Object>? config,
  }) async {
    // gl-js's in-place updateImport keeps the import's old schema;
    // remove+add refreshes it. Capture beforeId and existing config first so
    // the import lands back in the same slot with its config preserved —
    // matching gl-native's documented "merge with existing" semantic.
    final beforeId = _siblingAfterImport(importId);
    final merged = _mergedImportConfig(importId, config);
    _map.removeImport(importId);
    _map.addImport(
      JSImportSpecification(
        id: importId,
        url: '',
        data: jsonParse(json),
        config: merged?.jsify(),
      ),
      beforeId,
    );
  }

  @override
  Future<void> updateStyleImportWithURI(
    String importId,
    String uri, {
    Map<String, Object>? config,
  }) async {
    // gl-js's in-place updateImport keeps the import's old schema;
    // remove+add refreshes it. Capture beforeId and existing config first so
    // the import lands back in the same slot with its config preserved —
    // matching gl-native's documented "merge with existing" semantic.
    final beforeId = _siblingAfterImport(importId);
    final merged = _mergedImportConfig(importId, config);
    _map.removeImport(importId);
    _map.addImport(
      JSImportSpecification(id: importId, url: uri, config: merged?.jsify()),
      beforeId,
    );
  }

  @override
  Future<void> moveStyleImport(
    String importId,
    ImportPosition? importPosition,
  ) async => _map.moveImport(importId, _resolveBeforeImportId(importPosition));

  @override
  Future<void> removeStyleImport(String importId) async =>
      _map.removeImport(importId);

  @override
  Future<Object> getStyleImportSchema(String importId) async {
    final raw = _map.getStyle().imports?.dartify();
    if (raw is List) {
      for (final e in raw) {
        if (e is Map && e['id'] == importId) {
          final data = e['data'];
          if (data is Map && data['schema'] != null) {
            return data['schema'] as Object;
          }
          break;
        }
      }
    }
    final schema = _map.getSchema(importId)?.dartify();
    return schema is Object ? schema : const <String, Object?>{};
  }

  @override
  Future<List<StyleObjectInfo?>> getStyleImports() async => [
    for (final id in _importIds()) StyleObjectInfo(id: id, type: ''),
  ];

  @override
  Future<Map<String, StylePropertyValue>> getStyleImportConfigProperties(
    String importId,
  ) async {
    final raw = _map.getConfig(importId)?.dartify();
    if (raw is! Map) return {};
    return {for (final e in raw.entries) '${e.key}': _wrap(e.value as Object?)};
  }

  @override
  Future<StylePropertyValue> getStyleImportConfigProperty(
    String importId,
    String config,
  ) async => _wrap(_map.getConfigProperty(importId, config)?.dartify());

  @override
  Future<void> setStyleImportConfigProperty(
    String importId,
    String config,
    Object value,
  ) async => _map.setConfigProperty(importId, config, value.jsify());

  @override
  Future<void> setStyleImportConfigProperties(
    String importId,
    Map<String, Object> configs,
  ) async => _map.setConfig(importId, configs.jsify()!);

  // ===== Layers =====

  @override
  Future<void> addStyleLayer(
    String properties,
    LayerPosition? layerPosition,
  ) async {
    _map.addLayer(jsonParse(properties), _resolveBeforeId(layerPosition));
  }

  @override
  Future<void> addPersistentStyleLayer(
    String properties,
    LayerPosition? layerPosition,
  ) async {
    // 1000 == `package:logging` SEVERE; gl-js has no persistent-layer
    // concept, so we degrade to a regular layer and emit a console warning.
    log(
      "Style.addPersistentStyleLayer() is not supported on web, adding as a regular layer",
      level: 1000,
    );
    return addStyleLayer(properties, layerPosition);
  }

  @override
  Future<bool> isStyleLayerPersistent(String layerId) async => false;

  @override
  Future<void> removeStyleLayer(String layerId) async =>
      _map.removeLayer(layerId);

  @override
  Future<bool> styleLayerExists(String layerId) async =>
      _map.getLayer(layerId) != null;

  @override
  Future<void> moveStyleLayer(
    String layerId,
    LayerPosition? layerPosition,
  ) async => _map.moveLayer(layerId, _resolveBeforeId(layerPosition));

  @override
  Future<List<StyleObjectInfo?>> getStyleLayers() async {
    final layers = _map.getStyle().layers?.toDart ?? const <JSLayer>[];
    return [for (final l in layers) StyleObjectInfo(id: l.id, type: l.type)];
  }

  @override
  Future<StylePropertyValue> getStyleLayerProperty(
    String layerId,
    String property,
  ) async {
    final dart = _map.getLayer(layerId)?.dartify();
    if (dart is! Map) {
      return StylePropertyValue(
        value: null,
        kind: StylePropertyValueKind.UNDEFINED,
      );
    }
    final spec = _normalizeColors(dart) as Map;
    final value =
        spec[property] ??
        (spec['paint'] is Map ? spec['paint'][property] : null) ??
        (spec['layout'] is Map ? spec['layout'][property] : null);
    return _wrap(value);
  }

  @override
  Future<void> setStyleLayerProperty(
    String layerId,
    String property,
    Object value,
  ) async {
    // TODO(roman.laitarenko): replace with a single setLayerProperty call when it is availabe in GL JS
    if (property == 'filter') {
      _map.setFilter(layerId, value.jsify());
      return;
    }
    if (property == 'minzoom') {
      _map.setLayerZoomRange(layerId, (value as num).toDouble(), null);
      return;
    }

    if (property == 'maxzoom') {
      _map.setLayerZoomRange(layerId, null, (value as num).toDouble());
      return;
    }

    final jsValue = value.jsify();
    if (kLayoutPropertyNames.contains(property)) {
      _map.setLayoutProperty(layerId, property, jsValue);
    } else {
      _map.setPaintProperty(layerId, property, jsValue);
    }
  }

  @override
  Future<String> getStyleLayerProperties(String layerId) async {
    final dart = _map.getLayer(layerId)?.dartify();
    if (dart is! Map) return '{}';
    return jsonEncode(_normalizeColors(dart) as Map);
  }

  @override
  Future<void> setStyleLayerProperties(
    String layerId,
    String properties,
  ) async {
    final parsed = jsonDecode(properties);
    if (parsed is! Map) return;
    for (final entry in parsed.entries) {
      final name = entry.key.toString();
      final value = entry.value as Object?;
      if (value == null) continue;
      await setStyleLayerProperty(layerId, name, value);
    }
  }

  // ===== Sources =====

  @override
  Future<void> addStyleSource(String sourceId, String properties) async {
    // The platform-interface source serializer bakes `id` into the JSON;
    // gl-js's `addSource(id, spec)` takes id as a separate arg and warns
    // ("sources.<id>: unknown property 'id'") — and fires a null-payload
    // error event that surfaces as a stray `null` in the browser console.
    // Strip it before handoff. Static `Object` typing so `.jsify()`
    // dispatches as an extension instead of via dynamic lookup.
    final Object spec = jsonDecode(properties);
    if (spec is Map) {
      spec.remove('id');
      // The platform-interface GeoJsonSource serializes `data` as a JSON-
      // encoded string (e.g. `'{"type":"FeatureCollection",...}'`). gl-js
      // treats a string `data` as a URL and fetches it, which 404s and
      // hits the dev-server SPA fallback (returns index.html); the model
      // sample above is the canonical reproducer. Parse the string back
      // into an object so gl-js takes the inline FeatureCollection path.
      if (spec['type'] == 'geojson') {
        // The facade's `GeoJsonSource.addToStyle` clears `_data` to `""`
        // before the non-volatile encode (it pushes the real payload via
        // `updateGeoJSON` afterwards), so `data` arrives here as either
        // null, an empty string, or — for a few code paths that bypass
        // that split — a JSON-encoded object literal. gl-js treats any
        // string `data` as a URL and fetches it, which on an empty/missing
        // URL hits the dev-server SPA fallback (returns index.html) and
        // surfaces as `Unexpected token '<'`. Seed with an empty
        // FeatureCollection for missing/empty data, or parse the JSON
        // string back into an object so gl-js takes the inline path.
        final data = spec['data'];
        if (data == null || (data is String && data.trimLeft().isEmpty)) {
          spec['data'] = const {'type': 'FeatureCollection', 'features': []};
        } else if (data is String) {
          final trimmed = data.trimLeft();
          if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
            spec['data'] = jsonDecode(data);
          }
        }
      } else if (spec['type'] == 'model') {
        // TODO(O-hannonen): Remove once GLJS supports `model-color` as defined by
        // the color type: https://docs.mapbox.com/style-spec/reference/types/#color
        _forEachModelColor(spec, (override, modelColor) {
          if (modelColor is! String) return;
          final array = _rgbaStringToUnitArray(modelColor);
          if (array != null) override['model-color'] = array;
        });
      }
    }
    _map.addSource(sourceId, spec.jsify()!);
  }

  @override
  Future<void> removeStyleSource(String sourceId) async =>
      _map.removeSource(sourceId);

  @override
  Future<bool> styleSourceExists(String sourceId) async =>
      _map.getSource(sourceId) != null;

  @override
  Future<List<StyleObjectInfo?>> getStyleSources() async {
    final dart = _map.getStyle().sources?.dartify();
    if (dart is! Map) return const [];
    return [
      for (final entry in dart.entries)
        StyleObjectInfo(
          id: '${entry.key}',
          type:
              (entry.value is Map ? entry.value['type'] : '')?.toString() ?? '',
        ),
    ];
  }

  @override
  Future<String> getStyleSourceProperties(String sourceId) async {
    final source = _map.getSource(sourceId)?.serialize().dartify();
    if (source is! Map) return '{}';
    return jsonEncode(_denormalizeModelSourceColors(source));
  }

  @override
  Future<StylePropertyValue> getStyleSourceProperty(
    String sourceId,
    String property,
  ) async {
    final source = _map.getSource(sourceId)?.serialize().dartify();
    if (source is! Map) {
      return StylePropertyValue(
        value: null,
        kind: StylePropertyValueKind.UNDEFINED,
      );
    }
    return _wrap(_denormalizeModelSourceColors(source)[property]);
  }

  Map<String, dynamic> _denormalizeModelSourceColors(Map source) {
    // TODO(O-hannonen): Remove this `if` block once GLJS supports
    // `model-color` as defined by the color type:
    // https://docs.mapbox.com/style-spec/reference/types/#color
    if (source['type'] == 'model') {
      _forEachModelColor(source, (override, modelColor) {
        if (modelColor is List && modelColor.length >= 3) {
          override['model-color'] = _unitArrayToRgbaString(modelColor);
        }
      });
    }
    return source.cast<String, dynamic>();
  }

  // TODO(O-hannonen): Remove once GLJS supports `model-color` as defined by
  // the color type: https://docs.mapbox.com/style-spec/reference/types/#color
  void _forEachModelColor(
    Map spec,
    void Function(Map override, Object? modelColor) visit,
  ) {
    final models = spec['models'];
    if (models is! Map) return;
    for (final model in models.values) {
      if (model is! Map) continue;
      final materialOverrides = model['materialOverrides'];
      if (materialOverrides is! Map) continue;
      for (final override in materialOverrides.values) {
        if (override is! Map) continue;
        if (!override.containsKey('model-color')) continue;
        visit(override, override['model-color']);
      }
    }
  }

  @override
  Future<void> setStyleSourceProperty(
    String sourceId,
    String property,
    Object value,
  ) async {
    final source = _map.getSource(sourceId);
    if (source == null) {
      throw StateError('Style source "$sourceId" not found.');
    }
    final type = source.type;
    if (type == 'geojson' && property == 'data') {
      // The platform interface ships GeoJSON `data` as a Dart String. gl-js
      // accepts either a URL string or a parsed FeatureCollection / Feature
      // object — if we pass the raw JSON string through `setData`, gl-js
      // treats it as a URL and fails with a fetch error. Detect a JSON
      // payload by the leading character and feed gl-js the parsed object.
      Object payload = value;
      if (value is String) {
        final trimmed = value.trimLeft();
        if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
          payload = jsonDecode(value) as Object;
        }
      }
      (source as JSGeoJSONSource).setData(payload.jsify()!);
      return;
    }
    if (type == 'image' && (property == 'url' || property == 'coordinates')) {
      final imageSource = source as JSImageSource;
      if (property == 'url') {
        imageSource.updateImage(
          JSImageSourceUpdateOptions(url: value as String),
        );
      } else {
        // gl-js requires `url` on every updateImage call; pass the source's
        // current url through unchanged so the engine treats this as a
        // coordinates-only update.
        final coords = [
          for (final pair in value as List)
            JSLngLatPair(
              ((pair as List)[0] as num).toDouble(),
              (pair[1] as num).toDouble(),
            ),
        ].toJS;
        imageSource.updateImage(
          JSImageSourceUpdateOptions(url: imageSource.url, coordinates: coords),
        );
      }
      return;
    }

    if (type == 'raster' || type == 'vector') {
      final tileSource = source as JSRasterTileSource;
      if (property == 'tiles') {
        tileSource.setTiles(value.jsify()!);
        return;
      }
      if (property == 'url') {
        tileSource.setUrl((value as String).toJS);
        return;
      }
    }

    throw _ni('setStyleSourceProperty($property) on source type "$type"');
  }

  @override
  Future<void> setStyleSourceProperties(
    String sourceId,
    String properties,
  ) async {
    final parsed = jsonDecode(properties);
    if (parsed is! Map) return;
    // gl-js only exposes live setters for `data` / `url` / `tiles` /
    // `coordinates`; the rest of the source spec is fixed at addSource time.
    // Callers (e.g. the generated source update tests) hand in the full
    // spec, so skip keys the singular setter doesn't handle instead of
    // erroring out on the first immutable property.
    for (final entry in parsed.entries) {
      final name = entry.key.toString();
      final value = entry.value as Object?;
      if (value == null) continue;
      try {
        await setStyleSourceProperty(sourceId, name, value);
      } on UnimplementedError catch (e) {
        // Property has no live setter on gl-js — write-once at addSource.
        log('setStyleSourceProperties: skipping "$name" — $e');
      }
    }
  }

  // ===== GeoJSON partial updates =====
  //
  // GL JS's `GeoJSONSource.updateData` merges by feature id. The mobile
  // `dataId` ticketing scheme has no gl-js analogue; we drop it and let
  // gl-js coalesce updates internally. Source must be declared with
  // `dynamic: true` to accept these calls.
  //
  // Feature ids must be numeric (or numeric strings) for this merge — and
  // for feature state and querySourceFeatures/queryRenderedFeatures id
  // round-tripping in general — because GL JS re-encodes GeoJSON data into
  // real vector-tile PBF buffers internally, and the vector tile spec only
  // supports integer feature ids. Non-numeric ids are silently dropped at
  // that step. This is a GL JS platform limitation, not specific to this
  // plugin.

  @override
  Future<void> addGeoJSONSourceFeatures(
    String sourceId,
    String dataId,
    List<Feature> features,
  ) async => _updateGeoJSON(sourceId, features.map((f) => f.toJson()).toList());

  @override
  Future<void> updateGeoJSONSourceFeatures(
    String sourceId,
    String dataId,
    List<Feature> features,
  ) async => _updateGeoJSON(sourceId, features.map((f) => f.toJson()).toList());

  @override
  Future<void> removeGeoJSONSourceFeatures(
    String sourceId,
    String dataId,
    List<String> featureIds,
  ) async => _updateGeoJSON(sourceId, [
    for (final id in featureIds)
      {'type': 'Feature', 'id': id, 'geometry': null},
  ]);

  void _updateGeoJSON(String sourceId, List<Map<String, dynamic>> features) {
    final source = _map.getSource(sourceId);
    if (source == null || source.type != 'geojson') {
      throw StateError('GeoJSON source "$sourceId" not found.');
    }
    final fc = {'type': 'FeatureCollection', 'features': features};
    (source as JSGeoJSONSource).updateData(fc.jsify()!);
  }

  // ===== Images =====

  @override
  Future<bool> hasStyleImage(String imageId) async =>
      throw _ni('hasStyleImage');

  @override
  Future<void> removeStyleImage(String imageId) async =>
      throw _ni('removeStyleImage');

  @override
  Future<void> addStyleImage(
    String imageId,
    double scale,
    MbxImage image,
    bool sdf,
    List<ImageStretches?> stretchX,
    List<ImageStretches?> stretchY,
    ImageContent? content,
  ) async => throw _ni('addStyleImage');

  @override
  Future<void> updateStyleImageSourceImage(String sourceId, MbxImage image) =>
      throw _ni('updateStyleImageSourceImage');

  @override
  Future<MbxImage?> getStyleImage(String imageId) => throw _ni('getStyleImage');

  // ===== Models =====

  @override
  Future<void> addStyleModel(String modelId, String modelUri) async {
    // Callers commonly pass `asset://assets/foo.glb`; gl-js will try to
    // fetch that scheme verbatim and fail. Route through the same Flutter-
    // asset resolver MapboxMapsFlutter.getFlutterAssetPath uses so the URI
    // ends up as a relative path gl-js can fetch from the deployed host.
    final resolved = await MapboxMapsFlutterPlatform.instance.mapboxMapsOptions
        .getFlutterAssetPath(modelUri);
    _map.addModel(modelId, resolved ?? modelUri);
  }

  @override
  Future<void> removeStyleModel(String modelId) async =>
      _map.removeModel(modelId);

  // ===== Lights =====
  //
  // GL JS replaced the flat-light API with a single `setLights([...])`
  // array. Mapping the platform-interface FlatLight / Ambient + Directional
  // shapes into that array is web-parity follow-up work.

  @override
  Future<List<StyleObjectInfo?>> getStyleLights() =>
      throw _ni('getStyleLights');

  @override
  Future<void> setLight(FlatLight flatLight) => throw _ni('setLight');
  @override
  Future<void> setLights(
    AmbientLight ambientLight,
    DirectionalLight directionalLight,
  ) => throw _ni('setLights');
  @override
  Future<StylePropertyValue> getStyleLightProperty(
    String id,
    String property,
  ) => throw _ni('getStyleLightProperty');
  @override
  Future<void> setStyleLightProperty(
    String id,
    String property,
    Object value,
  ) => throw _ni('setStyleLightProperty');

  // ===== Terrain =====

  @override
  Future<void> setStyleTerrain(String properties) async =>
      throw _ni('setStyleTerrain');

  @override
  Future<StylePropertyValue> getStyleTerrainProperty(String property) async =>
      throw _ni('getStyleTerrainProperty');

  @override
  Future<void> setStyleTerrainProperty(String property, Object value) async =>
      throw _ni('setStyleTerrainProperty');

  // ===== Projection =====

  @override
  Future<StyleProjection?> getProjection() async => throw _ni('getProjection');

  @override
  Future<void> setProjection(StyleProjection projection) async =>
      throw _ni('setProjection');

  // ===== Custom geometry sources =====

  @override
  Future<void> invalidateStyleCustomGeometrySourceTile(
    String sourceId,
    CanonicalTileID tileId,
  ) => throw _ni('invalidateStyleCustomGeometrySourceTile');
  @override
  Future<void> invalidateStyleCustomGeometrySourceRegion(
    String sourceId,
    CoordinateBounds bounds,
  ) => throw _ni('invalidateStyleCustomGeometrySourceRegion');

  // ===== Misc =====

  @override
  Future<void> localizeLabels(String locale, List<String>? layerIds) =>
      throw _ni('localizeLabels');

  @override
  Future<List<FeaturesetDescriptor>> getFeaturesets() =>
      throw _ni('getFeaturesets');

  // ===== Helpers =====

  /// Resolves a [LayerPosition] to gl-js's `beforeId` argument. Mirrors
  /// gl-native's `above` → `below` → `at` precedence so the misuse case
  /// (multiple fields set) behaves identically across platforms.
  String? _resolveBeforeId(LayerPosition? position) {
    if (position == null) return null;
    final layers = _map.getStyle().layers?.toDart ?? const <JSLayer>[];
    if (position.above != null) {
      final index = layers.indexWhere((l) => l.id == position.above);
      if (index == -1) {
        return null;
      }
      return index + 1 < layers.length ? layers[index + 1].id : null;
    }
    if (position.below != null) return position.below;
    if (position.at != null) {
      final at = position.at!;
      if (at >= 0 && at < layers.length) return layers[at].id;
    }
    return null;
  }

  String? _resolveBeforeImportId(ImportPosition? position) {
    if (position == null) return null;
    final ids = _importIds();
    if (position.above != null) {
      final i = ids.indexOf(position.above!);
      if (i == -1) return null;
      return i + 1 < ids.length ? ids[i + 1] : null;
    }
    if (position.below != null) return position.below;
    if (position.at != null) {
      final at = position.at!;
      if (at >= 0 && at < ids.length) return ids[at];
    }
    return null;
  }

  List<String> _importIds() {
    final raw = _map.getStyle().imports?.dartify();
    if (raw is! List) return const [];
    return [
      for (final e in raw)
        if (e is Map && e['id'] is String) e['id'] as String,
    ];
  }

  /// Id of the import that follows [importId] in the current order — the
  /// `beforeImportId` value `addImport` needs to re-insert at the same slot
  /// after a remove. Null when [importId] is missing or already last.
  String? _siblingAfterImport(String importId) {
    final ids = _importIds();
    final i = ids.indexOf(importId);
    return (i >= 0 && i + 1 < ids.length) ? ids[i + 1] : null;
  }

  /// Merges [importId]'s current config (as reported by gl-js) with the
  /// caller-supplied [overrides], with the overrides winning on key
  /// collisions. Used by `updateStyleImportWith*` to preserve existing
  /// config across the remove+add emulation, matching gl-native's documented
  /// merge semantics. Returns null when the resulting map would be empty so
  /// the binding omits the `config` field on the import spec — gl-js may
  /// otherwise treat an explicit `{}` as a reset.
  Map<String, Object>? _mergedImportConfig(
    String importId,
    Map<String, Object>? overrides,
  ) {
    final existing = _map.getConfig(importId)?.dartify();
    final merged = <String, Object>{};
    if (existing is Map) {
      for (final entry in existing.entries) {
        final value = entry.value;
        if (value is Object) merged['${entry.key}'] = value;
      }
    }
    if (overrides != null) merged.addAll(overrides);
    return merged.isEmpty ? null : merged;
  }

  /// Wraps an already-dartified value into a [StylePropertyValue]. The
  /// receiver is intentionally typed `Object?` rather than `dynamic` so the
  /// extension-method dispatch inside the function resolves statically;
  /// callers that hand in a `dynamic` from a `Map<dynamic, dynamic>` get
  /// the implicit-cast for free.
  StylePropertyValue _wrap(Object? value) {
    if (value == null) {
      return StylePropertyValue(
        value: null,
        kind: StylePropertyValueKind.UNDEFINED,
      );
    }
    // A list is only an expression if its head is one of the style-spec
    // expression operators; otherwise it's a constant (e.g. a numeric pair
    // like [x, y] for *-translate, or a list of font names for text-font).
    final kind =
        (value is List &&
            value.isNotEmpty &&
            value.first is String &&
            expressionOperators.contains(value.first))
        ? StylePropertyValueKind.EXPRESSION
        : StylePropertyValueKind.CONSTANT;
    return StylePropertyValue(value: value, kind: kind);
  }

  /// Match `rgb(r, g, b)` and `rgba(r, g, b, a)`. Components allow
  /// integers and decimals to accommodate gl-js's variable output format.
  static final _rgbaPattern = RegExp(
    r'^rgba?\(\s*([\d.]+)\s*,\s*([\d.]+)\s*,\s*([\d.]+)(?:\s*,\s*([\d.]+))?\s*\)$',
  );

  // TODO(O-hannonen): Remove once GLJS supports `model-color` as defined by
  // the color type: https://docs.mapbox.com/style-spec/reference/types/#color
  List<num>? _rgbaStringToUnitArray(String value) {
    final m = _rgbaPattern.firstMatch(value);
    if (m == null) return null;
    return [
      num.parse(m.group(1)!) / 255,
      num.parse(m.group(2)!) / 255,
      num.parse(m.group(3)!) / 255,
    ];
  }

  // TODO(O-hannonen): Remove once GLJS supports `model-color` as defined by
  // the color type: https://docs.mapbox.com/style-spec/reference/types/#color
  String _unitArrayToRgbaString(List modelColor) {
    final r = ((modelColor[0] as num) * 255).round();
    final g = ((modelColor[1] as num) * 255).round();
    final b = ((modelColor[2] as num) * 255).round();
    return 'rgba($r, $g, $b, 1)';
  }

  /// Walk a serialized spec and rewrite values into the shape the generated
  /// layer deserializers expect:
  ///   * `"rgba(r, g, b, a)"` / `"rgb(r, g, b)"` → `["rgba"/"rgb", …]` lists
  ///     (gl-js returns colors as CSS strings; mobile returns them as
  ///     spec lists, which `toRGBAInt` consumes.)
  ///   * `["string", X]` / `["number", X]` / `["boolean", X]` /
  ///     `["literal", X]` → `X` — gl-native silently evaluates these
  ///     "no-op" expressions before serializing; matching that here lets
  ///     deserializers that treat the slot as a constant (e.g. visibility-
  ///     as-enum) round-trip identically to mobile.
  /// Only descends through Maps. Lists are kept opaque so non-trivial
  /// expressions (`["interpolate", …]`, `["get", …]`, …) survive verbatim.
  Object? _normalizeColors(Object? value) {
    if (value is String) {
      final m = _rgbaPattern.firstMatch(value);
      if (m == null) return value;
      final r = num.parse(m.group(1)!);
      final g = num.parse(m.group(2)!);
      final b = num.parse(m.group(3)!);
      final a = m.group(4);
      return a == null
          ? <Object>['rgb', r, g, b]
          : <Object>['rgba', r, g, b, num.parse(a)];
    }
    if (value is List &&
        value.length == 2 &&
        const {
          'string',
          'number',
          'boolean',
          'literal',
        }.contains(value.first)) {
      return value[1];
    }
    if (value is List &&
        value.length == 3 &&
        value.first == '==' &&
        _isLiteralPrimitive(value[1]) &&
        _isLiteralPrimitive(value[2])) {
      // gl-native evaluates trivial constant comparisons before serializing
      // (e.g. `["==", true, true]` → `true`), so the layer deserializer's
      // plain-bool getter sees a literal. gl-js stores the array verbatim;
      // mirror gl-native's evaluation here when both sides are literals.
      return value[1] == value[2];
    }
    if (value is Map) {
      return <String, Object?>{
        for (final entry in value.entries)
          '${entry.key}': _normalizeLayerEntry(
            '${entry.key}',
            _normalizeColors(entry.value),
          ),
      };
    }
    return value;
  }

  /// Returns true for values that can stand on their own as a style property
  /// constant: numbers, strings, booleans, and null. Used to spot trivial
  /// constant expressions like `["==", true, true]` that gl-native folds
  /// away during serialize.
  static bool _isLiteralPrimitive(Object? value) =>
      value == null || value is num || value is String || value is bool;

  /// Per-property fixups that run after the generic walker. Currently:
  ///   * `text-field` — gl-native serializes plain string text as the
  ///     `["format", "...", {}]` expression form (the only shape the layer
  ///     deserializer's `textFieldExpression` getter recognizes). gl-js
  ///     keeps the original string; mirror gl-native's wrap here so the
  ///     mobile contract round-trips.
  Object? _normalizeLayerEntry(String key, Object? value) {
    if (key == 'text-field' && value is String) {
      return <Object>['format', value, <String, Object?>{}];
    }
    return value;
  }
}

UnimplementedError _ni(String method) =>
    UnimplementedError('Style.$method is not yet implemented on web.');
