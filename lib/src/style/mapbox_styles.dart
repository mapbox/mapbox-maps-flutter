part of mapbox_maps_flutter;

/// A convenience object to access [the style ID](https://docs.mapbox.com/help/glossary/style-id/) strings of the professionally-designed
/// map styles made by Mapbox.
class MapboxStyles {
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

  /// Traffic Day: Color-coded roads based on live traffic congestion data. Traffic data is currently
  /// available in
  /// <a href="https://www.mapbox.com/help/how-directions-work/#traffic-data">these select
  /// countries</a>. Using this constant means your map style will always use the latest version and
  /// may change as we improve the style.
  static const String TRAFFIC_DAY = "mapbox://styles/mapbox/traffic-day-v2";

  /// Traffic Night: Color-coded roads based on live traffic congestion data, designed to maximize
  /// legibility in low-light situations. Traffic data is currently available in
  /// <a href="https://www.mapbox.com/help/how-directions-work/#traffic-data">these select
  /// countries</a>. Using this constant means your map style will always use the latest version and
  /// may change as we improve the style.
  static const String TRAFFIC_NIGHT = "mapbox://styles/mapbox/traffic-night-v2";
}
