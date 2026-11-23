import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';

void main() {
  // Throws on web.
  late final service = GeofencingService.instance;

  // Features are stored on disk and outlive the test.
  setUp(() => service.clearFeatures());
  tearDown(() async {
    await service.clearFeatures();
    await service.configure(const GeofencingOptions());
  });

  patrolTest('Geofencing options round-trip', skip: kIsWeb, ($) async {
    await service.configure(
      const GeofencingOptions(maximumMonitoredFeatures: 10),
    );
    final options = await service.getOptions();
    expect(options.maximumMonitoredFeatures, 10);
  });

  patrolTest('Geofencing manages features', skip: kIsWeb, ($) async {
    final circleId = await service.addFeature(
      GeofenceFeature.circle(
        id: 'circle',
        center: Point(coordinates: Position(24.94, 60.17)),
        radius: 100,
        dwellTime: const Duration(minutes: 2),
        properties: {'name': 'Helsinki'},
      ),
    );
    expect(circleId, 'circle');

    final polygonId = await service.addFeature(
      GeofenceFeature.polygon(
        id: 'polygon',
        polygon: Polygon(
          coordinates: [
            [
              Position(24.9, 60.1),
              Position(25.0, 60.1),
              Position(25.0, 60.2),
              Position(24.9, 60.1),
            ],
          ],
        ),
      ),
    );
    expect(polygonId, 'polygon');

    final state = await service.getFeature('circle');
    expect(state.feature.id, 'circle');
    expect(state.feature.properties?['name'], 'Helsinki');
    final center = state.feature.geometry as Point;
    expect(center.coordinates.lng, 24.94);
    expect(center.coordinates.lat, 60.17);
    expect(state.timestamp, isNull);

    await service.removeFeature('circle');
    await expectLater(
      service.getFeature('circle'),
      throwsA(isA<GeofencingError>()),
    );
    expect(await service.clearFeatures(), 1);
  });

  patrolTest('Geofencing streams subscribe and cancel', skip: kIsWeb, (
    $,
  ) async {
    final streamErrors = <Object>[];
    final subscriptions = [
      service.entryEvents.listen(null, onError: streamErrors.add),
      service.dwellEvents.listen(null, onError: streamErrors.add),
      service.exitEvents.listen(null, onError: streamErrors.add),
      // Without location permission, the observer may report errors.
      service.errors.listen(null, onError: streamErrors.add),
      GeofencingUtils.userConsentChanges.listen(
        null,
        onError: streamErrors.add,
      ),
    ];
    await Future<void>.delayed(const Duration(seconds: 1));
    for (final subscription in subscriptions) {
      await subscription.cancel();
    }
    expect(streamErrors, isEmpty);

    expect(await GeofencingUtils.getUserConsent(), isA<bool>());
    expect(await GeofencingUtils.isActive(), isA<bool>());
  });
}
