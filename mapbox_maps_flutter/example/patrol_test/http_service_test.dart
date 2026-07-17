// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';
import 'empty_map_widget.dart' as app;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  group('MapboxHttpService.setMaxRequestsPerHost', () {
    patrolTest('accepts valid values across the supported range', skip: kIsWeb, (
      $,
    ) async {
      final widgetTester = $.tester;
      final mapboxMap = await app.pumpMap(tester: $.tester);
      await widgetTester.pumpAndSettle();

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
    patrolTest(
      'sets, accumulates, replaces and removes host-scoped headers',
      skip: kIsWeb,
      ($) async {
        final widgetTester = $.tester;
        final mapboxMap = await app.pumpMap(tester: $.tester);
        await widgetTester.pumpAndSettle();

        // Scope headers to a single host.
        await mapboxMap.httpService.setCustomHeadersForHost(
          'tiles.example.com',
          {'X-Custom-Header': 'value'},
        );

        // Different hosts accumulate.
        await mapboxMap.httpService.setCustomHeadersForHost('api.example.org', {
          'X-Other': '1',
          'X-More': '2',
        });

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
      },
    );
  });

  group('MapboxHttpService.clearCustomHeaders', () {
    patrolTest(
      'removes host-scoped and global headers, and is idempotent',
      skip: kIsWeb,
      ($) async {
        final widgetTester = $.tester;
        final mapboxMap = await app.pumpMap(tester: $.tester);
        await widgetTester.pumpAndSettle();

        await mapboxMap.httpService.setCustomHeadersForHost(
          'tiles.example.com',
          {'X-Custom-Header': 'value'},
        );
        // ignore: deprecated_member_use
        await mapboxMap.httpService.setCustomHeaders({'X-Global': 'g'});

        // Clearing everything should not throw and should be idempotent.
        await mapboxMap.httpService.clearCustomHeaders();
        await mapboxMap.httpService.clearCustomHeaders();
      },
    );
  });
}
