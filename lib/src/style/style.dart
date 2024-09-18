part of mapbox_maps_flutter;

/// Influences the y direction of the tile coordinates. The global-mercator (aka Spherical Mercator) profile is assumed.
///
/// @param value
enum Scheme {
  /// Slippy map tilenames scheme.
  XYZ,

  /// OSGeo spec scheme.
  TMS,
}

/// The encoding used by this source. Mapbox Terrain RGB is used by default
///
/// @param value
enum Encoding {
  /// Terrarium format PNG tiles. See https://aws.amazon.com/es/public-datasets/terrain/ for more info.
  TERRARIUM,

  /// Mapbox Terrain RGB tiles. See https://www.mapbox.com/help/access-elevation-data/#mapbox-terrain-rgb for more info.
  MAPBOX,
}

/// The visibility of a layer.
enum Visibility {
  /// The layer is shown.
  VISIBLE,

  /// The layer is hidden.
  NONE
}

enum ModelType {
  /// Integrated to 3D scene, using depth testing, along with terrain, fill-extrusions and custom layer.
  COMMON_3D,

  /// Displayed over other 3D content, occluded by terrain.
  LOCATION_INDICATOR,
}

/// The type of the sky
enum SkyType {
  /// Renders the sky with a gradient that can be configured with {@link SKY_GRADIENT_RADIUS} and {@link SKY_GRADIENT}.
  GRADIENT,

  /// Renders the sky with a simulated atmospheric scattering algorithm, the sun direction can be attached to the light position or explicitly set through {@link SKY_ATMOSPHERE_SUN}.
  ATMOSPHERE,
}

/// The resampling/interpolation method to use for overscaling, also known as texture magnification filter
enum RasterResampling {
  /// (Bi)linear filtering interpolates pixel values using the weighted average of the four closest original source pixels creating a smooth but blurry look when overscaled
  LINEAR,

  /// Nearest neighbor filtering interpolates pixel values using the nearest original source pixel creating a sharp but pixelated look when overscaled
  NEAREST,
}

/// Direction of light source when map is rotated.
enum HillshadeIlluminationAnchor {
  /// The hillshade illumination is relative to the north direction.
  MAP,

  /// The hillshade illumination is relative to the top of the viewport.
  VIEWPORT,
}

/// Controls the frame of reference for `fill-extrusion-translate`.
enum FillExtrusionTranslateAnchor {
  /// The fill extrusion is translated relative to the map.
  MAP,

  /// The fill extrusion is translated relative to the viewport.
  VIEWPORT,
}

/// The unit a cache budget should be measured in. Either Tiles or Megabytes.
enum TileCacheBudgetType {
  /// A tile cache budget measured in tile units
  TILES,

  /// A tile cache budget measured in megabyte units
  MEGABYTES
}

/// Defines a resource budget, either in tile units or in megabytes.
class TileCacheBudget {
  /// The type of TileCacheBudget, either in Tiles or in Megabytes
  TileCacheBudgetType type;

  /// The size of the budget.
  int size;

  /// Returns the TileCacheBudget formatted into an object
  Object toJson() {
    switch (type) {
      case TileCacheBudgetType.MEGABYTES:
        return {"megabytes": size};
      case TileCacheBudgetType.TILES:
        return {"tiles": size};
    }
  }

  /// Decodes the TileCacheBudget from and object
  static TileCacheBudget? decode(Object? budget) {
    var budgetObject =
        Map<String, dynamic>.from(budget as Map<dynamic, dynamic>)
            .cast<String, dynamic>();
    var budgetType = budgetObject.keys.first;
    var budgetSize = budgetObject.values.first;

    if (budgetType == 'megabytes') {
      return TileCacheBudget.inMegabytes(
          TileCacheBudgetInMegabytes(size: budgetSize));
    } else if (budgetType == 'tiles') {
      return TileCacheBudget.inTiles(TileCacheBudgetInTiles(size: budgetSize));
    } else {
      return null;
    }
  }

  TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes budget)
      : type = TileCacheBudgetType.MEGABYTES,
        size = budget.size;

  TileCacheBudget.inTiles(TileCacheBudgetInTiles budget)
      : type = TileCacheBudgetType.TILES,
        size = budget.size;

  TileCacheBudget(this.type, this.size);
}

/// The description of the raster data layers and the bands contained within the tiles.
@experimental
class RasterDataLayer {
  /// Identifier of the data layer fetched from tiles.
  String layerId;

