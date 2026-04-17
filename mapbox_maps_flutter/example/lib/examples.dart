import 'simple_map_example.dart';
import 'standard_style_interactions_example.dart';
import 'viewport_example.dart';
import 'ornaments_example.dart';
import 'spinning_globe_example.dart';
import 'offline_map_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

final List<Example> examples = [
  Example(
    leading: const Icon(Icons.map_outlined),
    title: 'Display a simple map',
    subtitle: 'Create and display a map that uses the default Mapbox Standard style.',
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
    builder: (_) => const OrnamentsExample()
  ),
  Example(
    leading: const Icon(Icons.threesixty_outlined),
    title: 'Spinning Globe',
    subtitle: 'Display your map as an interactive, rotating globe.',
    builder: (_) => const SpinningGlobeExample(),
  ),
  if (_isMobile)
    Example(
      leading: const Icon(Icons.wifi_off),
      title: 'Offline Map',
      subtitle: 'Shows how to use OfflineManager and TileStore to download regions for offline use.',
      builder: (_) => const OfflineMapExample()
    ),
  Example(
    leading: const Icon(Icons.touch_app),
    title: "Standard Style Interactions",
    subtitle: "Showcase of Standard Style interactions",
    builder: (_) => const StandardStyleInteractionsExample(),
  )
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

final _isMobile =
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);
