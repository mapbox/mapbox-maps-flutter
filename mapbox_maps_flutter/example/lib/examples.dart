import 'package:flutter/material.dart';

import 'animations/animated_route_example.dart';
import 'animations/transparency_example.dart';
import 'camera/camera_example.dart';
import 'camera/camera_playground_example.dart';
import 'camera/projection_example.dart';
import 'docs/circle_annotations_example.dart';
import 'docs/full_map_example.dart';
import 'docs/geojson_line_example.dart';
import 'docs/location_example.dart';
import 'docs/model_layer_example.dart';
import 'docs/offline_map_example.dart';
import 'docs/snapshotter_example.dart';
import 'docs/standard_style_interactions_example.dart';
import 'docs/traffic_route_line_example.dart';
import 'docs/vector_tile_source_example.dart';
import 'example.dart';
import 'getting_started/ornaments_example.dart';
import 'getting_started/simple_map_example.dart';
import 'interaction/annotations_example.dart';
import 'interaction/gestures_example.dart';
import 'interaction/overlay_playground_example.dart';
import 'platform.dart' show isMobile, isWeb;
import 'platform/debug_options_example.dart';
import 'platform/map_interface_example.dart';
import 'platform/map_recorder_example.dart';
import 'styles/indoor_example.dart';
import 'styles/model_comparison_example.dart';
import 'styles/sources_example.dart';
import 'styles/standard_style_import_example.dart';
import 'styles/style_example.dart';
import 'styles/style_images_example.dart';