  /// An array of bands found in the data layer.
  List<String> bands;

  Map<String, List<String>> toJson() => {layerId: bands};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RasterDataLayer &&
          runtimeType == other.runtimeType &&
          layerId == other.layerId &&
          listEquals(bands, other.bands);

  RasterDataLayer(this.layerId, this.bands);
}

/// Define the duration and delay for a style transition.
class StyleTransition {
  StyleTransition({this.duration, this.delay});

  /// Duration of the transition.
  int? duration;

  /// Delay of the transition.
  int? delay;

  String encode() {
    final properties = <String, dynamic>{"duration": duration, "delay": delay};
    return json.encode(properties);
  }

  static StyleTransition decode(String properties) {
    final map = json.decode(properties);
    return StyleTransition(duration: map["duration"], delay: map["delay"]);
  }
}

/// Super class for all different types of layers.
abstract class Layer {
  /// The ID of the Layer.
  String id;

  /// The visibility of the layer.
  Visibility? visibility;

  /// The visibility of the layer.
  List<Object>? visibilityExpression;

  /// An expression specifying conditions on source features.
  /// Only features that match the filter are displayed.
  List<Object>? filter;

  /// The minimum zoom level for the layer. At zoom levels less than the minzoom, the layer will be hidden.
  ///
  /// Range:
  ///       minimum: 0
  ///       maximum: 24
  double? minZoom;

  /// The maximum zoom level for the layer. At zoom levels equal to or greater than the maxzoom, the layer will be hidden.
  ///
  /// Range:
  ///       minimum: 0
  ///       maximum: 24
  double? maxZoom;

  /// The slot this layer is assigned to. If specified, and a slot with that name exists, it will be placed at that position in the layer order.
  String? slot;

  /// Get the type of current layer as a String.
  String getType();

  Future<String> _encode();

  Layer(
      {required String this.id,
      Visibility? this.visibility,
      List<Object>? this.visibilityExpression,
      List<Object>? this.filter,
      double? this.maxZoom,
      double? this.minZoom,
      String? this.slot});
}

/// Super class for all different types of sources.
abstract class Source {
  /// The ID of the Source.
  String id;

  /// Get the type of the current source as a String.
  String getType();

  String _encode(bool volatile);

  Source({required this.id});

  StyleManager? _style;

  void bind(StyleManager style) => _style = style;
}

/// Extension for StyleManager to add/update/get layers from the current style.
extension StyleLayer on StyleManager {
  /// Add a layer the the current style.
  Future<void> addLayer(Layer layer) async {
    var encode = await layer._encode();
    return addStyleLayer(encode, null);
  }

  /// Add a layer to the current style in a specific position.
  Future<void> addLayerAt(Layer layer, LayerPosition position) async {
    var encode = await layer._encode();
    return addStyleLayer(encode, position);
  }

  /// Update an existing layer in the style.
  Future<void> updateLayer(Layer layer) async {
    var encode = await layer._encode();
    return setStyleLayerProperties(layer.id, encode);
  }

  /// Get a previously added layer from the current style.
  Future<Layer?> getLayer(String layerId) async {
    var properties = await getStyleLayerProperties(layerId);

    Layer? layer;
    var map = json.decode(properties);

    var type = map["type"];
    switch (type) {
      case "background":
        layer = BackgroundLayer.decode(properties);
        break;
      case "location-indicator":
        layer = LocationIndicatorLayer.decode(properties);
        break;
      case "sky":
        layer = SkyLayer.decode(properties);
        break;
      case "circle":
        layer = CircleLayer.decode(properties);
        break;
      case "fill-extrusion":
        layer = FillExtrusionLayer.decode(properties);
        break;
      case "fill":
        layer = FillLayer.decode(properties);
        break;
      case "heatmap":
        layer = HeatmapLayer.decode(properties);
        break;
      case "hillshade":
        layer = HillshadeLayer.decode(properties);
        break;
      case "line":
        layer = LineLayer.decode(properties);
        break;
      case "raster":
        layer = RasterLayer.decode(properties);
        break;
      case "symbol":
        layer = SymbolLayer.decode(properties);
        break;
      case "model":
        layer = ModelLayer.decode(properties);
        break;
      case "slot":
        layer = SlotLayer.decode(properties);
        break;
      case "raster-particle":
        layer = RasterParticleLayer.decode(properties);
        break;
      case "clip":
        layer = ClipLayer.decode(properties);
        break;
      default:
        print("Layer type: $type unknown.");
    }

    return Future.value(layer);
  }
}

