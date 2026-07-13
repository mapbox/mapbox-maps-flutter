import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../empty_map_widget.dart' as app;

/// A minimal inline style fragment used for addStyleImportFromJSON /
/// updateStyleImportWithJSON tests.  No assets needed.
const _inlineFragmentJson = '''
{
  "version": 8,
  "sources": {},
  "layers": [
    {
      "id": "background-test",
      "type": "background",
      "paint": {"background-color": "#abcdef"}
    }
  ]
}
''';

/// Inline fragment that declares a `schema` so config writes have a
/// landing spot. Used by add/update+config tests so the supplied config
/// can be round-tripped via `getStyleImportConfigProperty`.
const _inlineFragmentWithSchemaJson = '''
{
  "version": 8,
  "schema": {
    "testColor": {
      "type": "string",
      "default": "#aabbcc"
    }
  },
  "sources": {},
  "layers": [
    {
      "id": "background-test",
      "type": "background",
      "paint": {"background-color": "#abcdef"}
    }
  ]
}
''';

/// Pair of schema-bearing fragments used by the update suite. They share
/// `testColor` so the existing config round-trip stays meaningful, and
/// each carries a unique schema marker (`beforeMarker` / `afterMarker`)
/// so a successful update is observable through `getStyleImportSchema`.
const _inlineFragmentBeforeJson = '''
{
  "version": 8,
  "schema": {
    "testColor": {"type": "string", "default": "#aabbcc"},
    "beforeMarker": {"type": "string", "default": "before"}
  },
  "sources": {},
  "layers": [
    {
      "id": "background-test",
      "type": "background",
      "paint": {"background-color": "#abcdef"}
    }
  ]
}
''';

const _inlineFragmentAfterJson = '''
{
  "version": 8,
  "schema": {
    "testColor": {"type": "string", "default": "#aabbcc"},
    "afterMarker": {"type": "string", "default": "after"}
  },
  "sources": {},
  "layers": [
    {
      "id": "background-test",
      "type": "background",
      "paint": {"background-color": "#abcdef"}
    }
  ]
}
''';

/// Helper: mount the map widget and wait for the style to finish loading.
/// pumpAndSettle alone is not enough on web — gl-js's style load is async
/// and `getStyle()` throws "Style is not done loading" until `style.load`
/// fires. Await the harness's onStyleLoaded completer instead.
Future<MapboxMap> _setupMap(
  WidgetTester tester, [
  String styleURI = MapboxStyles.STANDARD,
]) async {
  final mapFuture = app.main(styleUri: styleURI);
  await tester.pumpAndSettle();
  final mapboxMap = await mapFuture;
  if (!app.events.onStyleLoaded.isCompleted) {
    await app.events.onMapLoaded.future;
  }
  return mapboxMap;
}

/// Helper: mount the map and ensure STANDARD is loaded (provides the
/// `basemap` import). `getStyleURI` is unimplemented on web so we can't
/// short-circuit when STANDARD is already loaded; issue the reload
/// unconditionally and wait on `onStyleLoaded`.
Future<MapboxMap> _setupMapWithStandard(WidgetTester tester) async {
  final mapboxMap = await _setupMap(tester);
  app.events.resetOnStyleLoaded();
  await mapboxMap.loadStyleURI(MapboxStyles.STANDARD);
  await app.events.onStyleLoaded.future;
  await tester.pumpAndSettle();
  return mapboxMap;
}

/// Return the list of non-null import ids from getStyleImports().
Future<List<String>> _importIds(MapboxMap mapboxMap) async {
  final imports = await mapboxMap.style.getStyleImports();
  return imports.whereType<StyleObjectInfo>().map((e) => e.id).toList();
}

