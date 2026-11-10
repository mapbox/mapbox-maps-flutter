import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_web/src/http_headers_registry.dart';

void main() {
  late HttpHeadersRegistry registry;

  setUp(() => registry = HttpHeadersRegistry());

  group('headersFor', () {
    test('matches the host without case sensitivity', () {
      registry.setHeadersForHost('Tiles.Example.com', {'a': '1'});

      expect(registry.headersFor('https://TILES.example.com/1/2/3.pbf'), {
        'a': '1',
      });
    });

    test('does not match a subdomain or a host with the same prefix', () {
      registry.setHeadersForHost('example.com', {'a': '1'});

      expect(registry.headersFor('https://a.example.com/'), isNull);
      expect(registry.headersFor('https://example.com.evil.test/'), isNull);
    });

    test('returns null for a URL that does not parse', () {
      registry.setHeadersForHost('example.com', {'a': '1'});

      expect(registry.headersFor('http://[::1'), isNull);
    });

    test('returns global headers for every host', () {
      registry.setGlobalHeaders({'g': '1'});

      expect(registry.headersFor('https://any.test/'), {'g': '1'});
    });

    test('lets host headers override global headers', () {
      registry.setGlobalHeaders({'x': 'global', 'g': '1'});
      registry.setHeadersForHost('example.com', {'x': 'host'});

      expect(registry.headersFor('https://example.com/'), {
        'x': 'host',
        'g': '1',
      });
    });

    test('removes the host when its headers are set to an empty map', () {
      registry.setHeadersForHost('example.com', {'a': '1'});
      registry.setHeadersForHost('EXAMPLE.com', {});

      expect(registry.headersFor('https://example.com/'), isNull);
    });

    test('returns null after clear', () {
      registry.setGlobalHeaders({'g': '1'});
      registry.setHeadersForHost('example.com', {'a': '1'});
      registry.clear();

      expect(registry.headersFor('https://example.com/'), isNull);
    });

    test('returns a new map on each call', () {
      registry.setHeadersForHost('example.com', {'a': '1'});

      registry.headersFor('https://example.com/')!['accept'] = 'x';

      expect(registry.headersFor('https://example.com/'), {'a': '1'});
    });

    test('does not keep a reference to the caller map', () {
      final headers = {'a': '1'};
      registry.setHeadersForHost('example.com', headers);
      headers['a'] = '2';

      expect(registry.headersFor('https://example.com/'), {'a': '1'});
    });
  });
}