/// Extension for StyleManager to add/get sources from the current style.
extension StyleSource on StyleManager {
  Future<void> addSource(Source source) async {
    if (source is GeoJsonSource && source._data != null) {
      final internalData = source._data!;

      // Add empty data initially so that the source is added and
      // volatile properties can be set. Then add the data.
      source._data = "";
      await _addSourceInternal(source);
      return source.updateGeoJSON(internalData);
    } else {
      return _addSourceInternal(source);
    }
  }

  Future<void> _addSourceInternal(Source source) {
    final nonVolatileProperties = source._encode(false);
    final volatileProperties = source._encode(true);
    source.bind(this);
    return addStyleSource(source.id, nonVolatileProperties).then((value) {
      // volatile properties have to be set after the source has been added to the style
      setStyleSourceProperties(source.id, volatileProperties);
    });
  }

  /// Get the source with sourceId from the current style.
  Future<Source?> getSource(String sourceId) async {
    final properties = await getStyleSourceProperties(sourceId);

    Source? source;

    final map = json.decode(properties);

    final type = map["type"];
    switch (type) {
      case "vector":
        source = VectorSource(id: sourceId);
        break;
      case "geojson":
        source = GeoJsonSource(id: sourceId);
        break;
      case "image":
        source = ImageSource(id: sourceId);
        break;
      case "raster-dem":
        source = RasterDemSource(id: sourceId);
        break;
      case "raster":
        source = RasterSource(id: sourceId);
        break;
      case "raster-array":
        source = RasterArraySource(id: sourceId);
        break;
      default:
        print("Source type: $type unknown.");
    }

    source?.bind(this);
    return Future.value(source);
  }
}

/// Extension to convert color format
extension StyleColorInt on int {
  /// Convert the color from int format to a string with format "rgba(red, green, blue, alpha)".
  String toRGBA() {
    final color = Color(this);
    return "rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha})";
  }
}

extension StyleColorList on List {
  /// Convert the color from a color expression to int.
  /// `rgb`, `rgba`, `hsl` and `hsla` formats are supported.
  /// Example input: `[rgba, $R, $G, $B, $A]`.
  int toRGBAInt() {
    switch ((firstOrNull, length)) {
      case ("rgb", 4):
        return _decodeRGBColor().value;
      case ("rgba", 5):
        return _decodeRGBAColor().value;
      case ("hsl", 4):
        return _decodeHSLColor().value;
      case ("hsla", 5):
        return _decodeHSLAColor().value;
      default:
        return 0;
    }
  }

  Color _decodeHSLColor() {
    final hue = this[1] is num ? (this[1] as num).toDouble() : null;
    final saturation = this[2] is num ? (this[2] as num).toDouble() : null;
    final lightness = this[3] is num ? (this[3] as num).toDouble() : null;

    if (hue != null && saturation != null && lightness != null) {
      return HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
    } else {
      return Colors.transparent;
    }
  }

  Color _decodeHSLAColor() {
    final hue = this[1] is num ? (this[1] as num).toDouble() : null;
    final saturation = this[2] is num ? (this[2] as num).toDouble() : null;
    final lightness = this[3] is num ? (this[3] as num).toDouble() : null;
    final alpha = this[4] is num ? ((this[4] as num) * 255).toDouble() : null;

    if (hue != null &&
        saturation != null &&
        lightness != null &&
        alpha != null) {
      return HSLColor.fromAHSL(alpha, hue, saturation, lightness).toColor();
    } else {
      return Colors.transparent;
    }
  }

  Color _decodeRGBColor() {
    final red = this[1] is num ? (this[1] as num).toInt() : null;
    final green = this[2] is num ? (this[2] as num).toInt() : null;
    final blue = this[3] is num ? (this[3] as num).toInt() : null;

    if (red != null && green != null && blue != null) {
      return Color.fromARGB(1, red, green, blue);
    } else {
      return Colors.transparent;
    }
  }

  Color _decodeRGBAColor() {
    final red = this[1] is num ? (this[1] as num).toInt() : null;
    final green = this[2] is num ? (this[2] as num).toInt() : null;
    final blue = this[3] is num ? (this[3] as num).toInt() : null;
    final alpha = this[4] is num ? ((this[4] as num) * 255).toInt() : null;

    if (alpha != null && red != null && green != null && blue != null) {
      return Color.fromARGB(alpha, red, green, blue);
    } else {
      return Colors.transparent;
    }
  }
}
