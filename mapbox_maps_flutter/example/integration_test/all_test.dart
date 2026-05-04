import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'map_events_test.dart' as map_events_test;
import 'map_recorder_test.dart' as map_recorder_test;
import 'projection_test.dart' as projection_test;

// Style layer tests (WS1: relocated from mobile example).
import 'style/layer/background_layer_test.dart' as background_layer_test;
import 'style/layer/circle_layer_test.dart' as circle_layer_test;
import 'style/layer/clip_layer_test.dart' as clip_layer_test;
import 'style/layer/fill_extrusion_layer_test.dart'
    as fill_extrusion_layer_test;
import 'style/layer/fill_layer_test.dart' as fill_layer_test;
import 'style/layer/heatmap_layer_test.dart' as heatmap_layer_test;
import 'style/layer/hillshade_layer_test.dart' as hillshade_layer_test;
import 'style/layer/line_layer_test.dart' as line_layer_test;
import 'style/layer/location_indicator_layer_test.dart'
    as location_indicator_layer_test;
import 'style/layer/model_layer_test.dart' as model_layer_test;
import 'style/layer/raster_layer_test.dart' as raster_layer_test;
import 'style/layer/raster_particle_layer_test.dart'
    as raster_particle_layer_test;
import 'style/layer/sky_layer_test.dart' as sky_layer_test;
import 'style/layer/slot_layer_test.dart' as slot_layer_test;
import 'style/layer/symbol_layer_test.dart' as symbol_layer_test;

// Style source tests.
import 'style/source/geojson_source_test.dart' as geojson_source_test;
import 'style/source/image_source_test.dart' as image_source_test;
import 'style/source/raster_source_test.dart' as raster_source_test;
import 'style/source/rasterarray_source_test.dart' as rasterarray_source_test;
import 'style/source/rasterdem_source_test.dart' as rasterdem_source_test;
import 'style/source/vector_source_test.dart' as vector_source_test;

const ACCESS_TOKEN = String.fromEnvironment('ACCESS_TOKEN');

void main() {
  setUpAll(() {
    MapboxOptions.setAccessToken(ACCESS_TOKEN);
  });

  map_events_test.main();
  map_recorder_test.main();
  projection_test.main();

  // Style layers.
  background_layer_test.main();
  circle_layer_test.main();
  clip_layer_test.main();
  fill_extrusion_layer_test.main();
  fill_layer_test.main();
  heatmap_layer_test.main();
  hillshade_layer_test.main();
  line_layer_test.main();
  location_indicator_layer_test.main();
  model_layer_test.main();
  raster_layer_test.main();
  raster_particle_layer_test.main();
  sky_layer_test.main();
  slot_layer_test.main();
  symbol_layer_test.main();

  // Style sources.
  geojson_source_test.main();
  image_source_test.main();
  raster_source_test.main();
  rasterarray_source_test.main();
  rasterdem_source_test.main();
  vector_source_test.main();
}
