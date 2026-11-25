import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// A fake host that accepts setup and listener calls, fails each load with
/// [loadErrorCode], and records the progress channel traffic.
class _FakeOfflineHost {
  _FakeOfflineHost(this.loadErrorCode) {
    TestDefaultBinaryMessengerBinding
            .instance
            .defaultBinaryMessenger
            .allMessagesHandler =
        _handle;
  }

  final String loadErrorCode;
  final List<String> progressChannels = [];
  final List<String> progressCalls = [];

  static const _messageCodec = StandardMessageCodec();
  static const _methodCodec = StandardMethodCodec();

  Future<ByteData?> _handle(
    String channel,
    MessageHandler? handler,
    ByteData? message,
  ) async {
    if (channel.startsWith('com.mapbox.maps.flutter/')) {
      progressChannels.add(channel);
      progressCalls.add(_methodCodec.decodeMethodCall(message).method);
      return _methodCodec.encodeSuccessEnvelope(null);
    }
    final method = channel
        .split('.')
        .firstWhere(
          (part) => part.startsWith('load') || part.startsWith('estimate'),
          orElse: () => '',
        );
    if (method.isNotEmpty) {
      return _messageCodec.encodeMessage([loadErrorCode, 'host failure', null]);
    }
    return _messageCodec.encodeMessage([null]);
  }

  void dispose() {
    TestDefaultBinaryMessengerBinding
            .instance
            .defaultBinaryMessenger
            .allMessagesHandler =
        null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final loadOptions = TileRegionLoadOptions(
    acceptExpired: false,
    networkRestriction: NetworkRestriction.NONE,
  );

  test('estimate progress uses a channel per operation and closes on '
      'failure', () async {
    final host = _FakeOfflineHost('REQUEST_FAILED');
    addTearDown(host.dispose);
    final tileStore = await TileStore.createDefault();

    final estimate = tileStore.estimateTileRegion(
      'region',
      loadOptions,
      null,
      (_) {},
    );

    await expectLater(estimate, throwsA(isA<PlatformException>()));
    await pumpEventQueue();
    expect(host.progressCalls, ['listen', 'cancel']);
    expect(
      host.progressChannels.first,
      matches(RegExp(r'/tile-region-estimate-\d+$')),
    );
  });

  test('load progress closes when the host reports a cancel', () async {
    final host = _FakeOfflineHost('CANCELED');
    addTearDown(host.dispose);
    final tileStore = await TileStore.createDefault();

    final load = tileStore.loadTileRegion('region', loadOptions, (_) {});

    await expectLater(
      load,
      throwsA(
        isA<PlatformException>().having((e) => e.code, 'code', 'CANCELED'),
      ),
    );
    await pumpEventQueue();
    expect(host.progressCalls, ['listen', 'cancel']);
    expect(host.progressChannels.first, matches(RegExp(r'/tile-region-\d+$')));
  });

  test('style pack progress closes when the load fails', () async {
    final host = _FakeOfflineHost('REQUEST_FAILED');
    addTearDown(host.dispose);
    final offlineManager = await OfflineManager.create();

    final load = offlineManager.loadStylePack(
      'mapbox://styles/mapbox/standard',
      StylePackLoadOptions(acceptExpired: false),
      (_) {},
    );

    await expectLater(load, throwsA(isA<PlatformException>()));
    await pumpEventQueue();
    expect(host.progressCalls, ['listen', 'cancel']);
    expect(host.progressChannels.first, matches(RegExp(r'/style-pack-\d+$')));
  });
}
