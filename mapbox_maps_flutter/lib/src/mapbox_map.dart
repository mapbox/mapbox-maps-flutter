import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// User-facing alias for [MapboxMapInterface].
///
/// Application code and the [MapCreatedCallback] in [MapWidget] use this name.
/// Platform packages implement [MapboxMapInterface] directly.
typedef MapboxMap = MapboxMapInterface;