/// Poll `getStyleImportSchema` until [key] appears in the schema. URL-loaded
/// imports populate their schema asynchronously after the fetch completes;
/// `pumpAndSettle` doesn't wait on HTTP, so we poll explicitly.
Future<void> _waitForImportSchemaKey(
  MapboxMap mapboxMap,
  String importId,
  String key, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    final schema = await mapboxMap.style.getStyleImportSchema(importId);
    if (schema is Map && schema.containsKey(key)) return;
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  fail('Schema for "$importId" did not gain key "$key" within $timeout');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------------------------------
  // T022 — addStyleImportFromJSON / addStyleImportFromURI
  // ---------------------------------------------------------------------------

  testWidgets('addStyleImportFromJSON without config or position', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMap(tester);

    await mapboxMap.style.addStyleImportFromJSON(
      'inline-fragment',
      _inlineFragmentJson,
    );
    await tester.pumpAndSettle();

    final ids = await _importIds(mapboxMap);
    expect(ids, contains('inline-fragment'));
  });

  testWidgets('addStyleImportFromJSON with config and position', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMap(tester);

    // Seed a first import so we can use ImportPosition.above.
    await mapboxMap.style.addStyleImportFromJSON('frag-a', _inlineFragmentJson);
    await tester.pumpAndSettle();

    // Use the schema-bearing fragment so the supplied config has somewhere
    // to land; verify both the position resolution and the config write
    // round-trip in a single test.
    await mapboxMap.style.addStyleImportFromJSON(
      'frag-b',
      _inlineFragmentWithSchemaJson,
      config: {'testColor': '#112233'},
      importPosition: ImportPosition(above: 'frag-a'),
    );
    await tester.pumpAndSettle();

    final ids = await _importIds(mapboxMap);
    expect(ids, contains('frag-b'));
    expect(ids, contains('frag-a'));
    // frag-b should appear above (i.e. later in the list than) frag-a.
    expect(ids.indexOf('frag-b'), greaterThan(ids.indexOf('frag-a')));

    final colorProp = await mapboxMap.style.getStyleImportConfigProperty(
      'frag-b',
      'testColor',
    );
    expect(colorProp.value, '#112233');
  });

  testWidgets('addStyleImportFromURI without config', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMap(tester);

    await mapboxMap.style.addStyleImportFromURI(
      'uri-import',
      MapboxStyles.OUTDOORS,
    );
    app.events.resetOnMapLoaded();
    await app.events.onMapLoaded.future;

    final ids = await _importIds(mapboxMap);
    expect(ids, contains('uri-import'));
  });

  testWidgets('addStyleImportFromURI with importPosition below', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMap(tester);

    // Seed anchor import.
    await mapboxMap.style.addStyleImportFromJSON('anchor', _inlineFragmentJson);
    await tester.pumpAndSettle();

    await app.events.onMapLoaded.future;
    app.events.resetOnStyleDataLoaded();

    await mapboxMap.style.addStyleImportFromURI(
      'uri-below',
      MapboxStyles.OUTDOORS,
      importPosition: ImportPosition(below: 'anchor'),
    );

    await app.events.onStyleDataLoaded.future;

    final ids = await _importIds(mapboxMap);
    expect(ids, contains('uri-below'));
    expect(ids, contains('anchor'));
    // uri-below must appear before anchor in the list (below = earlier index).
    expect(ids.indexOf('uri-below'), lessThan(ids.indexOf('anchor')));
  });

  // ---------------------------------------------------------------------------
  // T023 — updateStyleImportWithJSON / updateStyleImportWithURI
  // ---------------------------------------------------------------------------

  testWidgets('updateStyleImportWithJSON data-only', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMap(tester);

    // Seed with a fragment whose schema carries `beforeMarker` so we can
    // distinguish loaded content after the update.
    await mapboxMap.style.addStyleImportFromJSON(
      'update-target',
      _inlineFragmentBeforeJson,
    );
    await tester.pumpAndSettle();

    final seedSchema =
        await mapboxMap.style.getStyleImportSchema('update-target') as Map;
    expect(seedSchema.keys, contains('beforeMarker'));

    // Update with structurally different data carrying `afterMarker`.
    await mapboxMap.style.updateStyleImportWithJSON(
      'update-target',
      _inlineFragmentAfterJson,
    );
    await tester.pumpAndSettle();

    final ids = await _importIds(mapboxMap);
    expect(ids, contains('update-target'));

    // Schema must now reflect the post-update fragment.
    final updatedSchema =
        await mapboxMap.style.getStyleImportSchema('update-target') as Map;
    expect(updatedSchema.keys, contains('afterMarker'));
    expect(updatedSchema.keys, isNot(contains('beforeMarker')));
  });

  testWidgets('updateStyleImportWithJSON data+config', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMap(tester);

    // Both fragments share `testColor`, so config writes have somewhere to
    // land before and after. They differ in their schema marker, so the
    // data swap is observable independently of the config round-trip.
    await mapboxMap.style.addStyleImportFromJSON(
      'update-target',
      _inlineFragmentBeforeJson,
      config: {'testColor': '#ffffff'},
    );
    await tester.pumpAndSettle();

    await mapboxMap.style.updateStyleImportWithJSON(
      'update-target',
      _inlineFragmentAfterJson,
      config: {'testColor': '#112233'},
    );
    await tester.pumpAndSettle();

    // Data swap: schema must reflect the post-update fragment.
    final updatedSchema =
        await mapboxMap.style.getStyleImportSchema('update-target') as Map;
    expect(updatedSchema.keys, contains('afterMarker'));
    expect(updatedSchema.keys, isNot(contains('beforeMarker')));

    // Config round-trip on the shared key.
    final prop = await mapboxMap.style.getStyleImportConfigProperty(
      'update-target',
      'testColor',
    );
    expect(prop.value, '#112233');
  });

  testWidgets('updateStyleImportWithURI data-only', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMap(tester, MapboxStyles.MAPBOX_STREETS);

    // Seed with OUTDOORS (no `lightPreset` in its schema) so we can observe
    // the URL swap by checking the schema after the update.
    await mapboxMap.style.addStyleImportFromURI(
      'uri-target',
      MapboxStyles.OUTDOORS,
    );

    await tester.pumpAndSettle();
    app.events.resetOnMapIdle();
    await app.events.onMapIdle.future;

    await mapboxMap.style.updateStyleImportWithURI(
      'uri-target',
      MapboxStyles.STANDARD,
    );
    app.events.resetOnStyleDataLoaded();
    await app.events.onStyleDataLoaded.future;
    // URL fetch is async; wait for the Standard schema to appear.
    await _waitForImportSchemaKey(mapboxMap, 'uri-target', 'lightPreset');
    final ids = await _importIds(mapboxMap);
    expect(ids, contains('uri-target'));

    // Schema gained `lightPreset`, which only Standard-family styles
    // declare — proves the URL actually swapped.
    final schema =
        await mapboxMap.style.getStyleImportSchema('uri-target') as Map;
    expect(schema.keys, contains('lightPreset'));
  });

  testWidgets('updateStyleImportWithURI data+config', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMap(tester);

    // Seed a non-base URI import we can later swap the URL on. We update
    // to STANDARD_SATELLITE because it shares the Standard config schema
    // (`lightPreset`, etc.) with the base style, giving the config write
    // a known landing spot we can assert against.
    await mapboxMap.style.addStyleImportFromURI(
      'uri-update',
      MapboxStyles.OUTDOORS,
    );

    app.events.resetOnMapIdle();
    await app.events.onMapIdle.future;
    await tester.pumpAndSettle();

    await mapboxMap.style.updateStyleImportWithURI(
      'uri-update',
      MapboxStyles.STANDARD_SATELLITE,
      config: {'lightPreset': 'night'},
    );
    app.events.resetOnMapIdle();
    await app.events.onMapIdle.future;

    final prop = await mapboxMap.style.getStyleImportConfigProperty(
      'uri-update',
      'lightPreset',
    );
    expect(prop.value, 'night');
  });

  testWidgets(
    'updateStyleImportWithJSON preserves existing config when omitted',
    (WidgetTester tester) async {
      final mapboxMap = await _setupMap(tester);

      await mapboxMap.style.addStyleImportFromJSON(
        'merge-target',
        _inlineFragmentBeforeJson,
        config: {'testColor': '#445566'},
      );
      await tester.pumpAndSettle();

      // Update data without supplying config — the previously-set value must
      // survive across the remove+add emulation (matches gl-native's merge
      // semantics).
      await mapboxMap.style.updateStyleImportWithJSON(
        'merge-target',
        _inlineFragmentAfterJson,
      );
      await tester.pumpAndSettle();

      final prop = await mapboxMap.style.getStyleImportConfigProperty(
        'merge-target',
        'testColor',
      );
      expect(prop.value, '#445566');
    },
  );

  // ---------------------------------------------------------------------------
  // T024 — moveStyleImport
  // ---------------------------------------------------------------------------

  testWidgets('moveStyleImport above', (WidgetTester tester) async {
    final mapboxMap = await _setupMap(tester);

    await mapboxMap.style.addStyleImportFromJSON('m-a', _inlineFragmentJson);
    await mapboxMap.style.addStyleImportFromJSON('m-b', _inlineFragmentJson);
    await mapboxMap.style.addStyleImportFromJSON('m-c', _inlineFragmentJson);
    await tester.pumpAndSettle();

    // Move m-a above m-b. Avoid targeting the topmost import (m-c) — gl-js's
    // moveImport with a null/omitted beforeId is a no-op, so "above the last
    // entry" cannot be expressed via the beforeId form the web binding uses.
    await mapboxMap.style.moveStyleImport('m-a', ImportPosition(above: 'm-b'));
    await tester.pumpAndSettle();

    final ids = await _importIds(mapboxMap);
    expect(ids, containsAll(['m-a', 'm-b', 'm-c']));
    expect(ids.indexOf('m-a'), greaterThan(ids.indexOf('m-b')));
  });

  testWidgets('moveStyleImport below', (WidgetTester tester) async {
    final mapboxMap = await _setupMap(tester);

    await mapboxMap.style.addStyleImportFromJSON('n-a', _inlineFragmentJson);
    await mapboxMap.style.addStyleImportFromJSON('n-b', _inlineFragmentJson);
    await mapboxMap.style.addStyleImportFromJSON('n-c', _inlineFragmentJson);
    await tester.pumpAndSettle();

    // Move n-c below n-a (n-c should end up before n-a in the list).
    await mapboxMap.style.moveStyleImport('n-c', ImportPosition(below: 'n-a'));
    await tester.pumpAndSettle();

    final ids = await _importIds(mapboxMap);
    expect(ids, containsAll(['n-a', 'n-b', 'n-c']));
    expect(ids.indexOf('n-c'), lessThan(ids.indexOf('n-a')));
  });

  testWidgets('moveStyleImport at', (WidgetTester tester) async {
    final mapboxMap = await _setupMap(tester);

    await mapboxMap.style.addStyleImportFromJSON('p-a', _inlineFragmentJson);
    await mapboxMap.style.addStyleImportFromJSON('p-b', _inlineFragmentJson);
    await mapboxMap.style.addStyleImportFromJSON('p-c', _inlineFragmentJson);
    await tester.pumpAndSettle();

    final idsBefore = await _importIds(mapboxMap);
    // Move p-c to p-a's slot. `at: i` reinserts before `ids[i]`, so p-c
    // should land directly ahead of p-a in the resulting order.
    final targetIndex = idsBefore.indexOf('p-a');
    await mapboxMap.style.moveStyleImport(
      'p-c',
      ImportPosition(at: targetIndex),
    );
    await tester.pumpAndSettle();
    final idsAfter = await _importIds(mapboxMap);
    expect(idsAfter, containsAll(['p-a', 'p-b', 'p-c']));
    expect(idsAfter.indexOf('p-c'), lessThan(idsAfter.indexOf('p-a')));
  });

  testWidgets('moveStyleImport null position is a no-op on web', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMap(tester);

    await mapboxMap.style.addStyleImportFromJSON('q-a', _inlineFragmentJson);
    await mapboxMap.style.addStyleImportFromJSON('q-b', _inlineFragmentJson);
    await tester.pumpAndSettle();

    // gl-js's moveImport with a null/omitted beforeId does not append, so
    // the platform contract's "null → move to top" cannot be honored via the
    // beforeId form. Assert the imports are unaffected (no crash, both ids
    // still present) rather than parity with gl-native.
    await mapboxMap.style.moveStyleImport('q-a', null);
    await tester.pumpAndSettle();

    final ids = await _importIds(mapboxMap);
    expect(ids, containsAll(['q-a', 'q-b']));
  });

  // ---------------------------------------------------------------------------
  // T025 — removeStyleImport
  // ---------------------------------------------------------------------------

  testWidgets('removeStyleImport success path', (WidgetTester tester) async {
    final mapboxMap = await _setupMap(tester);

    await mapboxMap.style.addStyleImportFromJSON(
      'removable',
      _inlineFragmentJson,
    );
    await tester.pumpAndSettle();

    final idsBefore = await _importIds(mapboxMap);
    expect(idsBefore, contains('removable'));

    await mapboxMap.style.removeStyleImport('removable');
    await tester.pumpAndSettle();

    final idsAfter = await _importIds(mapboxMap);
    expect(idsAfter, isNot(contains('removable')));
  });

  // removeStyleImport against an unknown id has divergent behaviour per the
  // spec edge case (FR-IMP-006): gl-js fires an asynchronous error event,
  // gl-native throws synchronously. Both are acceptable; we do not assert a
  // cross-platform contract here.

  // ---------------------------------------------------------------------------
  // T026 — getStyleImportSchema
  // ---------------------------------------------------------------------------

  testWidgets('getStyleImportSchema returns schema with known keys', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMapWithStandard(tester);

    final schema = await mapboxMap.style.getStyleImportSchema('basemap');
    expect(schema, isA<Map>());
    final schemaMap = schema as Map;
    expect(schemaMap.keys, contains('lightPreset'));
    expect(schemaMap.keys, contains('showPlaceLabels'));
  });

  // ---------------------------------------------------------------------------
  // T027 — getStyleImportConfigProperty / getStyleImportConfigProperties
  // ---------------------------------------------------------------------------

  testWidgets('getStyleImportConfigProperty single read', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMapWithStandard(tester);

    final prop = await mapboxMap.style.getStyleImportConfigProperty(
      'basemap',
      'lightPreset',
    );

    // The value must be non-null and the kind must be defined.
    expect(prop.value, isNotNull);
    expect(prop.kind, isNot(StylePropertyValueKind.UNDEFINED));
  });

  testWidgets('getStyleImportConfigProperties bulk read', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMapWithStandard(tester);

    // gl-native's getConfig only surfaces explicitly-set values, not schema
    // defaults — seed two properties so the bulk read has something to
    // observe.
    await mapboxMap.style.setStyleImportConfigProperties('basemap', {
      'lightPreset': 'day',
      'showPlaceLabels': true,
    });

    final props = await mapboxMap.style.getStyleImportConfigProperties(
      'basemap',
    );

    expect(props, isA<Map<String, StylePropertyValue>>());
    expect(props.keys, contains('lightPreset'));
    expect(props.keys, contains('showPlaceLabels'));
  });

  // ---------------------------------------------------------------------------
  // T028 — setStyleImportConfigProperty / setStyleImportConfigProperties
  // ---------------------------------------------------------------------------

  testWidgets('setStyleImportConfigProperty single write round-trips', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMapWithStandard(tester);

    await mapboxMap.style.setStyleImportConfigProperty(
      'basemap',
      'lightPreset',
      'night',
    );

    final prop = await mapboxMap.style.getStyleImportConfigProperty(
      'basemap',
      'lightPreset',
    );
    expect(prop.value, 'night');
  });

  testWidgets('setStyleImportConfigProperties bulk write round-trips', (
    WidgetTester tester,
  ) async {
    final mapboxMap = await _setupMapWithStandard(tester);

    await mapboxMap.style.setStyleImportConfigProperties('basemap', {
      'lightPreset': 'dawn',
      'showPlaceLabels': false,
    });

    final props = await mapboxMap.style.getStyleImportConfigProperties(
      'basemap',
    );

    expect(props.keys, containsAll(['lightPreset', 'showPlaceLabels']));
    expect(props['lightPreset']?.value, 'dawn');
    expect(props['showPlaceLabels']?.value, false);
  });
}
