import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart'
    show TileCacheBudgetInMegabytes, TileCacheBudgetInTiles;
import 'package:meta/meta.dart';

/// The visibility of a layer. Hand-written rather than emitted from the
/// style spec because `visibility` is a shared layer property hard-coded
/// in the layer template, not visited by the per-property generator loop.
enum Visibility {
  /// The layer is shown.
  VISIBLE,

  /// The layer is hidden.
  NONE,
}

/// The unit a cache budget is measured in.
enum TileCacheBudgetType {
  /// Measured in tile units.
  TILES,

  /// Measured in megabytes.
  MEGABYTES,
}

/// Defines a tile-cache resource budget.
class TileCacheBudget {
  TileCacheBudget(this.type, this.size);

  TileCacheBudget.inMegabytes(TileCacheBudgetInMegabytes budget)
    : type = TileCacheBudgetType.MEGABYTES,
      size = budget.size;

  TileCacheBudget.inTiles(TileCacheBudgetInTiles budget)
    : type = TileCacheBudgetType.TILES,
      size = budget.size;

  TileCacheBudgetType type;
  int size;

  Object toJson() {
    switch (type) {
      case TileCacheBudgetType.MEGABYTES:
        return {"megabytes": size};
      case TileCacheBudgetType.TILES:
        return {"tiles": size};
    }
  }

  static TileCacheBudget? decode(Object? budget) {
    if (budget == null) return null;
    final map = Map<String, dynamic>.from(
      budget as Map<dynamic, dynamic>,
    ).cast<String, dynamic>();
    final budgetType = map.keys.first;
    final budgetSize = map.values.first;

    if (budgetType == 'megabytes') {
      return TileCacheBudget.inMegabytes(
        TileCacheBudgetInMegabytes(size: budgetSize),
      );
    } else if (budgetType == 'tiles') {
      return TileCacheBudget.inTiles(TileCacheBudgetInTiles(size: budgetSize));
    }
    return null;
  }
}

/// Description of raster data layers and the bands contained within tiles.
@experimental
class RasterDataLayer {
  RasterDataLayer(this.layerId, this.bands);

  /// Identifier of the data layer fetched from tiles.
  String layerId;

  /// Bands found in the data layer.
  List<String> bands;

  Map<String, List<String>> toJson() => {layerId: bands};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RasterDataLayer &&
          runtimeType == other.runtimeType &&
          layerId == other.layerId &&
          listEquals(bands, other.bands);

  @override
  int get hashCode => Object.hash(layerId, Object.hashAll(bands));
}

/// Defines the duration and delay for a style transition.
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

/// A pre-specified location in the style where layers will be added
/// (e.g. on top of existing land layers but below all labels).
class LayerSlot {
  /// Place a layer above POI labels and behind Place/Transit labels.
  static const String TOP = "top";

  /// Place a layer above lines (roads, etc.) and behind 3D buildings.
  static const String MIDDLE = "middle";

  /// Place a layer above polygons (land, landuse, water, etc.).
  static const String BOTTOM = "bottom";
}

/// Converts a 32-bit ARGB [Color]-int to a `rgba(r, g, b, a)` CSS-like string.
extension StyleColorInt on int {
  String toRGBA() {
    final color = Color(this);
    // ignore: deprecated_member_use — .red/.green/.blue are still the shape
    // the GL-Native side expects in `rgba(r, g, b, a)` strings.
    return "rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha / 255})";
  }
}

/// Convert the color from a CSS-style `"rgba(r,g,b,a)"` string, as returned
/// for plain (non-expression) color properties like
/// `ModelMaterialOverride.modelColor`, to a 32-bit ARGB int.
extension StyleColorString on String {
  int toRGBAInt() {
    final match = RegExp(
      r'^rgba\(([\d.]+),\s*([\d.]+),\s*([\d.]+),\s*([\d.]+)\)$',
    ).firstMatch(this);
    if (match == null) {
      return 0;
    }
    final red = double.parse(match.group(1)!).round();
    final green = double.parse(match.group(2)!).round();
    final blue = double.parse(match.group(3)!).round();
    final alpha = (double.parse(match.group(4)!) * 255).round();
    return Color.fromARGB(alpha, red, green, blue).value;
  }
}

/// Converts a color expression list (`[rgba, r, g, b, a]`, `[rgb, …]`,
/// `[hsl, …]`, `[hsla, …]`) to a 32-bit ARGB int.
extension StyleColorList on List {
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
    }
    return const Color(0x00000000);
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
    }
    return const Color(0x00000000);
  }

  Color _decodeRGBColor() {
    final red = this[1] is num ? (this[1] as num).toInt() : null;
    final green = this[2] is num ? (this[2] as num).toInt() : null;
    final blue = this[3] is num ? (this[3] as num).toInt() : null;
    if (red != null && green != null && blue != null) {
      return Color.fromARGB(1, red, green, blue);
    }
    return const Color(0x00000000);
  }

  Color _decodeRGBAColor() {
    final red = this[1] is num ? (this[1] as num).toInt() : null;
    final green = this[2] is num ? (this[2] as num).toInt() : null;
    final blue = this[3] is num ? (this[3] as num).toInt() : null;
    final alpha = this[4] is num ? ((this[4] as num) * 255).toInt() : null;
    if (alpha != null && red != null && green != null && blue != null) {
      return Color.fromARGB(alpha, red, green, blue);
    }
    return const Color(0x00000000);
  }
}
