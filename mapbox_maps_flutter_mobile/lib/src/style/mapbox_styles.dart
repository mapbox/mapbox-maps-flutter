part of mapbox_maps_flutter_mobile;

/// A pre-specified location in the style where layer will be added to.
/// (such as on top of existing land layers, but below all labels).
class LayerSlot {
  /// Place layer above POI labels and behind Place and Transit labels.
  static const String TOP = "top";

  /// Place layer above lines (roads, etc.) and behind 3D buildings.
  static const String MIDDLE = "middle";

  /// Place layer above polygons (land, landuse, water, etc.)
  static const String BOTTOM = "bottom";
}
