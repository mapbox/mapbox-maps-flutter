// ignore_for_file: experimental_member_use, invalid_use_of_visible_for_testing_member
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'patrol.dart';

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() => MapboxOptions.setAccessToken(ACCESS_TOKEN));

  final httpService = MapboxHttpService.instance;

  group('MapboxHttpService.setMaxRequestsPerHost', () {
    patrolTest('accepts any value without a map', ($) async {
      for (final max in [0, 1, 2, 127, 128, 255, 256, 8]) {
        await httpService.setMaxRequestsPerHost(max);
      }
    });
  });

  group('MapboxHttpService.setCustomHeadersForHost', () {
    patrolTest(
      'sets, accumulates, replaces and removes host-scoped headers without a map',
      ($) async {
        await httpService.setCustomHeadersForHost('tiles.example.com', {
          'X-Custom-Header': 'value',
        });
        await httpService.setCustomHeadersForHost('api.example.org', {
          'X-Other': '1',
          'X-More': '2',
        });
        await httpService.setCustomHeadersForHost('tiles.example.com', {
          'X-Custom-Header': 'updated',
        });
        await httpService.setCustomHeadersForHost('tiles.example.com', {});
        await httpService.clearCustomHeaders();
      },
    );

    patrolTest('rejects an empty host', ($) async {
      await expectLater(
        httpService.setCustomHeadersForHost('', {'X-Custom-Header': 'value'}),
        throwsA(kIsWeb ? isA<ArgumentError>() : isA<PlatformException>()),
      );
    });
  });

  group('MapboxHttpService.clearCustomHeaders', () {
    patrolTest('is idempotent', ($) async {
      await httpService.setCustomHeadersForHost('tiles.example.com', {
        'X-Custom-Header': 'value',
      });
      await httpService.clearCustomHeaders();
      await httpService.clearCustomHeaders();
    });
  });
}
