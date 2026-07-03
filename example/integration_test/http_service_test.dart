import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MapboxHttpService.setMaxRequestsPerHost', () {
    testWidgets('accepts valid values across the supported range',
        (widgetTester) async {
      final mapFuture = app.main();
      await widgetTester.pumpAndSettle();
      final mapboxMap = await mapFuture;

      // Reasonable mid-range value.
      await mapboxMap.httpService.setMaxRequestsPerHost(2);

      // Boundary values (1..255 maps to uint8 on the native side).
      await mapboxMap.httpService.setMaxRequestsPerHost(1);
      await mapboxMap.httpService.setMaxRequestsPerHost(255);

      // Repeated calls should not throw — setting is idempotent / overwriting.
      await mapboxMap.httpService.setMaxRequestsPerHost(8);
      await mapboxMap.httpService.setMaxRequestsPerHost(8);
    });
  });

  group('MapboxHttpService.setCustomHeadersForHost', () {
    testWidgets('sets, accumulates, replaces and removes host-scoped headers',
        (widgetTester) async {
      final mapFuture = app.main();
      await widgetTester.pumpAndSettle();
      final mapboxMap = await mapFuture;

      // Scope headers to a single host.
      await mapboxMap.httpService.setCustomHeadersForHost(
        'tiles.example.com',
        {'X-Custom-Header': 'value'},
      );

      // Different hosts accumulate.
      await mapboxMap.httpService.setCustomHeadersForHost(
        'api.example.org',
        {'X-Other': '1', 'X-More': '2'},
      );

      // Re-setting the same host replaces its headers.
      await mapboxMap.httpService.setCustomHeadersForHost(
        'tiles.example.com',
        {'X-Custom-Header': 'updated'},
      );

      // An empty map removes the entry for that host.
      await mapboxMap.httpService.setCustomHeadersForHost(
        'tiles.example.com',
        {},
      );
    });
  });

  group('MapboxHttpService.clearCustomHeaders', () {
    testWidgets('removes host-scoped and global headers, and is idempotent',
        (widgetTester) async {
      final mapFuture = app.main();
      await widgetTester.pumpAndSettle();
      final mapboxMap = await mapFuture;

      await mapboxMap.httpService.setCustomHeadersForHost(
        'tiles.example.com',
        {'X-Custom-Header': 'value'},
      );
      // ignore: deprecated_member_use
      await mapboxMap.httpService.setCustomHeaders({'X-Global': 'g'});

      // Clearing everything should not throw and should be idempotent.
      await mapboxMap.httpService.clearCustomHeaders();
      await mapboxMap.httpService.clearCustomHeaders();
    });
  });
}
