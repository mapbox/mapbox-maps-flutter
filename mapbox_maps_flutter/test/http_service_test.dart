import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

class MockMapboxHttpServicePlatformInterface
    implements MapboxHttpServicePlatformInterface {
  Map<String, String>? lastHeaders;
  int setCustomHeadersCallCount = 0;

  int? lastMax;
  int setMaxRequestsPerHostCallCount = 0;

  final Map<String, Map<String, String>> hostHeaders = {};
  int setCustomHeadersForHostCallCount = 0;

  int clearCustomHeadersCallCount = 0;

  @override
  Future<void> setCustomHeaders(Map<String, String> headers) async {
    setCustomHeadersCallCount++;
    lastHeaders = headers;
  }

  @override
  Future<void> setCustomHeadersForHost(
    String host,
    Map<String, String> headers,
  ) async {
    setCustomHeadersForHostCallCount++;
    if (headers.isEmpty) {
      hostHeaders.remove(host);
    } else {
      hostHeaders[host] = headers;
    }
  }

  @override
  Future<void> clearCustomHeaders() async {
    clearCustomHeadersCallCount++;
    lastHeaders = null;
    hostHeaders.clear();
  }

  @override
  Future<void> setMaxRequestsPerHost(int max) async {
    setMaxRequestsPerHostCallCount++;
    lastMax = max;
  }
}

/// Provides only the process-wide HTTP service.
base class FakeMapboxMapsFlutterPlatform extends MapboxMapsFlutterPlatform {
  FakeMapboxMapsFlutterPlatform(this.httpService);

  @override
  final MapboxHttpServicePlatformInterface httpService;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockMapboxHttpServicePlatformInterface mockImpl;
  late MapboxHttpService httpService;

  setUp(() {
    mockImpl = MockMapboxHttpServicePlatformInterface();
    httpService = MapboxHttpService(mockImpl);
  });

  group('MapboxHttpService', () {
    test('setMaxRequestsPerHost delegates to interface', () async {
      await httpService.setMaxRequestsPerHost(8);

      expect(mockImpl.setMaxRequestsPerHostCallCount, 1);
      expect(mockImpl.lastMax, 8);
    });

    test('setMaxRequestsPerHost can be called multiple times', () async {
      await httpService.setMaxRequestsPerHost(2);
      await httpService.setMaxRequestsPerHost(16);

      expect(mockImpl.setMaxRequestsPerHostCallCount, 2);
      expect(mockImpl.lastMax, 16);
    });

    test('setMaxRequestsPerHost accepts the range limits', () async {
      await httpService.setMaxRequestsPerHost(1);
      await httpService.setMaxRequestsPerHost(255);

      expect(mockImpl.setMaxRequestsPerHostCallCount, 2);
    });

    test('setMaxRequestsPerHost clamps values outside 1..255', () async {
      await httpService.setMaxRequestsPerHost(0);
      expect(mockImpl.lastMax, 1);

      await httpService.setMaxRequestsPerHost(1000);
      expect(mockImpl.lastMax, 255);
    });
  });

  group('MapboxHttpService.setCustomHeadersForHost', () {
    test(
      'sets, accumulates, replaces and removes host-scoped headers',
      () async {
        // Scope headers to a single host.
        await httpService.setCustomHeadersForHost('tiles.example.com', {
          'X-Custom-Header': 'value',
        });

        // Different hosts accumulate.
        await httpService.setCustomHeadersForHost('api.example.org', {
          'X-Other': '1',
          'X-More': '2',
        });

        expect(mockImpl.hostHeaders['tiles.example.com'], {
          'X-Custom-Header': 'value',
        });
        expect(mockImpl.hostHeaders['api.example.org'], {
          'X-Other': '1',
          'X-More': '2',
        });

        // Re-setting the same host replaces its headers.
        await httpService.setCustomHeadersForHost('tiles.example.com', {
          'X-Custom-Header': 'updated',
        });
        expect(mockImpl.hostHeaders['tiles.example.com'], {
          'X-Custom-Header': 'updated',
        });

        // An empty map removes the entry for that host.
        await httpService.setCustomHeadersForHost('tiles.example.com', {});
        expect(mockImpl.hostHeaders.containsKey('tiles.example.com'), false);

        expect(mockImpl.setCustomHeadersForHostCallCount, 4);
      },
    );
  });

  group('MapboxHttpService.clearCustomHeaders', () {
    test('removes host-scoped and global headers, and is idempotent', () async {
      await httpService.setCustomHeadersForHost('tiles.example.com', {
        'X-Custom-Header': 'value',
      });
      await httpService.setCustomHeadersForHost('api.example.org', {
        'X-Global': 'g',
      });

      // Clearing everything should not throw and should be idempotent.
      await httpService.clearCustomHeaders();
      await httpService.clearCustomHeaders();

      expect(mockImpl.hostHeaders, isEmpty);
      expect(mockImpl.clearCustomHeadersCallCount, 2);
    });
  });

  group('MapboxHttpService.instance', () {
    test('sends calls to the platform HTTP service without a map', () async {
      final platformImpl = MockMapboxHttpServicePlatformInterface();
      MapboxMapsFlutterPlatform.instance = FakeMapboxMapsFlutterPlatform(
        platformImpl,
      );

      await MapboxHttpService.instance.setCustomHeadersForHost(
        'tiles.example.com',
        {'Authorization': 'Basic dXNlcjpwYXNz'},
      );

      expect(platformImpl.hostHeaders, {
        'tiles.example.com': {'Authorization': 'Basic dXNlcjpwYXNz'},
      });
    });
  });
}
