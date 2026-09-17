import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:turf/turf.dart' show Feature, Point, Position;
import 'patrol.dart';

import 'test_utils.dart';

final _viewport = CameraViewportState(
  center: Point(coordinates: Position(0, 0)),
  zoom: 5,
);

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

// Adds a circle layer using the source: `querySourceFeatures` only reads
// from loaded tiles, and GL JS only tiles a GeoJSON source a layer renders.
Future<void> _addGeoJsonSource(
  MapboxMapPlatformInterface controller,
  String sourceId, {
  required bool dynamicData,
}) async {
  await controller.style.addStyleSource(
    sourceId,
    json.encode({
      'type': 'geojson',
      'data': {'type': 'FeatureCollection', 'features': <Object>[]},
      'dynamic': dynamicData,
    }),
  );
  await controller.style.addStyleLayer(
    json.encode({
      'id': '$sourceId-layer',
      'type': 'circle',
      'source': sourceId,
    }),
    null,
  );
}

// Feature ids must be numbers: GL JS keeps only numeric feature ids. GL JS
// reports them back as strings from querySourceFeatures.
Feature _feature(num id, double lng, double lat) => Feature(
  id: id,
  geometry: Point(coordinates: Position(lng, lat)),
);

Future<List<Map<String?, Object?>>> _sourceFeatures(
  MapboxMapPlatformInterface controller,
  String sourceId,
) async {
  final results = await controller.querySourceFeatures(
    sourceId,
    SourceQueryOptions(filter: ''),
  );
  return results
      .whereType<QueriedSourceFeature>()
      .map((r) => r.queriedFeature.feature)
      .toList();
}

void main() {
  patrolTest('addGeoJSONSourceFeatures adds a feature to a dynamic source', (
    $,
  ) async {
    final controller = await _pumpMap($.tester);
    await _addGeoJsonSource(controller, 'add-source', dynamicData: true);

    await controller.style.addGeoJSONSourceFeatures('add-source', 'batch-1', [
      _feature(1, 0, 0),
    ]);
    await $.tester.pumpAndSettle();

    final features = await _sourceFeatures(controller, 'add-source');
    expect(features.map((f) => f['id']), contains('1'));
  });

  patrolTest('updateGeoJSONSourceFeatures replaces an existing feature by id', (
    $,
  ) async {
    final controller = await _pumpMap($.tester);
    await _addGeoJsonSource(controller, 'update-source', dynamicData: true);
    await controller.style.addGeoJSONSourceFeatures(
      'update-source',
      'batch-1',
      [_feature(1, 0, 0)],
    );
    await $.tester.pumpAndSettle();

    await controller.style.updateGeoJSONSourceFeatures(
      'update-source',
      'batch-2',
      [_feature(1, 10, 10)],
    );
    await $.tester.pumpAndSettle();

    final features = await _sourceFeatures(controller, 'update-source');
    final feature = features.lastWhere((f) => f['id'] == '1');
    final geometry = feature['geometry']! as Map;
    // GL JS re-encodes coordinates through vector-tile quantization, which
    // loses some precision.
    final coordinates = geometry['coordinates']! as List;
    expect(coordinates[0], closeTo(10, 0.01));
    expect(coordinates[1], closeTo(10, 0.01));
  });

  patrolTest('removeGeoJSONSourceFeatures removes a feature by id', ($) async {
    final controller = await _pumpMap($.tester);
    await _addGeoJsonSource(controller, 'remove-source', dynamicData: true);
    await controller.style.addGeoJSONSourceFeatures(
      'remove-source',
      'batch-1',
      [_feature(1, 0, 0), _feature(2, 1, 1)],
    );
    await $.tester.pumpAndSettle();

    await controller.style.removeGeoJSONSourceFeatures(
      'remove-source',
      'batch-2',
      ['1'],
    );
    await $.tester.pumpAndSettle();

    final ids = (await _sourceFeatures(
      controller,
      'remove-source',
    )).map((f) => f['id']).toSet();
    expect(ids, contains('2'));
    expect(ids, isNot(contains('1')));
  });

  // These three methods need GL JS's `updateData`, which throws when the
  // source spec doesn't set `dynamic: true` — the case a caller who forgets
  // `GeoJsonSource.dynamicData` hits — so assert the exact message.
  final cases = <String, Future<void> Function(MapboxMapPlatformInterface)>{
    'addGeoJSONSourceFeatures': (controller) =>
        controller.style.addGeoJSONSourceFeatures('static-source', 'batch-1', [
          _feature(1, 0, 0),
        ]),
    'updateGeoJSONSourceFeatures': (controller) =>
        controller.style.updateGeoJSONSourceFeatures(
          'static-source',
          'batch-1',
          [_feature(1, 0, 0)],
        ),
    'removeGeoJSONSourceFeatures': (controller) => controller.style
        .removeGeoJSONSourceFeatures('static-source', 'batch-1', ['1']),
  };
  for (final entry in cases.entries) {
    patrolTest(
      '${entry.key} throws a StateError on a source without dynamicData',
      ($) async {
        final controller = await _pumpMap($.tester);
        await _addGeoJsonSource(
          controller,
          'static-source',
          dynamicData: false,
        );

        await expectLater(
          () => entry.value(controller),
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              'GeoJSON source "static-source" does not accept feature updates. '
                  'Set GeoJsonSource.dynamicData to true when you add the source.',
            ),
          ),
        );
      },
    );
  }
}
