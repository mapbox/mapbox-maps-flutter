import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockPointAnnotationManagerPlatformInterface
    implements PointAnnotationManagerPlatformInterface {
  @override
  final String id;
  MockPointAnnotationManagerPlatformInterface(this.id);
}

class MockCircleAnnotationManagerPlatformInterface
    implements CircleAnnotationManagerPlatformInterface {
  @override
  final String id;
  MockCircleAnnotationManagerPlatformInterface(this.id);
}

class MockPolylineAnnotationManagerPlatformInterface
    implements PolylineAnnotationManagerPlatformInterface {
  @override
  final String id;
  MockPolylineAnnotationManagerPlatformInterface(this.id);
}

class MockPolygonAnnotationManagerPlatformInterface
    implements PolygonAnnotationManagerPlatformInterface {
  @override
  final String id;
  MockPolygonAnnotationManagerPlatformInterface(this.id);
}

class MockAnnotationManagerPlatformInterface
    implements AnnotationManagerPlatformInterface {
  int createPointCallCount = 0;
  int createCircleCallCount = 0;
  int createPolylineCallCount = 0;
  int createPolygonCallCount = 0;
  int removeAnnotationManagerCallCount = 0;
  int removeAnnotationManagerByIdCallCount = 0;

  String? lastId;
  String? lastBelow;
  String? lastRemovedId;
  BaseAnnotationManagerPlatformInterface? lastRemovedManager;

  @override
  Future<PointAnnotationManagerPlatformInterface>
      createPointAnnotationManager({String? id, String? below}) async {
    createPointCallCount++;
    lastId = id;
    lastBelow = below;
    return MockPointAnnotationManagerPlatformInterface(id ?? 'point-0');
  }

  @override
  Future<CircleAnnotationManagerPlatformInterface>
      createCircleAnnotationManager({String? id, String? below}) async {
    createCircleCallCount++;
    lastId = id;
    lastBelow = below;
    return MockCircleAnnotationManagerPlatformInterface(id ?? 'circle-0');
  }

  @override
  Future<PolylineAnnotationManagerPlatformInterface>
      createPolylineAnnotationManager({String? id, String? below}) async {
    createPolylineCallCount++;
    lastId = id;
    lastBelow = below;
    return MockPolylineAnnotationManagerPlatformInterface(
        id ?? 'polyline-0');
  }

  @override
  Future<PolygonAnnotationManagerPlatformInterface>
      createPolygonAnnotationManager({String? id, String? below}) async {
    createPolygonCallCount++;
    lastId = id;
    lastBelow = below;
    return MockPolygonAnnotationManagerPlatformInterface(id ?? 'polygon-0');
  }

  @override
  Future<void> removeAnnotationManager(
      BaseAnnotationManagerPlatformInterface manager) async {
    removeAnnotationManagerCallCount++;
    lastRemovedManager = manager;
  }

  @override
  Future<void> removeAnnotationManagerById(String id) async {
    removeAnnotationManagerByIdCallCount++;
    lastRemovedId = id;
  }
}

void main() {
  late MockAnnotationManagerPlatformInterface mockImpl;
  late AnnotationManager annotationManager;

  setUp(() {
    mockImpl = MockAnnotationManagerPlatformInterface();
    annotationManager = AnnotationManager(mockImpl);
  });

  group('AnnotationManager', () {
    test('createPointAnnotationManager delegates to interface', () async {
      final manager = await annotationManager.createPointAnnotationManager(
        id: 'my-points',
        below: 'some-layer',
      );

      expect(mockImpl.createPointCallCount, 1);
      expect(mockImpl.lastId, 'my-points');
      expect(mockImpl.lastBelow, 'some-layer');
      expect(manager, isA<PointAnnotationManager>());
      expect(manager.id, 'my-points');
    });

    test('createCircleAnnotationManager delegates to interface', () async {
      final manager = await annotationManager.createCircleAnnotationManager(
        id: 'my-circles',
      );

      expect(mockImpl.createCircleCallCount, 1);
      expect(mockImpl.lastId, 'my-circles');
      expect(manager, isA<CircleAnnotationManager>());
      expect(manager.id, 'my-circles');
    });

    test('createPolylineAnnotationManager delegates to interface', () async {
      final manager =
          await annotationManager.createPolylineAnnotationManager();

      expect(mockImpl.createPolylineCallCount, 1);
      expect(manager, isA<PolylineAnnotationManager>());
      expect(manager.id, 'polyline-0');
    });

    test('createPolygonAnnotationManager delegates to interface', () async {
      final manager =
          await annotationManager.createPolygonAnnotationManager();

      expect(mockImpl.createPolygonCallCount, 1);
      expect(manager, isA<PolygonAnnotationManager>());
      expect(manager.id, 'polygon-0');
    });

    test('removeAnnotationManager delegates to interface', () async {
      final manager = await annotationManager.createPointAnnotationManager(
        id: 'to-remove',
      );

      await annotationManager.removeAnnotationManager(manager);

      expect(mockImpl.removeAnnotationManagerCallCount, 1);
      expect(mockImpl.lastRemovedManager, isNotNull);
    });

    test('removeAnnotationManagerById delegates to interface', () async {
      await annotationManager.removeAnnotationManagerById('some-id');

      expect(mockImpl.removeAnnotationManagerByIdCallCount, 1);
      expect(mockImpl.lastRemovedId, 'some-id');
    });
  });
}
