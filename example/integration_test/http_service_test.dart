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
}
