import 'package:mapbox_maps_flutter_examples/transparent_globe_example.dart';
import 'package:mapbox_maps_flutter_examples/transparent_map_example.dart';
import 'package:flutter/foundation.dart';

import 'animated_route_example.dart';
import 'animation_example.dart';
import 'camera_example.dart';
import 'circle_annotations_example.dart';
import 'cluster_example.dart';
import 'custom_header_example.dart';
import 'custom_vector_icons_example.dart';
import 'debug_options_example.dart';
import 'draggable-annotations-example.dart';
import 'edit_polygon_example.dart';
import 'full_map_example.dart';
import 'geojson_line_example.dart';
import 'gestures_example.dart';
import 'image_source_example.dart';
import 'location_example.dart';
import 'platform.dart' show isMobile;
import 'map_interface_example.dart';
import 'map_recorder_example.dart';
import 'model_layer_example.dart';
import 'model_layer_interactions_example.dart';
import 'model_source_example.dart';
import 'offline_map_example.dart';
import 'ornaments_example.dart';
import 'overlay_playground_example.dart';
import 'point_annotations_example.dart';
import 'polygon_annotations_example.dart';
import 'polyline_annotations_example.dart';
import 'projection_example.dart';
import 'simple_map_example.dart';
import 'snapshotter_example.dart';
import 'spinning_globe_example.dart';
import 'standard_style_import_example.dart';
import 'standard_style_interactions_example.dart';
import 'style_example.dart';
import 'tile_json_example.dart';
import 'traffic_layer_example.dart';
import 'traffic_route_line_example.dart';
import 'vector_tile_source_example.dart';
import 'viewport_example.dart';
import 'package:flutter/material.dart';

