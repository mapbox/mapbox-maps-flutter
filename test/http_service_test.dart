import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channelSuffix = 0;
  final channel = MethodChannel('plugins.flutter.io.$channelSuffix');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late MapboxHttpService service;
  late List<MethodCall> log;

  setUp(() {
    log = <MethodCall>[];
    service = MapboxHttpService(
      binaryMessenger: messenger,
      channelSuffix: channelSuffix,
    );
    messenger.setMockMethodCallHandler(channel, (call) async {
      log.add(call);
      return null;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('setCustomHeadersForHost forwards host and headers', () async {
    await service.setCustomHeadersForHost(
      'tiles.example.com',
      {'X-Custom-Header': 'value'},
    );

    expect(log, hasLength(1));
    expect(log.single.method, 'map#setCustomHeadersForHost');
    expect(log.single.arguments, {
      'host': 'tiles.example.com',
      'headers': {'X-Custom-Header': 'value'},
    });
  });

  test('setCustomHeadersForHost forwards an empty map to clear a host',
      () async {
    await service.setCustomHeadersForHost('tiles.example.com', {});

    expect(log.single.method, 'map#setCustomHeadersForHost');
    expect(log.single.arguments, {
      'host': 'tiles.example.com',
      'headers': <String, String>{},
    });
  });

  test('clearCustomHeaders invokes the clear channel method', () async {
    await service.clearCustomHeaders();

    expect(log, hasLength(1));
    expect(log.single.method, 'map#clearCustomHeaders');
  });

  test('deprecated setCustomHeaders forwards headers globally', () async {
    // ignore: deprecated_member_use_from_same_package
    await service.setCustomHeaders({'X-Custom-Header': 'value'});

    expect(log.single.method, 'map#setCustomHeaders');
    expect(log.single.arguments, {
      'headers': {'X-Custom-Header': 'value'},
    });
  });

  test('setCustomHeadersForHost throws MISSING_IMPLEMENTATION when unhandled',
      () async {
    // No handler registered for the channel -> MissingPluginException.
    messenger.setMockMethodCallHandler(channel, null);

    await expectLater(
      () => service.setCustomHeadersForHost('tiles.example.com', {'a': 'b'}),
      throwsA(isA<PlatformException>()
          .having((e) => e.code, 'code', 'MISSING_IMPLEMENTATION')),
    );
  });

  test('clearCustomHeaders throws MISSING_IMPLEMENTATION when unhandled',
      () async {
    messenger.setMockMethodCallHandler(channel, null);

    await expectLater(
      () => service.clearCustomHeaders(),
      throwsA(isA<PlatformException>()
          .having((e) => e.code, 'code', 'MISSING_IMPLEMENTATION')),
    );
  });
}
