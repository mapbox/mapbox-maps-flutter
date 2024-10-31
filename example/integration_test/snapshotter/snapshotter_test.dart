import 'dart:async';

import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Basic snapshot', (WidgetTester tester) async {
    app.runEmpty();
    await tester.pumpAndSettle();

    final options = MapSnapshotOptions(
      size: Size(width: 96, height: 96),
      pixelRatio: 1.5,
      glyphsRasterizationOptions: GlyphsRasterizationOptions(
          rasterizationMode:
              GlyphsRasterizationMode.ALL_GLYPHS_RASTERIZED_LOCALLY),
      showsAttribution: false,
      showsLogo: false,
    );
    final snapshotter = await Snapshotter.create(options: options);

    await snapshotter.style.setStyleURI(MapboxStyles.LIGHT);
    final snapshotData = await snapshotter.start();

    // Flutter's Golden test would be quite a good fit here, too bad it is broken on Android.
    // https://github.com/flutter/flutter/issues/143299
    expect(snapshotData, isNotNull);

    await snapshotter.dispose();
  });

  testWidgets('Snapshotter style loaded', (WidgetTester tester) async {
    app.runEmpty();
    await tester.pumpAndSettle();

    final styleLoaded = Completer<StyleLoadedEventData>();
    final styleDataLoaded = Completer<StyleDataLoadedEventData>();
    final options = MapSnapshotOptions(
      size: Size(width: 96, height: 96),
      pixelRatio: 1.5,
    );
    final snapshotter = await Snapshotter.create(
      options: options,
      onStyleLoadedListener: styleLoaded.complete,
      onStyleDataLoadedListener: (e) {
        if (!styleDataLoaded.isCompleted) styleDataLoaded.complete(e);
      },
    );

    await snapshotter.style.setStyleURI(MapboxStyles.LIGHT);

    expect(styleLoaded.future, completes);
    expect(styleDataLoaded.future, completes);

    await snapshotter.dispose();
  });

  testWidgets('Snapshotter runtime configuration', (WidgetTester tester) async {
    app.runEmpty();
    await tester.pumpAndSettle();

    final options = MapSnapshotOptions(
      size: Size(width: 96, height: 96),
      pixelRatio: 1.5,
    );
    final snapshotter = await Snapshotter.create(options: options);

    await snapshotter.style.setStyleURI(MapboxStyles.LIGHT);

    await snapshotter.setSize(Size(width: 192, height: 192));
    final size = await snapshotter.getSize();

    expect(size?.width, equals(192));
    expect(size?.height, equals(192));

    final cameraOptions = CameraOptions(
      center: Point(coordinates: Position.named(lat: 0, lng: 0)),
      zoom: 10,
      bearing: 35,
      pitch: 12,
    );
    await snapshotter.setCamera(cameraOptions);
    final cameraState = await snapshotter.getCameraState();
    expect(cameraState.center, equals(cameraOptions.center));
    expect(cameraState.zoom, closeTo(cameraOptions.zoom!, 0.001));
    expect(cameraState.bearing, closeTo(cameraOptions.bearing!, 0.001));
    expect(cameraState.pitch, closeTo(cameraOptions.pitch!, 0.001));

    final bounds = await snapshotter.coordinateBounds(cameraOptions);
    expect(bounds, isNotNull);

    final camera = await snapshotter.camera(
      coordinates: [cameraOptions.center!],
      bearing: cameraOptions.bearing,
      pitch: cameraOptions.pitch,
    );
    expect(camera.center?.coordinates.lat,
        closeTo(cameraOptions.center!.coordinates.lat, 0.001));
    expect(camera.center?.coordinates.lng,
        closeTo(cameraOptions.center!.coordinates.lng, 0.001));
    expect(camera.bearing, closeTo(cameraOptions.bearing!, 0.001));
    expect(camera.pitch, closeTo(cameraOptions.pitch!, 0.001));

    final tileCover = await snapshotter.tileCover(TileCoverOptions());

    expect(tileCover, isNotNull);

    await snapshotter.dispose();
  });

  testWidgets('Snapshotter cancel and clear', (WidgetTester tester) async {
    app.runEmpty();
    await tester.pumpAndSettle();

    final options = MapSnapshotOptions(
      size: Size(width: 96, height: 96),
      pixelRatio: 1.5,
    );
    final snapshotter = await Snapshotter.create(options: options);

    await snapshotter.style.setStyleURI(MapboxStyles.LIGHT);
    final snapshot = snapshotter.start();

    snapshotter.cancel();

    try {
      await snapshot;
      fail("Cancelled error should be thrown");
    } catch (e) {
      expect(e, isInstanceOf<PlatformException>());
    }

    await snapshotter.clearData();
    await snapshotter.dispose();
  });
}
