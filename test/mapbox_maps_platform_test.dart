import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channelSuffix = 0;
  final channel = MethodChannel('plugins.flutter.io.$channelSuffix');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late List<MethodCall> log;

  setUp(() {
    log = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      log.add(call);
      return null;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  group('MAPBOX_AGENT forwarding', () {
    test(
        'MapboxMap.fromNativeController forwards the compile-time MAPBOX_AGENT '
        'id to native only when --dart-define=MAPBOX_AGENT=<id> was passed to '
        'this test run', () async {
      // kMapboxAgentIdForTesting is a compile-time constant resolved from
      // `--dart-define=MAPBOX_AGENT=<id>`. This test is self-verifying either
      // way: normal `flutter test` runs (no define passed) exercise the
      // no-forwarding branch, while `flutter test --dart-define=MAPBOX_AGENT=<id>`
      // exercises the forwarding branch.
      MapboxMap.fromNativeController(channelSuffix);
      // The forwarding call is fire-and-forget, so let its microtask flush.
      await pumpEventQueue();

      if (kMapboxAgentIdForTesting.isEmpty) {
        expect(log, isEmpty);
      } else {
        expect(log, hasLength(1));
        expect(log.single.method, kSetMapboxAgentIdMethod);
        expect(log.single.arguments, {'agentId': kMapboxAgentIdForTesting});
      }
    });
  });
}
