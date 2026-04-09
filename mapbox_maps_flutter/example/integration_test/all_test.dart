import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'map_events_test.dart' as map_events_test;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() {
    MapboxOptions.setAccessToken(ACCESS_TOKEN);
  });

  map_events_test.main();
}