/// Examples available on the current platform.
///
/// An entry guarded by [isMobile] uses an API with no web implementation. An
/// example where only a part is native-only stays listed, and disables that
/// part.
final List<Example> examples = [
  Example(
    slug: 'simple_map',
    category: ExampleCategory.gettingStarted,
    leading: const Icon(Icons.map_outlined),
    title: 'Display a simple map',
    subtitle:
        'Create and display a map that uses the default Mapbox Standard style.',
    builder: (_) => const SimpleMapExample(),
  ),
  Example(
    slug: 'full_map',
    category: ExampleCategory.docs,
    docsUrl: 'https://docs.mapbox.com/flutter/maps/examples/full_map/',
    leading: const Icon(Icons.fullscreen),
    title: 'Display a full screen map',
    subtitle: 'Switch the basemap light preset and observe map events.',
    builder: (_) => const FullMapExample(),
  ),
  Example(
    slug: 'camera_playground',
    category: ExampleCategory.camera,
    leading: const Icon(Icons.videocam_outlined),
    title: 'Camera playground',
    subtitle:
        'Imperative animations, declarative viewport states and a globe that '
        'spins on its own.',
    builder: (_) => const CameraPlaygroundExample(),
  ),
  Example(
    slug: 'camera',
    category: ExampleCategory.camera,
    leading: const Icon(Icons.videocam_outlined),
    title: 'CameraManager interface',
    subtitle: 'Drive the camera from sliders and read the state back.',
    builder: (_) => const CameraExample(),
  ),
  Example(
    slug: 'ornaments',
    category: ExampleCategory.gettingStarted,
    leading: const Icon(Icons.explore_outlined),
    title: 'Ornaments',
    subtitle:
        'Toggle and reposition the compass, scale bar, logo and '
        'attribution.',
    builder: (_) => const OrnamentsExample(),
  ),
  Example(
    slug: 'indoor',
    category: ExampleCategory.styles,
    leading: const Icon(Icons.layers_outlined),
    title: 'Indoor floors',
    subtitle:
        'Switch floors of a supported indoor venue with the built-in selector, and observe changes via mapboxMap.indoor.',
    builder: (_) => const IndoorExample(),
  ),
  Example(
    slug: 'gestures',
    category: ExampleCategory.interaction,
    leading: const Icon(Icons.gesture),
    title: 'Gestures',
    subtitle: 'Configure gesture settings and observe gesture events.',
    builder: (_) => const GesturesExample(),
  ),
  Example(
    slug: 'standard_interactions',
    category: ExampleCategory.docs,
    docsUrl:
        'https://docs.mapbox.com/flutter/maps/examples/standard_interactions/',
    leading: const Icon(Icons.touch_app),
    title: 'Standard style interactions',
    subtitle: 'Add interactions to the predefined Standard featuresets.',
    builder: (_) => const StandardStyleInteractionsExample(),
  ),
  Example(
    slug: 'standard_style_import',
    category: ExampleCategory.styles,
    leading: const Icon(Icons.settings_suggest_outlined),
    title: 'Standard style import',
    subtitle: 'Tune lighting and labels, then tap a place label to inspect it.',
    builder: (_) => const StandardStyleImportExample(),
  ),
  Example(
    slug: 'style',
    category: ExampleCategory.styles,
    leading: const Icon(Icons.layers_outlined),
    title: 'Style interface',
    subtitle: 'Swap the basemap, restyle your own layer, light a 3D scene.',
    builder: (_) => const StyleExample(),
  ),
  Example(
    slug: 'style_images',
    category: ExampleCategory.styles,
    leading: const Icon(Icons.image_outlined),
    title: 'Style images',
    subtitle:
        'Runtime StyleImage.rgba/.bytes icons you can hide and re-add, plus '
        'colorized vector icon flags.',
    builder: (_) => const StyleImagesExample(),
  ),
  Example(
    slug: 'sources',
    category: ExampleCategory.styles,
    leading: const Icon(Icons.storage_outlined),
    title: 'Data sources',
    subtitle:
        'GeoJSON, vector tiles, raster tiles, an image source, clustered '
        'points and live traffic.',
    builder: (_) => const SourcesExample(),
  ),
  Example(
    slug: 'geojson_line',
    category: ExampleCategory.docs,
    docsUrl: 'https://docs.mapbox.com/flutter/maps/examples/geojson_line/',
    leading: const Icon(Icons.polyline_outlined),
    title: 'Add a line with a GeoJSON source',
    subtitle: 'Use a GeoJSON source as the data for a line layer.',
    builder: (_) => const DrawGeoJsonLineExample(),
  ),
  Example(
    slug: 'route_line',
    category: ExampleCategory.docs,
    docsUrl: 'https://docs.mapbox.com/flutter/maps/examples/route_line/',
    leading: const Icon(Icons.turn_sharp_left),
    title: 'Draw a route line with traffic',
    subtitle: 'Use LineLayer to style a route line with traffic data.',
    builder: (_) => const TrafficRouteLineExample(),
  ),
  Example(
    slug: 'animated_route',
    category: ExampleCategory.animations,
    leading: const Icon(Icons.route_outlined),
    title: 'Animated route',
    subtitle:
        'Tap the map to route from a fixed point or your own location, with '
        'an animated line reveal, plus a rainbow gradient road animation.',
    builder: (_) => const AnimatedRouteExample(),
  ),
  Example(
    slug: 'vector_tile_source',
    category: ExampleCategory.docs,
    docsUrl:
        'https://docs.mapbox.com/flutter/maps/examples/vector_tile_source/',
    leading: const Icon(Icons.grid_on_outlined),
    title: 'Add vector tiles',
    subtitle: 'Add a vector tile source and render it with a line layer.',
    builder: (_) => const VectorTileSourceExample(),
  ),
  Example(
    slug: 'transparency',
    category: ExampleCategory.animations,
    leading: const Icon(Icons.blur_on),
    title: 'Transparent map surface',
    subtitle:
        'Composite Flutter widgets behind a transparent map, as space around '
        'a globe or animated sea.',
    builder: (_) => const TransparencyExample(),
  ),
  Example(
    slug: 'model_layer',
    category: ExampleCategory.docs,
    docsUrl: 'https://docs.mapbox.com/flutter/maps/examples/model_layer/',
    leading: const Icon(Icons.view_in_ar),
    title: 'Display a 3D model',
    subtitle: 'Showcase the usage of a 3D model layer.',
    builder: (_) => const ModelLayerExample(),
  ),
  Example(
    slug: 'model_comparison',
    category: ExampleCategory.styles,
    leading: const Icon(Icons.view_in_ar_outlined),
    title: 'Model layer and model source',
    subtitle:
        'Two ways to place 3D models: a ModelLayer over a GeoJSON source, '
        'or a single ModelSource.',
    builder: (_) => const ModelComparisonExample(),
  ),
  if (isMobile)
    Example(
      slug: 'annotations',
      category: ExampleCategory.interaction,
      leading: const Icon(Icons.place_outlined),
      title: 'Annotations',
      subtitle:
          'Point, circle, polyline and polygon annotations with drag and tap '
          'events.',
      builder: (_) => const AnnotationsExample(),
    ),
  if (isMobile)
    Example(
      slug: 'circle_annotations',
      category: ExampleCategory.docs,
      docsUrl:
          'https://docs.mapbox.com/flutter/maps/examples/circle_annotations/',
      leading: const Icon(Icons.circle_outlined),
      title: 'Add circle annotations',
      subtitle: 'Show circle annotations on a map.',
      builder: (_) => const CircleAnnotationExample(),
    ),
  Example(
    slug: 'location_component',
    category: ExampleCategory.docs,
    docsUrl:
        'https://docs.mapbox.com/flutter/maps/examples/location_component/',
    leading: const Icon(Icons.my_location),
    title: "Display the user's location",
    subtitle: 'Toggle the user-location puck and follow it as the user moves.',
    builder: (_) => const LocationExample(),
  ),
  Example(
    slug: 'map_interface',
    category: ExampleCategory.platform,
    leading: const Icon(Icons.api),
    title: 'MapInterface',
    subtitle: 'Query rendered features and drive feature state from taps.',
    builder: (_) => const MapInterfaceExample(),
  ),
  Example(
    slug: 'snapshot',
    category: ExampleCategory.docs,
    docsUrl: 'https://docs.mapbox.com/flutter/maps/examples/snapshot/',
    leading: const Icon(Icons.camera_alt_outlined),
    title: 'Create a static map snapshot',
    subtitle: 'Create a static, non-interactive image of a map style.',
    builder: (_) => const SnapshotterExample(),
  ),
  if (isWeb)
    Example(
      slug: 'overlay_playground',
      category: ExampleCategory.interaction,
      leading: const Icon(Icons.widgets_outlined),
      title: 'Overlay & cursor playground',
      subtitle:
          'Cards, dialogs, menus, FABs and every cursor stacked over the map '
          'to exercise web hit-testing.',
      builder: (_) => const OverlayPlaygroundExample(),
    ),
  // These APIs have no web implementation.
  if (isMobile) ...[
    Example(
      slug: 'offline',
      category: ExampleCategory.docs,
      docsUrl: 'https://docs.mapbox.com/flutter/maps/examples/offline/',
      leading: const Icon(Icons.wifi_off),
      title: 'Offline map',
      subtitle: 'Use OfflineManager and TileStore to download regions.',
      builder: (_) => const OfflineMapExample(),
    ),
    Example(
      slug: 'debug_options',
      category: ExampleCategory.platform,
      leading: const Icon(Icons.construction),
      title: 'Map debug options',
      subtitle:
          'Toggle tile borders, collision boxes, wireframes and more, live.',
      builder: (_) => const DebugOptionsExample(),
    ),
    Example(
      slug: 'map_recorder',
      category: ExampleCategory.platform,
      leading: const Icon(Icons.fiber_smart_record),
      title: 'Map recorder',
      subtitle: 'Record and replay map sessions.',
      builder: (_) => const MapRecorderExample(),
    ),
    Example(
      slug: 'projection',
      category: ExampleCategory.camera,
      leading: const Icon(Icons.public),
      title: 'Projection interface',
      subtitle: 'Tap to see one point in four coordinate spaces.',
      builder: (_) => const ProjectionExample(),
    ),
  ],
];

/// Example matching [slug], or `null` when no example on this platform has it.
Example? exampleForSlug(String slug) {
  for (final example in examples) {
    if (example.slug == slug) return example;
  }
  return null;
}
