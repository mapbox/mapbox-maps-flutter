import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:turf/turf.dart' show Point, Position;
import 'patrol.dart';

import 'test_utils.dart';

final _viewport = CameraViewportState(
  center: Point(coordinates: Position(0, 0)),
  zoom: 5,
);

/// A fragment carrying its own source and layer, so a successful merge is
/// observable through `getStyleSources`/`getStyleLayers`.
const _fragmentJson = '''
{
  "version": 8,
  "sources": {
    "fragment-source": {
      "type": "geojson",
      "data": {"type": "FeatureCollection", "features": []}
    }
  },
  "layers": [
    {
      "id": "fragment-layer",
      "type": "background",
      "paint": {"background-color": "#abcdef"}
    }
  ]
}
''';

Future<MapboxMapPlatformInterface> _pumpMap(WidgetTester tester) => pumpMapTree(
  tester,
  (onCreated) => MaterialApp(
    home: Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MapWebWidget(
              styleUri: 'mapbox://styles/mapbox/standard',
              viewport: _viewport,
              onMapCreated: onCreated,
            ),
          ),
        ],
      ),
    ),
  ),
);

void main() {
  // gl-native parses and merges a JSON import before
  // `addStyleImportFromJSON` returns, so callers may read and mutate the
  // style straight afterwards. GL JS merges asynchronously, and the merge
  // runs in a microtask chained off `style.import.load` rather than during
  // it. Resolving on that event alone therefore returns while the fragment
  // is still unloaded, and the first call that serializes the style throws
  // "Style is not done loading" from the fragment's own `_checkLoaded`.
  //
  // Each assertion below is the FIRST await after the import call: any
  // extra await in between would let the pending merge land on its own and
  // mask the regression.
  patrolTest('style is readable right after addStyleImportFromJSON', ($) async {
    final controller = await _pumpMap($.tester);
    final style = controller.style;

    await style.addStyleImportFromJSON('fragment', _fragmentJson);

    // Serializes every import, including the one just added.
    final imports = await style.getStyleImports();
    expect(
      imports.whereType<StyleObjectInfo>().map((e) => e.id),
      contains('fragment'),
    );
  });

  patrolTest('style is mutable right after addStyleImportFromJSON', ($) async {
    final controller = await _pumpMap($.tester);
    final style = controller.style;

    await style.addStyleImportFromJSON('fragment', _fragmentJson);

    await style.addStyleSource(
      'test-source',
      json.encode({
        'type': 'geojson',
        'data': {'type': 'FeatureCollection', 'features': <Object>[]},
      }),
    );
    final sources = await style.getStyleSources();
    expect(
      sources.whereType<StyleObjectInfo>().map((e) => e.id),
      contains('test-source'),
    );
  });

  // The update path is emulated as remove+add, so it re-runs the merge.
  patrolTest('style is readable right after updateStyleImportWithJSON', (
    $,
  ) async {
    final controller = await _pumpMap($.tester);
    final style = controller.style;

    await style.addStyleImportFromJSON('fragment', _fragmentJson);
    await style.updateStyleImportWithJSON('fragment', _fragmentJson);

    final imports = await style.getStyleImports();
    expect(
      imports.whereType<StyleObjectInfo>().map((e) => e.id),
      contains('fragment'),
    );
  });
}
