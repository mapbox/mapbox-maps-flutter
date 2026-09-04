import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// Covers the hand-written (non-Pigeon) platform channel added for the
// native location-provider override. Mirrors the pattern in
// http_service_test.dart for a plain MethodChannel, going through the public
// MapboxMap.fromNativeController factory since LocationSettings itself has
// no public constructor.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channelSuffix = 0;
  final channel = MethodChannel(
    'plugins.flutter.io.mapbox_maps_flutter.externalLocation.$channelSuffix',
  );
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late LocationSettings location;
  late List<MethodCall> log;

  setUp(() {
    log = <MethodCall>[];
    location = MapboxMap.fromNativeController(channelSuffix).location;
    messenger.setMockMethodCallHandler(channel, (call) async {
      log.add(call);
      return null;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('setExternalLocation forwards required fields', () async {
    await location.setExternalLocation(latitude: 1.5, longitude: 2.5);

    expect(log, hasLength(1));
    expect(log.single.method, 'setExternalLocation');
    final args = log.single.arguments as Map;
    expect(args['latitude'], 1.5);
    expect(args['longitude'], 2.5);
    expect(args['timestamp'], isA<double>());
    expect(args.containsKey('accuracy'), isFalse);
    expect(args.containsKey('heading'), isFalse);
    expect(args.containsKey('headingAccuracy'), isFalse);
    expect(args.containsKey('floor'), isFalse);
  });

  test('setExternalLocation forwards all optional fields when provided',
      () async {
    final timestamp = DateTime.utc(2026, 1, 1, 12);
    await location.setExternalLocation(
      latitude: 1.5,
      longitude: 2.5,
      accuracy: 5.0,
      heading: 90.0,
      headingAccuracy: 3.0,
      floor: 2,
      timestamp: timestamp,
    );

    final args = log.single.arguments as Map;
    expect(args['accuracy'], 5.0);
    expect(args['heading'], 90.0);
    expect(args['headingAccuracy'], 3.0);
    expect(args['floor'], 2);
    expect(args['timestamp'], timestamp.millisecondsSinceEpoch.toDouble());
  });

  test('clearExternalLocation calls through with no arguments', () async {
    await location.clearExternalLocation();

    expect(log, hasLength(1));
    expect(log.single.method, 'clearExternalLocation');
    expect(log.single.arguments, isNull);
  });
}