final List<Example> examples = [
  Example(
    leading: const Icon(Icons.map_outlined),
    title: 'Display a simple map',
    subtitle:
        'Create and display a map that uses the default Mapbox Standard style.',
    builder: (_) => const SimpleMapExample(),
  ),
  Example(
    leading: const Icon(Icons.flight_takeoff),
    title: 'Move camera with viewport',
    subtitle: 'Move the camera to different cities with viewport animations.',
    builder: (_) => const ViewportExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Ornaments',
    builder: (_) => const OrnamentsExample(),
  ),
  Example(
    leading: const Icon(Icons.threesixty_outlined),
    title: 'Spinning Globe',
    subtitle: 'Display your map as an interactive, rotating globe.',
    builder: (_) => const SpinningGlobeExample(),
  ),
  if (isMobile)
    Example(
      leading: const Icon(Icons.wifi_off),
      title: 'Offline Map',
      subtitle:
          'Shows how to use OfflineManager and TileStore to download regions for offline use.',
      builder: (_) => const OfflineMapExample(),
    ),
  Example(
    leading: const Icon(Icons.touch_app),
    title: "Standard Style Interactions",
    subtitle: "Showcase of Standard Style interactions",
    builder: (_) => const StandardStyleInteractionsExample(),
  ),
  if (kIsWeb)
    Example(
      leading: const Icon(Icons.widgets_outlined),
      title: 'Overlay & Cursor Playground',
      subtitle:
          'Cards, dialogs, menus, FABs, every cursor, and transparent/invisible '
          'edge-case zones stacked over the map (web hit-testing).',
      builder: (_) => const OverlayPlaygroundExample(),
    ),
  Example(
    leading: const Icon(Icons.map),
    title: 'CameraManager interface',
    builder: (_) => const CameraExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'High level animation',
    builder: (_) => const AnimationExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Animated route',
    subtitle:
        'Track location, animate a route line, and reveal it with a trim animation.',
    builder: (_) => const AnimatedRouteExample(),
  ),
  Example(
    leading: const Icon(Icons.turn_sharp_left),
    title: 'Style a route showing traffic',
    subtitle: 'Use LineLayer to style a route line with traffic data.',
    builder: (_) => const TrafficRouteLineExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Full screen map',
    builder: (_) => const FullMapExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Style interface',
    builder: (_) => const StyleExample(),
  ),
  Example(
    leading: const Icon(Icons.touch_app),
    title: 'Standard Style Import',
    subtitle: 'Configure the Standard Style and add interactions',
    builder: (_) => const StandardStyleImportExample(),
  ),
  Example(
    leading: const Icon(Icons.network_check),
    title: 'Custom Header Example',
    builder: (_) => const CustomHeaderExample(),
  ),
  Example(
    leading: const Icon(Icons.flag),
    title: 'Custom Vector Icons',
    subtitle:
        'Colorize and interact with vector icons using parameterized SVGs',
    builder: (_) => const CustomVectorIconsExample(),
  ),
  Example(
    leading: const Icon(Icons.view_in_ar),
    title: 'Display a 3D model in a model layer',
    subtitle: 'Showcase the usage of a 3D model layer.',
    builder: (_) => const ModelLayerExample(),
  ),
  Example(
    leading: const Icon(Icons.touch_app),
    title: 'Model Layer Interactions',
    subtitle: 'Showcase of Interactions using custom 3D Model Layers',
    builder: (_) => const ModelLayerInteractionsExample(),
  ),
  Example(
    leading: const Icon(Icons.view_in_ar),
    title: 'Display multiple 3D models with a ModelSource',
    subtitle: 'Showcase the usage of the ModelSource API.',
    builder: (_) => const ModelSourceExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'StyleClusters',
    builder: (_) => const StyleClustersExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Draw GeoJson Line',
    builder: (_) => const DrawGeoJsonLineExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Image source',
    builder: (_) => const ImageSourceExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Tile Json',
    builder: (_) => const TileJsonExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Traffic Layer',
    subtitle: 'Toggle traffic layer on/off',
    builder: (_) => const TrafficLayerExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Vector Tile Source',
    builder: (_) => const VectorTileSourceExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Edit polygon',
    subtitle: 'Edit a polygon by dragging/dropping its vertices',
    builder: (_) => const EditPolygonExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Point Annotations',
    builder: (_) => const PointAnnotationExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Circle annotations',
    builder: (_) => const CircleAnnotationExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Polygon Annotations',
    builder: (_) => const PolygonAnnotationExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Polyline Annotations',
    builder: (_) => const PolylineAnnotationExample(),
  ),
  Example(
    leading: const Icon(Icons.touch_app),
    title: 'Draggable Annotations Example',
    subtitle: 'Demonstrates draggable annotations on the map.',
    builder: (_) => const DraggableAnnotationExample(),
  ),
  Example(
    leading: const Icon(Icons.gesture),
    title: 'Gestures',
    builder: (_) => const GesturesExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'Locate the User',
    subtitle: 'Toggle the user-location puck and follow it as the user moves.',
    builder: (_) => const LocationExample(),
  ),
  Example(
    leading: const Icon(Icons.map),
    title: 'MapInterface',
    builder: (_) => const MapInterfaceExample(),
  ),
  Example(
    leading: const Icon(Icons.language),
    title: 'Transparent globe',
    subtitle:
        'isOpaque=false and textureView=true makes the map transparent, letting an animated Flutter-rendered space background show behind the globe.',
    builder: (_) => const TransparentGlobeExample(),
  ),
  Example(
    leading: const Icon(Icons.waves),
    title: 'Transparent map background',
    subtitle:
        'isOpaque=false and textureView=true make the map transparent, letting an animated Flutter wave texture show through the sea while land stays opaque.',
    builder: (_) => const TransparentMapExample(),
  ),
  if (isMobile) ...[
    Example(
      leading: const Icon(Icons.construction),
      title: 'Map debug options',
      subtitle:
          'This example shows how the map looks with different debug options.',
      builder: (_) => const DebugOptionsExample(),
    ),
    Example(
      leading: const Icon(Icons.fiber_smart_record),
      title: 'Map Recorder',
      subtitle: 'Record and replay map sessions',
      builder: (_) => const MapRecorderExample(),
    ),
    Example(
      leading: const Icon(Icons.map),
      title: 'Projection interface',
      builder: (_) => const ProjectionExample(),
    ),
    Example(
      leading: const Icon(Icons.camera_alt_outlined),
      title: 'Create a static map snapshot',
      subtitle:
          'Create a static, non-interactive image of a map style with specified camera position.',
      builder: (_) => const SnapshotterExample(),
    ),
  ],
];

class Example {
  final Widget leading;
  final String title;
  final String? subtitle;
  final WidgetBuilder builder;

  const Example({
    required this.leading,
    required this.title,
    this.subtitle,
    required this.builder,
  });
}
