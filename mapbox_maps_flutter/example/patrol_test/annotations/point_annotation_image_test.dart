// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Size;
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../empty_map_widget.dart' as app;
import '../patrol.dart';
import '../utils/image_comparison.dart';

// Coverage for https://github.com/mapbox/mapbox-maps-flutter/issues/532.
//
// `update()` only re-applies an icon when `iconImage` (the style-image
// name) changes. `image` bytes are never compared. If the caller leaves
// `iconImage` unset, the SDK derives it from a hash of `image`. So the
// common pattern — set `.image`, call `update()` — works without the
// caller managing `iconImage`. Both halves of that contract are tested
// here.
const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  patrolTest(
    'update PointAnnotation image with new bytes and no iconImage refreshes the icon',
    skip: kIsWeb,
    ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      final manager = await mapboxMap.annotations
          .createPointAnnotationManager();

      final redPng = await _solidColorPng(Colors.red);
      final bluePng = await _solidColorPng(Colors.blue);

      final annotation = await manager.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: Position(1.0, 2.0)),
          image: redPng,
        ),
      );
      await tester.pumpAndSettle();
      final firstIconName = annotation.iconImage;
      expect(firstIconName, isNotNull);
      final firstStyleImage = await mapboxMap.getImage(firstIconName!);
      expect(
        await isSameImage(
          firstStyleImage?.pixels,
          redPng,
          widthA: firstStyleImage?.width,
          heightA: firstStyleImage?.height,
        ),
        isTrue,
      );

      // Matches real app code: only `image` is reassigned; `iconImage` is
      // left as whatever the SDK echoed back after create() (the hash of
      // `redPng`, not null) — the auto-derivation must recognize that as
      // its own prior id and replace it, not treat it as caller-chosen.
      annotation.image = bluePng;
      await manager.update(annotation);
      await tester.pumpAndSettle();

      final updated = (await manager.getAnnotations()).firstWhere(
        (a) => a.id == annotation.id,
      );
      final newIconName = updated.iconImage;
      expect(newIconName, isNotNull);
      expect(
        newIconName,
        isNot(firstIconName),
        reason: 'a hash-derived iconImage must change when the bytes change',
      );
      final newStyleImage = await mapboxMap.getImage(newIconName!);
      expect(
        await isSameImage(
          newStyleImage?.pixels,
          bluePng,
          widthA: newStyleImage?.width,
          heightA: newStyleImage?.height,
        ),
        isTrue,
        reason: 'update() must register the new image bytes',
      );
      expect(
        await isSameImage(updated.image, bluePng),
        isTrue,
        reason: 'image bytes round-trip through getAnnotations()',
      );
    },
  );

  patrolTest(
    'update PointAnnotation image with the same explicit iconImage and different bytes is a no-op',
    skip: kIsWeb,
    ($) async {
      final tester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await tester.pumpAndSettle();
      final manager = await mapboxMap.annotations
          .createPointAnnotationManager();

      final redPng = await _solidColorPng(Colors.red);
      final bluePng = await _solidColorPng(Colors.blue);

      final annotation = await manager.create(
        PointAnnotationOptions(
          geometry: Point(coordinates: Position(1.0, 2.0)),
          image: redPng,
          iconImage: 'point-annotation-image-fixed-id',
        ),
      );
      await tester.pumpAndSettle();

      // Caller explicitly controls iconImage and keeps it fixed while
      // changing bytes: the SDK never compares bytes, so this is a no-op
      // by design.
      annotation.image = bluePng;
      annotation.iconImage = 'point-annotation-image-fixed-id';
      await manager.update(annotation);
      await tester.pumpAndSettle();

      final styleImage = await mapboxMap.getImage(
        'point-annotation-image-fixed-id',
      );
      expect(
        await isSameImage(
          styleImage?.pixels,
          redPng,
          widthA: styleImage?.width,
          heightA: styleImage?.height,
        ),
        isTrue,
        reason:
            'reusing the same iconImage must not re-register the icon, '
            'even with different bytes',
      );
    },
  );
}

/// Renders a solid-color square and encodes it as a PNG.
Future<Uint8List> _solidColorPng(Color color) async {
  const size = 4;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
    Paint()..color = color,
  );
  final image = await recorder.endRecording().toImage(size, size);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  return byteData!.buffer.asUint8List();
}
