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
// NOTE: The 15 layer + 6 source integration tests were relocated to
// packages/mapbox_maps_flutter/example/integration_test/style/ in WS1
// because their typed APIs now live in the facade package. The
// hand-written `style/style_test.dart` that used to live here depended
// on the mobile-side addLayer/addSource extensions that moved with
// the layer/source classes; WS5 will rewrite it against the facade.
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
  // annotation tests
  circle_annotation_manager_test.main();
  circle_annotation_test.main();
  point_annotation_manager_test.main();
  point_annotation_test.main();
  polygon_annotation_manager_test.main();
  polygon_annotation_test.main();
  polyline_annotation_manager_test.main();
  polyline_annotation_test.main();

  animation_test.main();
  camera_test.main();
  map_interface_test.main();
  gestures_test.main();
  logo_test.main();
  attribution_test.main();
  compass_test.main();
  scale_bar_test.main();

  // offline_test
  offline_test.main();

  // style tests
  interactive_features_test.main();

  // snapshotter tests
  snapshotter_test.main();

  viewport_test.main();

  // location test has to be at the bottom as on iOS it triggers location permission dialog
  // to be shown which makes tests that rely on QRF/QSF fail
  // TODO: address this properly by granting the location permission somehow
  location_test.main();
}
