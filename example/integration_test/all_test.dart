import 'animation_test.dart' as animation_test;
import 'annotations/circleAnnotation_manager_test.dart'
    as circleAnnotation_manager_test;
import 'annotations/circleAnnotation_test.dart' as circleAnnotation_test;
import 'annotations/pointAnnotation_manager_test.dart'
    as pointAnnotation_manager_test;
import 'annotations/pointAnnotation_test.dart' as pointAnnotation_test;
import 'annotations/polygonAnnotation_manager_test.dart'
    as polygonAnnotation_manager_test;
import 'annotations/polygonAnnotation_test.dart' as polygonAnnotation_test;
import 'annotations/polylineAnnotation_manager_test.dart'
    as polylineAnnotation_manager_test;
import 'annotations/polylineAnnotation_test.dart' as polylineAnnotation_test;
import 'camera_test.dart' as camera_test;
import 'map_interface_test.dart' as map_interface_test;
import 'mapboxMap_test.dart' as mapboxMap_test;
import 'projection_test.dart' as projection_test;
import 'style/layer/background_layer_test.dart' as background_layer_test;
import 'style/layer/circle_layer_test.dart' as circle_layer_test;
import 'style/layer/fill-extrusion_layer_test.dart'
    as fill_extrusion_layer_test;
import 'style/layer/fill_layer_test.dart' as fill_layer_test;
import 'style/layer/heatmap_layer_test.dart' as heatmap_layer_test;
import 'style/layer/hillshade_layer_test.dart' as hillshade_layer_test;
import 'style/layer/line_layer_test.dart' as line_layer_test;
import 'style/layer/location-indicator_layer_test.dart'
    as location_indicator_layer_test;
import 'style/layer/raster_layer_test.dart' as raster_layer_test;
import 'style/layer/sky_layer_test.dart' as sky_layer_test;
import 'style/layer/symbol_layer_test.dart' as symbol_layer_test;
import 'style/light_test.dart' as light_test;
import 'style/source/geojson_source_test.dart' as geojson_source_test;
import 'style/source/image_source_test.dart' as image_source_test;
import 'style/source/raster_source_test.dart' as raster_source_test;
import 'style/source/rasterdem_source_test.dart' as rasterdem_source_test;
import 'style/source/vector_source_test.dart' as vector_source_test;
import 'style/style_test.dart' as style_test;

void main() {
  animation_test.main();
  camera_test.main();
  // location_test.main();
  map_interface_test.main();
  mapboxMap_test.main();
  projection_test.main();

  // annotation tests
  circleAnnotation_manager_test.main();
  circleAnnotation_test.main();
  pointAnnotation_manager_test.main();
  pointAnnotation_test.main();
  polygonAnnotation_manager_test.main();
  polygonAnnotation_test.main();
  polylineAnnotation_manager_test.main();
  polylineAnnotation_test.main();

  // style tests
  light_test.main();
  style_test.main();

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

  // source tests
  vector_source_test.main();
  rasterdem_source_test.main();
  raster_source_test.main();
  image_source_test.main();
  geojson_source_test.main();
}
