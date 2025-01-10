import 'animation_test.dart' as animation_test;
import 'annotations/circle_annotation_manager_test.dart'
    as circle_annotation_manager_test;
import 'annotations/circle_annotation_test.dart' as circle_annotation_test;
import 'annotations/point_annotation_manager_test.dart'
    as point_annotation_manager_test;
import 'annotations/point_annotation_test.dart' as point_annotation_test;
import 'annotations/polygon_annotation_manager_test.dart'
    as polygon_annotation_manager_test;
import 'annotations/polygon_annotation_test.dart' as polygon_annotation_test;
import 'annotations/polyline_annotation_manager_test.dart'
    as polyline_annotation_manager_test;
import 'annotations/polyline_annotation_test.dart' as polyline_annotation_test;
import 'camera_test.dart' as camera_test;
import 'gestures_test.dart' as gestures_test;
import 'map_interface_test.dart' as map_interface_test;
import 'projection_test.dart' as projection_test;
import 'style/layer/background_layer_test.dart' as background_layer_test;
import 'style/layer/circle_layer_test.dart' as circle_layer_test;
import 'style/layer/fill_extrusion_layer_test.dart'
    as fill_extrusion_layer_test;
import 'style/layer/fill_layer_test.dart' as fill_layer_test;
import 'style/layer/heatmap_layer_test.dart' as heatmap_layer_test;
import 'style/layer/hillshade_layer_test.dart' as hillshade_layer_test;
import 'style/layer/line_layer_test.dart' as line_layer_test;
import 'style/layer/location_indicator_layer_test.dart'
    as location_indicator_layer_test;
import 'style/layer/raster_layer_test.dart' as raster_layer_test;
import 'style/layer/sky_layer_test.dart' as sky_layer_test;
import 'style/layer/symbol_layer_test.dart' as symbol_layer_test;
import 'style/layer/model_layer_test.dart' as model_layer_test;
import 'style/layer/slot_layer_test.dart' as slot_layer_test;
import 'style/layer/raster_particle_layer_test.dart'
    as raster_particle_layer_test;
import 'style/layer/clip_layer_test.dart' as clip_layer_test;
import 'style/source/geojson_source_test.dart' as geojson_source_test;
import 'style/source/image_source_test.dart' as image_source_test;
import 'style/source/raster_source_test.dart' as raster_source_test;
import 'style/source/rasterdem_source_test.dart' as rasterdem_source_test;
import 'style/source/rasterarray_source_test.dart' as rasterarray_source_test;
import 'style/source/vector_source_test.dart' as vector_source_test;
import 'style/style_test.dart' as style_test;
import 'location_test.dart' as location_test;
import 'logo_test.dart' as logo_test;
import 'attribution_test.dart' as attribution_test;
import 'compass_test.dart' as compass_test;
import 'scale_bar_test.dart' as scale_bar_test;
import 'offline_test.dart' as offline_test;
import 'snapshotter/snapshotter_test.dart' as snapshotter_test;
import 'viewport_test.dart' as viewport_test;
import 'interactive_features_test.dart' as interactive_features_test;

void main() {
  animation_test.main();
  camera_test.main();
  map_interface_test.main();
  projection_test.main();
  gestures_test.main();
  logo_test.main();
  attribution_test.main();
  compass_test.main();
  scale_bar_test.main();

  // offline_test
  offline_test.main();
  // annotation tests
  circle_annotation_manager_test.main();
  circle_annotation_test.main();
  point_annotation_manager_test.main();
  point_annotation_test.main();
  polygon_annotation_manager_test.main();
  polygon_annotation_test.main();
  polyline_annotation_manager_test.main();
  polyline_annotation_test.main();

  // style tests
  style_test.main();
  interactive_features_test.main();

  // layer tests
  background_layer_test.main();
  circle_layer_test.main();
  fill_extrusion_layer_test.main();
  symbol_layer_test.main();
  sky_layer_test.main();
  raster_layer_test.main();
  location_indicator_layer_test.main();
  line_layer_test.main();
  hillshade_layer_test.main();
  heatmap_layer_test.main();
  fill_layer_test.main();
  model_layer_test.main();
  slot_layer_test.main();
  raster_particle_layer_test.main();
  clip_layer_test.main();

  // source tests
  vector_source_test.main();
  rasterdem_source_test.main();
  raster_source_test.main();
  rasterarray_source_test.main();
  image_source_test.main();
  geojson_source_test.main();

  // snapshotter tests
  snapshotter_test.main();

  viewport_test.main();

  // location test has to be at the bottom as on iOS it triggers location permission dialog
  // to be shown which makes tests that rely on QRF/QSF fail
  // TODO: address this properly by granting the location permission somehow
  location_test.main();
}
