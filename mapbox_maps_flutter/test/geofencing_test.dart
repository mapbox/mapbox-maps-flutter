import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

class _MockGeofencing implements GeofencingPlatformInterface {
  final added = <Feature>[];
  int? configuredMaximum;

  final entries = StreamController<GeofencingEvent>.broadcast();
  final dwells = StreamController<GeofencingEvent>.broadcast();
  final exits = StreamController<GeofencingEvent>.broadcast();
  final errorEvents = StreamController<GeofencingError>.broadcast();

  @override
  Stream<GeofencingEvent> get entryEvents => entries.stream;

  @override
  Stream<GeofencingEvent> get dwellEvents => dwells.stream;

  @override
  Stream<GeofencingEvent> get exitEvents => exits.stream;

  @override
  Stream<GeofencingError> get errors => errorEvents.stream;

  @override
  Stream<bool> get consentChanges => const Stream.empty();

  @override
  Future<void> configure(int maximumMonitoredFeatures) async {
    configuredMaximum = maximumMonitoredFeatures;
  }

  @override
  Future<int> getOptions() async => 100000;

  @override
  Future<String> addFeature(Feature feature) async {
    added.add(feature);
    return '${feature.id}';
  }

  @override
  Future<GeofenceState> getFeature(String identifier) async {
    return GeofenceState(feature: Feature(id: identifier));
  }

  @override
  Future<void> removeFeature(String identifier) async {}

  @override
  Future<int> clearFeatures() async => 2;

  @override
  Future<bool> get consent async => true;

  @override
  Future<bool> get isActive async => false;
}

GeofencingEvent _event(String id) {
  return GeofencingEvent(
    feature: Feature(id: id),
    timestamp: DateTime.fromMillisecondsSinceEpoch(1),
  );
}

void main() {
  late _MockGeofencing mock;
  late GeofencingService service;

  setUp(() {
    mock = _MockGeofencing();
    service = GeofencingService(mock);
  });

  test('circle writes the radius and dwell time into properties', () async {
    final id = await service.addFeature(
      GeofenceFeature.circle(
        id: 'store',
        center: Point(coordinates: Position(11.78, 48.35)),
        radius: 100,
        dwellTime: const Duration(minutes: 10),
        properties: {'name': 'Store'},
      ),
    );

    expect(id, 'store');
    final sent = mock.added.single;
    expect(sent.geometry, isA<Point>());
    expect(sent.properties, {
      'name': 'Store',
      GeofencingPropertiesKeys.dwellTimeKey: 10,
      GeofencingPropertiesKeys.pointRadiusKey: 100,
    });
  });

  test('polygon without a dwell time has no geofencing properties', () async {
    await service.addFeature(
      GeofenceFeature.polygon(
        id: 'area',
        polygon: Polygon(
          coordinates: [
            [Position(0, 0), Position(1, 0), Position(1, 1), Position(0, 0)],
          ],
        ),
      ),
    );

    final sent = mock.added.single;
    expect(sent.geometry, isA<Polygon>());
    expect(sent.properties, isEmpty);
  });

  test('addFeature sends plain features as they are', () async {
    final feature = Feature(id: 'area');
    await service.addFeature(feature);

    expect(mock.added.single, same(feature));
  });

  test('configure and clearFeatures pass through', () async {
    await service.configure(
      const GeofencingOptions(maximumMonitoredFeatures: 10),
    );

    expect(mock.configuredMaximum, 10);
    expect((await service.getOptions()).maximumMonitoredFeatures, 100000);
    expect(await service.clearFeatures(), 2);
  });

  test('GeofencingEvent decodes nested codec maps', () {
    final event = GeofencingEvent.decode([
      <Object?, Object?>{
        'type': 'Feature',
        'id': 'store',
        'geometry': <Object?, Object?>{
          'type': 'Point',
          'coordinates': <Object?>[11.78, 48.35],
        },
        'properties': <Object?, Object?>{'name': 'Store'},
      },
      1,
    ]);

    expect(event.feature.id, 'store');
    expect(event.feature.geometry, isA<Point>());
    expect(event.timestamp, DateTime.fromMillisecondsSinceEpoch(1));
  });

  test('each stream comes from its platform stream', () async {
    final entries = <String>[];
    final dwells = <String>[];
    final exits = <String>[];
    final errors = <GeofencingErrorType>[];
    service.entryEvents.listen((event) => entries.add('${event.feature.id}'));
    service.dwellEvents.listen((event) => dwells.add('${event.feature.id}'));
    service.exitEvents.listen((event) => exits.add('${event.feature.id}'));
    service.errors.listen((error) => errors.add(error.type));

    mock.entries.add(_event('a'));
    mock.dwells.add(_event('b'));
    mock.exits.add(_event('c'));
    mock.errorEvents.add(
      const GeofencingError(
        type: GeofencingErrorType.locationServiceUnauthorized,
        message: '',
      ),
    );
    await pumpEventQueue();

    expect(entries, ['a']);
    expect(dwells, ['b']);
    expect(exits, ['c']);
    expect(errors, [GeofencingErrorType.locationServiceUnauthorized]);
  });
}
