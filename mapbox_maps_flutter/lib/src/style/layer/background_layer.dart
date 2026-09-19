// This file is generated.
// ignore_for_file: unused_import
import 'dart:convert';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

import '../style_internal.dart';
import '../style_types.dart';
import 'layer.dart';

/// The background color or pattern of the map.
final class BackgroundLayer extends Layer {
  BackgroundLayer({
    required super.id,
    super.visibility,
    super.visibilityExpression,
    super.filter,
    super.minZoom,
    super.maxZoom,
    super.slot,

    this.backgroundColor,
    this.backgroundColorExpression,
    this.backgroundEmissiveStrength,
    this.backgroundEmissiveStrengthExpression,
    this.backgroundOpacity,
    this.backgroundOpacityExpression,
    this.backgroundPattern,
    this.backgroundPatternExpression,
    this.backgroundPitchAlignment,
    this.backgroundPitchAlignmentExpression,
  });

  @override
  String getType() => "background";

  /// The color with which the background will be drawn.
  /// Default value: "#000000".
  int? backgroundColor;

  /// The color with which the background will be drawn.
  /// Default value: "#000000".
  List<Object>? backgroundColorExpression;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0. The unit of backgroundEmissiveStrength is in intensity.
  double? backgroundEmissiveStrength;

  /// Controls the intensity of light emitted on the source features.
  /// Default value: 0. Minimum value: 0. The unit of backgroundEmissiveStrength is in intensity.
  List<Object>? backgroundEmissiveStrengthExpression;

  /// The opacity at which the background will be drawn.
  /// Default value: 1. Value range: [0, 1]
  double? backgroundOpacity;

  /// The opacity at which the background will be drawn.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? backgroundOpacityExpression;

  /// Name of image in sprite to use for drawing an image background. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  String? backgroundPattern;

  /// Name of image in sprite to use for drawing an image background. For seamless patterns, image width and height must be a factor of two (2, 4, 8, ..., 512). Note that zoom-dependent expressions will be evaluated only at integer zoom levels.
  List<Object>? backgroundPatternExpression;

  /// Orientation of background layer.
  /// Default value: "map".
  @experimental
  BackgroundPitchAlignment? backgroundPitchAlignment;

  /// Orientation of background layer.
  /// Default value: "map".
  @experimental
  List<Object>? backgroundPitchAlignmentExpression;

  @override
  @internal
  Future<String> encode() async {
    var layout = {};
    if (visibilityExpression != null) {
      layout["visibility"] = visibilityExpression!;
    }
    if (visibility != null) {
      layout["visibility"] = visibility!.name.toLowerCase().replaceAll(
        "_",
        "-",
      );
    }

    var paint = {};
    if (backgroundColorExpression != null) {
      paint["background-color"] = backgroundColorExpression;
    } else if (backgroundColor != null) {
      paint["background-color"] = backgroundColor?.toRGBA();
    }

    if (backgroundEmissiveStrengthExpression != null) {
      paint["background-emissive-strength"] =
          backgroundEmissiveStrengthExpression;
    } else if (backgroundEmissiveStrength != null) {
      paint["background-emissive-strength"] = backgroundEmissiveStrength;
    }

    if (backgroundOpacityExpression != null) {
      paint["background-opacity"] = backgroundOpacityExpression;
    } else if (backgroundOpacity != null) {
      paint["background-opacity"] = backgroundOpacity;
    }

    if (backgroundPatternExpression != null) {
      paint["background-pattern"] = backgroundPatternExpression;
    } else if (backgroundPattern != null) {
      paint["background-pattern"] = backgroundPattern;
    }

    if (backgroundPitchAlignmentExpression != null) {
      paint["background-pitch-alignment"] = backgroundPitchAlignmentExpression;
    } else if (backgroundPitchAlignment != null) {
      paint["background-pitch-alignment"] = backgroundPitchAlignment?.name
          .toLowerCase()
          .replaceAll("_", "-");
    }

    var properties = {
      "id": id,
      "type": getType(),
      "layout": layout,
      "paint": paint,
    };
    if (minZoom != null) {
      properties["minzoom"] = minZoom!;
    }
    if (maxZoom != null) {
      properties["maxzoom"] = maxZoom!;
    }
    if (slot != null) {
      properties["slot"] = slot!;
    }
    if (filter != null) {
      properties["filter"] = filter!;
    }

    return json.encode(properties);
  }

  static BackgroundLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return BackgroundLayer(
      id: map["id"],
      minZoom: map["minzoom"]?.toDouble(),
      maxZoom: map["maxzoom"]?.toDouble(),
      slot: map["slot"],
      visibility: map["layout"]["visibility"] == null
          ? Visibility.VISIBLE
          : Visibility.values.firstWhere(
              (e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["layout"]["visibility"]),
            ),
      visibilityExpression: styleOptionalCastList(map["layout"]["visibility"]),
      filter: styleOptionalCastList(map["filter"]),
      backgroundColor: (map["paint"]["background-color"] as List?)?.toRGBAInt(),
      backgroundColorExpression: styleOptionalCastList(
        map["paint"]["background-color"],
      ),
      backgroundEmissiveStrength: styleOptionalCast(
        map["paint"]["background-emissive-strength"],
      ),
      backgroundEmissiveStrengthExpression: styleOptionalCastList(
        map["paint"]["background-emissive-strength"],
      ),
      backgroundOpacity: styleOptionalCast(map["paint"]["background-opacity"]),
      backgroundOpacityExpression: styleOptionalCastList(
        map["paint"]["background-opacity"],
      ),
      backgroundPattern: styleOptionalCast(map["paint"]["background-pattern"]),
      backgroundPatternExpression: styleOptionalCastList(
        map["paint"]["background-pattern"],
      ),
      backgroundPitchAlignment:
          map["paint"]["background-pitch-alignment"] == null
          ? null
          : BackgroundPitchAlignment.values.firstWhere(
              (e) => e.name
                  .toLowerCase()
                  .replaceAll("_", "-")
                  .contains(map["paint"]["background-pitch-alignment"]),
            ),
      backgroundPitchAlignmentExpression: styleOptionalCastList(
        map["paint"]["background-pitch-alignment"],
      ),
    );
  }
}

// End of generated file.
