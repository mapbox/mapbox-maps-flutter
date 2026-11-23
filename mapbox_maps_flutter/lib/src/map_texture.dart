import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

import 'map_widget.dart';
import 'mapbox_map.dart';

/// A map that is not a platform view.
///
/// [MapWidget] puts a `UiKitView` in the tree. UIKit composites that view, not
/// flutter, so nothing painted above it can read it: backdrop filters, shaders
/// and `toImageSync` captures all come back empty. Android avoids this by
/// rendering the map into a `TextureView`.
///
/// [MapTexture] is that mode for ios. The map is created without a platform
/// view and its frames go to a flutter texture, so the widget tree contains a
/// [Texture] and composites like any other widget.
class MapTexture extends StatelessWidget {
  const MapTexture({
    super.key,
    this.styleUri,
    this.onMapCreated,
    this.gesturesEnabled = true,
  });

  /// Style to load, defaults to the sdk's standard style.
  final String? styleUri;

  /// Called once with a [MapboxMap] bound to this map. Same api surface as the
  /// one [MapWidget] hands back.
  final MapCreatedCallback? onMapCreated;

  /// Forward pan, pinch, rotate and pitch to the map. Turn off to drive the
  /// camera yourself.
  final bool gesturesEnabled;

  @override
  Widget build(BuildContext context) {
    final onMapCreated = this.onMapCreated;
    return MapboxMapsFlutterPlatform.instance.buildTextureView(
      styleUri: styleUri,
      onMapCreated: onMapCreated == null
          ? null
          : (map) => onMapCreated(MapboxMap(map)),
      gesturesEnabled: gesturesEnabled,
    );
  }
}
