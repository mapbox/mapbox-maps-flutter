import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/turf.dart';

class StubStylePlatformInterface implements StylePlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockSnapshotterPlatformInterface
    implements SnapshotterPlatformInterface {
  int getCameraStateCallCount = 0;
  int setCameraCallCount = 0;
  int getSizeCallCount = 0;
  int setSizeCallCount = 0;
  int startCallCount = 0;
  int cancelCallCount = 0;
  int coordinateBoundsCallCount = 0;
  int cameraCallCount = 0;
  int tileCoverCallCount = 0;
  int clearDataCallCount = 0;
  int disposeCallCount = 0;

  CameraOptions? lastCameraOptions;
  Size? lastSize;
  TileCoverOptions? lastTileCoverOptions;
  List<Point>? lastCoordinates;

  @override
  final StylePlatformInterface style = StubStylePlatformInterface();

  @override
  OnStyleLoadedListener? get onStyleLoadedListener => null;

  @override
  OnMapLoadErrorListener? get onMapLoadErrorListener => null;

  @override
  OnStyleDataLoadedListener? get onStyleDataLoadedListener => null;

  @override
  OnStyleImageMissingListener? get onStyleImageMissingListener => null;

  @override
  Future<CameraState> getCameraState() async {
    getCameraStateCallCount++;
    return CameraState(
      center: Point(coordinates: Position(0, 0)),
      padding: MbxEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
      zoom: 10,
      bearing: 0,
      pitch: 0,
    );
  }

  @override
  Future<void> setCamera(CameraOptions cameraOptions) async {
    setCameraCallCount++;
    lastCameraOptions = cameraOptions;
  }

  @override
  Future<Size?> getSize() async {
    getSizeCallCount++;
    return Size(width: 512, height: 512);
  }

  @override
  Future<void> setSize(Size size) async {
    setSizeCallCount++;
    lastSize = size;
  }

  @override
  Future<Uint8List?> start() async {
    startCallCount++;
    return Uint8List.fromList([0, 1, 2, 3]);
  }

  @override
  Future<void> cancel() async {
    cancelCallCount++;
  }

  @override
  Future<CoordinateBounds> coordinateBounds(CameraOptions camera) async {
    coordinateBoundsCallCount++;
    lastCameraOptions = camera;
    return CoordinateBounds(
      southwest: Point(coordinates: Position(-1, -1)),
      northeast: Point(coordinates: Position(1, 1)),
      infiniteBounds: false,
    );
  }

  @override
  Future<CameraOptions> camera({
    required List<Point> coordinates,
    MbxEdgeInsets? padding,
    double? bearing,
    double? pitch,
  }) async {
    cameraCallCount++;
    lastCoordinates = coordinates;
    return CameraOptions(
      center: Point(coordinates: Position(0, 0)),
      zoom: 5,
    );
  }

  @override
  Future<List<CanonicalTileID?>> tileCover(TileCoverOptions options) async {
    tileCoverCallCount++;
    lastTileCoverOptions = options;
    return [];
  }

  @override
  Future<void> clearData() async {
    clearDataCallCount++;
  }

  @override
  Future<void> dispose() async {
    disposeCallCount++;
  }
}

void main() {
  late MockSnapshotterPlatformInterface mockImpl;
  late Snapshotter snapshotter;

  setUp(() {
    mockImpl = MockSnapshotterPlatformInterface();
    snapshotter = Snapshotter(mockImpl);
  });

  group('Snapshotter', () {
    test('getCameraState delegates to interface', () async {
      final result = await snapshotter.getCameraState();

      expect(mockImpl.getCameraStateCallCount, 1);
      expect(result.zoom, 10);
    });

    test('setCamera delegates to interface', () async {
      final options = CameraOptions(
        center: Point(coordinates: Position(10, 20)),
        zoom: 15,
      );

      await snapshotter.setCamera(options);

      expect(mockImpl.setCameraCallCount, 1);
      expect(mockImpl.lastCameraOptions, same(options));
    });

    test('getSize delegates to interface', () async {
      final result = await snapshotter.getSize();

      expect(mockImpl.getSizeCallCount, 1);
      expect(result?.width, 512);
    });

    test('setSize delegates to interface', () async {
      final size = Size(width: 1024, height: 768);

      await snapshotter.setSize(size);

      expect(mockImpl.setSizeCallCount, 1);
      expect(mockImpl.lastSize, same(size));
    });

    test('start delegates to interface', () async {
      final result = await snapshotter.start();

      expect(mockImpl.startCallCount, 1);
      expect(result, isNotNull);
      expect(result!.length, 4);
    });

    test('cancel delegates to interface', () async {
      await snapshotter.cancel();

      expect(mockImpl.cancelCallCount, 1);
    });

    test('coordinateBounds delegates to interface', () async {
      final camera = CameraOptions(zoom: 5);

      final result = await snapshotter.coordinateBounds(camera);

      expect(mockImpl.coordinateBoundsCallCount, 1);
      expect(mockImpl.lastCameraOptions, same(camera));
      expect(result.infiniteBounds, false);
    });

    test('camera delegates to interface', () async {
      final coordinates = [
        Point(coordinates: Position(0, 0)),
        Point(coordinates: Position(1, 1)),
      ];

      final result = await snapshotter.camera(coordinates: coordinates);

      expect(mockImpl.cameraCallCount, 1);
      expect(mockImpl.lastCoordinates, same(coordinates));
      expect(result.zoom, 5);
    });

    test('tileCover delegates to interface', () async {
      final options = TileCoverOptions(
        tileSize: 512,
        minZoom: 0,
        maxZoom: 5,
        roundZoom: false,
      );

      final result = await snapshotter.tileCover(options);

      expect(mockImpl.tileCoverCallCount, 1);
      expect(mockImpl.lastTileCoverOptions, same(options));
      expect(result, isEmpty);
    });

    test('clearData delegates to interface', () async {
      await snapshotter.clearData();

      expect(mockImpl.clearDataCallCount, 1);
    });

    test('dispose delegates to interface', () async {
      await snapshotter.dispose();

      expect(mockImpl.disposeCallCount, 1);
    });

    test('event listeners delegate to interface', () {
      expect(snapshotter.onStyleLoadedListener, isNull);
      expect(snapshotter.onMapLoadErrorListener, isNull);
      expect(snapshotter.onStyleDataLoadedListener, isNull);
      expect(snapshotter.onStyleImageMissingListener, isNull);
    });
  });
}
