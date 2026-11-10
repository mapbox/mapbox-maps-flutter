import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_web/src/http_headers_registry.dart';
import 'package:mapbox_maps_flutter_web/src/http_service_web.dart';

void main() {
  late HttpHeadersRegistry registry;
  late HttpServiceWeb service;

  setUp(() {
    registry = HttpHeadersRegistry();
    service = HttpServiceWeb(registry: registry);
  });

  test('host headers apply to requests for that host', () async {
    await service.setCustomHeadersForHost('tiles.example.com', {
      'Authorization': 'Basic dXNlcjpwYXNz',
    });

    expect(registry.headersFor('https://tiles.example.com/1/2/3.png'), {
      'Authorization': 'Basic dXNlcjpwYXNz',
    });
    expect(registry.headersFor('https://other.example.com/'), isNull);
  });

  test('global headers apply to requests for every host', () async {
    await service.setCustomHeaders({'X-App': 'demo'});

    expect(registry.headersFor('https://any.example.com/'), {'X-App': 'demo'});
  });

  test('clearing removes global and host headers', () async {
    await service.setCustomHeaders({'X-App': 'demo'});
    await service.setCustomHeadersForHost('tiles.example.com', {'X-Key': '1'});

    await service.clearCustomHeaders();

    expect(registry.headersFor('https://tiles.example.com/'), isNull);
  });

  test('an empty host is rejected', () {
    expect(
      () => service.setCustomHeadersForHost('', {'X-Key': '1'}),
      throwsArgumentError,
    );
  });

  test('max requests per host has no effect on web', () async {
    await expectLater(service.setMaxRequestsPerHost(4), completes);
  });
}
