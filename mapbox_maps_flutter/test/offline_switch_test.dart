import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockOfflineSwitchPlatformInterface
    implements OfflineSwitchPlatformInterface {
  int isMapboxStackConnectedCallCount = 0;
  int setMapboxStackConnectedCallCount = 0;

  bool _isConnected = true;
  bool? lastIsConnected;

  @override
  Future<bool> get isMapboxStackConnected async {
    isMapboxStackConnectedCallCount++;
    return _isConnected;
  }

  @override
  Future<void> setMapboxStackConnected(bool isConnected) async {
    setMapboxStackConnectedCallCount++;
    lastIsConnected = isConnected;
    _isConnected = isConnected;
  }
}

void main() {
  late MockOfflineSwitchPlatformInterface mockImpl;
  late OfflineSwitch offlineSwitch;

  setUp(() {
    mockImpl = MockOfflineSwitchPlatformInterface();
    offlineSwitch = OfflineSwitch(mockImpl);
  });

  group('OfflineSwitch', () {
    test('isMapboxStackConnected delegates to interface', () async {
      final result = await offlineSwitch.isMapboxStackConnected;

      expect(mockImpl.isMapboxStackConnectedCallCount, 1);
      expect(result, true);
    });

    test('setMapboxStackConnected delegates to interface', () async {
      await offlineSwitch.setMapboxStackConnected(false);

      expect(mockImpl.setMapboxStackConnectedCallCount, 1);
      expect(mockImpl.lastIsConnected, false);
    });

    test('setMapboxStackConnected updates state', () async {
      await offlineSwitch.setMapboxStackConnected(false);
      final result = await offlineSwitch.isMapboxStackConnected;

      expect(result, false);
    });
  });
}
