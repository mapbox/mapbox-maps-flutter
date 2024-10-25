part of mapbox_maps_flutter;

/// A convenience object to access [the style ID](https://docs.mapbox.com/help/glossary/style-id/) strings of the professionally-designed
/// map styles made by Mapbox.
class MapboxStyles {
  /// Mapbox Standard is a general-purpose style with 3D visualization.
  static const String STANDARD = "mapbox://styles/mapbox/standard";

  /// Mapbox Standard Satellite
  static const String STANDARD_SATELLITE =
      "mapbox://styles/mapbox/standard-satellite";

  /// Mapbox Streets: A complete base map, perfect for incorporating your own data. Using this
  /// constant means your map style will always use the latest version and may change as we
  /// improve the style.
  static const String MAPBOX_STREETS = "mapbox://styles/mapbox/streets-v12";

  /// Outdoors: A general-purpose style tailored to outdoor activities. Using this constant means
  /// your map style will always use the latest version and may change as we improve the style.
  static const String OUTDOORS = "mapbox://styles/mapbox/outdoors-v12";

  /// Light: Subtle light backdrop for data visualizations. Using this constant means your map
  /// style will always use the latest version and may change as we improve the style.
  static const String LIGHT = "mapbox://styles/mapbox/light-v11";

  /// Dark: Subtle dark backdrop for data visualizations. Using this constant means your map style
  /// will always use the latest version and may change as we improve the style.
  static const String DARK = "mapbox://styles/mapbox/dark-v11";

  /// Satellite: A beautiful global satellite and aerial imagery layer. Using this constant means
  /// your map style will always use the latest version and may change as we improve the style.
  static const String SATELLITE = "mapbox://styles/mapbox/satellite-v9";

  /// Satellite Streets: Global satellite and aerial imagery with unobtrusive labels. Using this
  /// constant means your map style will always use the latest version and may change as we
  /// improve the style.
  static const String SATELLITE_STREETS =
      "mapbox://styles/mapbox/satellite-streets-v12";

  /// NOT FOR PRODUCTION USE. An experimental version of the Mapbox Standard style.
  /// This style is used for testing new features and changes to the Mapbox Standard style. The style may change or be removed at any time.
  static const String STANDARD_EXPERIMENTAL =
      "mapbox://styles/mapbox-map-design/standard-experimental-ime";
}

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
