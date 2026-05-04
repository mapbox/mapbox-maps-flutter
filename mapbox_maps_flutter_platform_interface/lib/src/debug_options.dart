import 'pigeons/platform_interface_data_types.dart';

/// Options for enabling debugging features in a map.
class MapWidgetDebugOptions {
  /// The underlying Pigeon enum value. Platform implementations
  /// (`mapbox_maps_flutter_mobile`) use this for channel round-tripping;
  /// facade users should construct instances via the named constants
  /// (`MapWidgetDebugOptions.tileBorders`, etc.) instead.
  final MapWidgetDebugOptionsData data;

  const MapWidgetDebugOptions._(this.data);

  /// Edges of tile boundaries are shown as thick, red lines to help
  /// diagnose tile clipping issues.
  static const MapWidgetDebugOptions tileBorders = MapWidgetDebugOptions._(
    MapWidgetDebugOptionsData.tileBorders,
  );

  /// Each tile shows its tile coordinate (x/y/z) in the upper-left corner.
  static const MapWidgetDebugOptions parseStatus = MapWidgetDebugOptions._(
    MapWidgetDebugOptionsData.parseStatus,
  );

  /// Each tile shows a timestamps with modified and expires dates or n/a
  /// if timestamp is not available.
  static const MapWidgetDebugOptions timestamps = MapWidgetDebugOptions._(
    MapWidgetDebugOptionsData.timestamps,
  );

  /// Edges of glyphs and symbols are shown as faint, green lines to help
  /// diagnose collision and label placement issues.
  static const MapWidgetDebugOptions collision = MapWidgetDebugOptions._(
    MapWidgetDebugOptionsData.collision,
  );

  /// Each drawing operation is replaced by a translucent fill. Overlapping
  /// drawing operations appear more prominent to help diagnose overdrawing.
  static const MapWidgetDebugOptions overdraw = MapWidgetDebugOptions._(
    MapWidgetDebugOptionsData.overdraw,
  );

  /// The stencil buffer is shown instead of the color buffer.
  static const MapWidgetDebugOptions stencilClip = MapWidgetDebugOptions._(
    MapWidgetDebugOptionsData.stencilClip,
  );

  /// The depth buffer is shown instead of the color buffer.
  static const MapWidgetDebugOptions depthBuffer = MapWidgetDebugOptions._(
    MapWidgetDebugOptionsData.depthBuffer,
  );

  /// Show 3D model bounding boxes.
  static const MapWidgetDebugOptions modelBounds = MapWidgetDebugOptions._(
    MapWidgetDebugOptionsData.modelBounds,
  );

  /// Show a wireframe for terrain. Supported on Android only.
  static const MapWidgetDebugOptions terrainWireframe = MapWidgetDebugOptions._(
    MapWidgetDebugOptionsData.terrainWireframe,
  );

  /// Show a wireframe for 2D layers. Supported on Android only.
  static const MapWidgetDebugOptions layers2DWireframe =
      MapWidgetDebugOptions._(MapWidgetDebugOptionsData.layers2DWireframe);

  /// Show a wireframe for 3D layers. Supported on Android only.
  static const MapWidgetDebugOptions layers3DWireframe =
      MapWidgetDebugOptions._(MapWidgetDebugOptionsData.layers3DWireframe);

  /// Each tile shows its local lighting conditions in the upper-left
  /// corner. (If `lights` properties are used, otherwise they show zero.)
  static const MapWidgetDebugOptions light = MapWidgetDebugOptions._(
    MapWidgetDebugOptionsData.light,
  );

  /// Show a debug overlay with information about the CameraState
  /// including lat, long, zoom, pitch, & bearing.
  static const MapWidgetDebugOptions camera = MapWidgetDebugOptions._(
    MapWidgetDebugOptionsData.camera,
  );

  /// Draws camera padding frame.
  static const MapWidgetDebugOptions padding = MapWidgetDebugOptions._(
    MapWidgetDebugOptionsData.padding,
  );

  /// Maps a raw Pigeon enum value back to the typed wrapper. Used by
  /// platform implementations; not intended for direct use by facade users.
  static MapWidgetDebugOptions fromData(MapWidgetDebugOptionsData data) {
    switch (data) {
      case MapWidgetDebugOptionsData.tileBorders:
        return tileBorders;
      case MapWidgetDebugOptionsData.parseStatus:
        return parseStatus;
      case MapWidgetDebugOptionsData.timestamps:
        return timestamps;
      case MapWidgetDebugOptionsData.collision:
        return collision;
      case MapWidgetDebugOptionsData.overdraw:
        return overdraw;
      case MapWidgetDebugOptionsData.stencilClip:
        return stencilClip;
      case MapWidgetDebugOptionsData.depthBuffer:
        return depthBuffer;
      case MapWidgetDebugOptionsData.modelBounds:
        return modelBounds;
      case MapWidgetDebugOptionsData.terrainWireframe:
        return terrainWireframe;
      case MapWidgetDebugOptionsData.layers2DWireframe:
        return layers2DWireframe;
      case MapWidgetDebugOptionsData.layers3DWireframe:
        return layers3DWireframe;
      case MapWidgetDebugOptionsData.light:
        return light;
      case MapWidgetDebugOptionsData.camera:
        return camera;
      case MapWidgetDebugOptionsData.padding:
        return padding;
    }
  }
}
