import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockMapboxHttpServicePlatformInterface
    implements MapboxHttpServicePlatformInterface {
  Map<String, String>? lastHeaders;
  int setCustomHeadersCallCount = 0;

  int? lastMax;
  int setMaxRequestsPerHostCallCount = 0;

  @override
  Future<void> setCustomHeaders(Map<String, String> headers) async {
    setCustomHeadersCallCount++;
    lastHeaders = headers;
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
}
