import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

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

void main() {
  late MockMapboxHttpServicePlatformInterface mockImpl;
  late MapboxHttpService httpService;

  setUp(() {
    mockImpl = MockMapboxHttpServicePlatformInterface();
    httpService = MapboxHttpService(mockImpl);
  });

  group('MapboxHttpService', () {
    test('setCustomHeaders delegates to interface', () async {
      final headers = {'Authorization': 'Bearer token123'};

      await httpService.setCustomHeaders(headers);

      expect(mockImpl.setCustomHeadersCallCount, 1);
      expect(mockImpl.lastHeaders, same(headers));
    });

    test('setCustomHeaders can be called multiple times', () async {
      await httpService.setCustomHeaders({'Key1': 'Value1'});
      await httpService.setCustomHeaders({'Key2': 'Value2'});

      expect(mockImpl.setCustomHeadersCallCount, 2);
      expect(mockImpl.lastHeaders, {'Key2': 'Value2'});
    });

    test('setCustomHeaders passes all headers correctly', () async {
      final headers = {
        'Authorization': 'Bearer token',
        'X-Custom-Header': 'custom-value',
        'Accept': 'application/json',
      };

      await httpService.setCustomHeaders(headers);

      final passed = mockImpl.lastHeaders!;
      expect(passed['Authorization'], 'Bearer token');
      expect(passed['X-Custom-Header'], 'custom-value');
      expect(passed['Accept'], 'application/json');
    });

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
  });

  group('MapboxHttpService.setCustomHeadersForHost', () {
    test('sets, accumulates, replaces and removes host-scoped headers',
        () async {
      // Scope headers to a single host.
      await httpService.setCustomHeadersForHost(
        'tiles.example.com',
        {'X-Custom-Header': 'value'},
      );

      // Different hosts accumulate.
      await httpService.setCustomHeadersForHost(
        'api.example.org',
        {'X-Other': '1', 'X-More': '2'},
      );

      expect(mockImpl.hostHeaders['tiles.example.com'],
          {'X-Custom-Header': 'value'});
      expect(mockImpl.hostHeaders['api.example.org'],
          {'X-Other': '1', 'X-More': '2'});

      // Re-setting the same host replaces its headers.
      await httpService.setCustomHeadersForHost(
        'tiles.example.com',
        {'X-Custom-Header': 'updated'},
      );
      expect(mockImpl.hostHeaders['tiles.example.com'],
          {'X-Custom-Header': 'updated'});

      // An empty map removes the entry for that host.
      await httpService.setCustomHeadersForHost(
        'tiles.example.com',
        {},
      );
      expect(mockImpl.hostHeaders.containsKey('tiles.example.com'), false);

      expect(mockImpl.setCustomHeadersForHostCallCount, 4);
    });
  });

  group('MapboxHttpService.clearCustomHeaders', () {
    test('removes host-scoped and global headers, and is idempotent',
        () async {
      await httpService.setCustomHeadersForHost(
        'tiles.example.com',
        {'X-Custom-Header': 'value'},
      );
      // ignore: deprecated_member_use
      await httpService.setCustomHeaders({'X-Global': 'g'});

      // Clearing everything should not throw and should be idempotent.
      await httpService.clearCustomHeaders();
      await httpService.clearCustomHeaders();

      expect(mockImpl.hostHeaders, isEmpty);
      expect(mockImpl.lastHeaders, isNull);
      expect(mockImpl.clearCustomHeadersCallCount, 2);
    });
  });
}
