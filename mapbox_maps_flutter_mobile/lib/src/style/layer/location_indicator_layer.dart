// This file is generated.
part of mapbox_maps_flutter_mobile;

/// Location Indicator layer.
class LocationIndicatorLayer extends Layer {
  LocationIndicatorLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    List<Object>? filter,
    double? minZoom,
    double? maxZoom,
    String? slot,
    double? this.accuracyRadius,
    List<Object>? this.accuracyRadiusExpression,
    int? this.accuracyRadiusBorderColor,
    List<Object>? this.accuracyRadiusBorderColorExpression,
    int? this.accuracyRadiusColor,
    List<Object>? this.accuracyRadiusColorExpression,
    double? this.bearing,
    List<Object>? this.bearingExpression,
    String? this.bearingImage,
    List<Object>? this.bearingImageExpression,
    double? this.bearingImageSize,
    List<Object>? this.bearingImageSizeExpression,
    int? this.emphasisCircleColor,
    List<Object>? this.emphasisCircleColorExpression,
    List<double?>? this.emphasisCircleGlowRange,
    List<Object>? this.emphasisCircleGlowRangeExpression,
    double? this.emphasisCircleRadius,
    List<Object>? this.emphasisCircleRadiusExpression,
    double? this.imagePitchDisplacement,
    List<Object>? this.imagePitchDisplacementExpression,
    List<double?>? this.location,
    List<Object>? this.locationExpression,
    double? this.locationIndicatorOpacity,
    List<Object>? this.locationIndicatorOpacityExpression,
    double? this.perspectiveCompensation,
    List<Object>? this.perspectiveCompensationExpression,
    String? this.shadowImage,
    List<Object>? this.shadowImageExpression,
    double? this.shadowImageSize,
    List<Object>? this.shadowImageSizeExpression,
    String? this.topImage,
    List<Object>? this.topImageExpression,
    double? this.topImageSize,
    List<Object>? this.topImageSizeExpression,
  }) : super(
            id: id,
            visibility: visibility,
            visibilityExpression: visibilityExpression,
            filter: filter,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "location-indicator";

  /// The accuracy, in meters, of the position source used to retrieve the position of the location indicator.
  /// Default value: 0. The unit of accuracyRadius is in meters.
  double? accuracyRadius;

  /// The accuracy, in meters, of the position source used to retrieve the position of the location indicator.
  /// Default value: 0. The unit of accuracyRadius is in meters.
  List<Object>? accuracyRadiusExpression;

  /// The color for drawing the accuracy radius border. To adjust transparency, set the alpha component of the color accordingly.
  /// Default value: "#ffffff".
  int? accuracyRadiusBorderColor;

  /// The color for drawing the accuracy radius border. To adjust transparency, set the alpha component of the color accordingly.
  /// Default value: "#ffffff".
  List<Object>? accuracyRadiusBorderColorExpression;

  /// The color for drawing the accuracy radius, as a circle. To adjust transparency, set the alpha component of the color accordingly.
  /// Default value: "#ffffff".
  int? accuracyRadiusColor;

  /// The color for drawing the accuracy radius, as a circle. To adjust transparency, set the alpha component of the color accordingly.
  /// Default value: "#ffffff".
  List<Object>? accuracyRadiusColorExpression;

  /// The bearing of the location indicator. Values under 0.01 degree variation are ignored.
  /// Default value: 0. The unit of bearing is in degrees.
  double? bearing;

  /// The bearing of the location indicator. Values under 0.01 degree variation are ignored.
  /// Default value: 0. The unit of bearing is in degrees.
  List<Object>? bearingExpression;

  /// Name of image in sprite to use as the middle of the location indicator.
  String? bearingImage;

  /// Name of image in sprite to use as the middle of the location indicator.
  List<Object>? bearingImageExpression;

  /// The size of the bearing image, as a scale factor applied to the size of the specified image.
  /// Default value: 1. The unit of bearingImageSize is in factor of the original icon size.
  double? bearingImageSize;

  /// The size of the bearing image, as a scale factor applied to the size of the specified image.
  /// Default value: 1. The unit of bearingImageSize is in factor of the original icon size.
  List<Object>? bearingImageSizeExpression;

  /// The color of the circle emphasizing the indicator. To adjust transparency, set the alpha component of the color accordingly.
  /// Default value: "#ffffff".
  int? emphasisCircleColor;

  /// The color of the circle emphasizing the indicator. To adjust transparency, set the alpha component of the color accordingly.
  /// Default value: "#ffffff".
  List<Object>? emphasisCircleColorExpression;

  /// Specifies a glow effect range of the emphasis circle, in pixels. If [0,0] values are provided, it renders the circle as a solid color. The first value specifies the start of the glow effect where it is equal to the circle's color, the second is the end, where it's fully transparent. Between the two values the effect is linearly faded out.
  /// Default value: [0,0].
  List<double?>? emphasisCircleGlowRange;

  /// Specifies a glow effect range of the emphasis circle, in pixels. If [0,0] values are provided, it renders the circle as a solid color. The first value specifies the start of the glow effect where it is equal to the circle's color, the second is the end, where it's fully transparent. Between the two values the effect is linearly faded out.
  /// Default value: [0,0].
  List<Object>? emphasisCircleGlowRangeExpression;

  /// The radius, in pixel, of the circle emphasizing the indicator, drawn between the accuracy radius and the indicator shadow.
  /// Default value: 0. The unit of emphasisCircleRadius is in pixels.
  double? emphasisCircleRadius;

  /// The radius, in pixel, of the circle emphasizing the indicator, drawn between the accuracy radius and the indicator shadow.
  /// Default value: 0. The unit of emphasisCircleRadius is in pixels.
  List<Object>? emphasisCircleRadiusExpression;

  /// The displacement off the center of the top image and the shadow image when the pitch of the map is greater than 0. This helps producing a three-dimensional appearence.
  /// Default value: "0". The unit of imagePitchDisplacement is in pixels.
  double? imagePitchDisplacement;

  /// The displacement off the center of the top image and the shadow image when the pitch of the map is greater than 0. This helps producing a three-dimensional appearence.
  /// Default value: "0". The unit of imagePitchDisplacement is in pixels.
  List<Object>? imagePitchDisplacementExpression;

  /// An array of [latitude, longitude, altitude] position of the location indicator. Values under 0.000001 variation are ignored.
  /// Default value: [0,0,0].
  List<double?>? location;

  /// An array of [latitude, longitude, altitude] position of the location indicator. Values under 0.000001 variation are ignored.
  /// Default value: [0,0,0].
  List<Object>? locationExpression;

  /// The opacity of the entire location indicator layer.
  /// Default value: 1. Value range: [0, 1]
  double? locationIndicatorOpacity;

  /// The opacity of the entire location indicator layer.
  /// Default value: 1. Value range: [0, 1]
  List<Object>? locationIndicatorOpacityExpression;

  /// The amount of the perspective compensation, between 0 and 1. A value of 1 produces a location indicator of constant width across the screen. A value of 0 makes it scale naturally according to the viewing projection.
  /// Default value: "0.85".
  double? perspectiveCompensation;

  /// The amount of the perspective compensation, between 0 and 1. A value of 1 produces a location indicator of constant width across the screen. A value of 0 makes it scale naturally according to the viewing projection.
  /// Default value: "0.85".
  List<Object>? perspectiveCompensationExpression;

  /// Name of image in sprite to use as the background of the location indicator.
  String? shadowImage;

  /// Name of image in sprite to use as the background of the location indicator.
  List<Object>? shadowImageExpression;

  /// The size of the shadow image, as a scale factor applied to the size of the specified image.
  /// Default value: 1. The unit of shadowImageSize is in factor of the original icon size.
  double? shadowImageSize;

  /// The size of the shadow image, as a scale factor applied to the size of the specified image.
  /// Default value: 1. The unit of shadowImageSize is in factor of the original icon size.
  List<Object>? shadowImageSizeExpression;

  /// Name of image in sprite to use as the top of the location indicator.
  String? topImage;

  /// Name of image in sprite to use as the top of the location indicator.
  List<Object>? topImageExpression;

  /// The size of the top image, as a scale factor applied to the size of the specified image.
  /// Default value: 1. The unit of topImageSize is in factor of the original icon size.
  double? topImageSize;

  /// The size of the top image, as a scale factor applied to the size of the specified image.
  /// Default value: 1. The unit of topImageSize is in factor of the original icon size.
  List<Object>? topImageSizeExpression;

  @override
  Future<String> _encode() async {
    var layout = {};
    if (visibilityExpression != null) {
      layout["visibility"] = visibilityExpression!;
    }
    if (visibility != null) {
      layout["visibility"] =
          visibility!.name.toLowerCase().replaceAll("_", "-");
    }

    var paint = {};
    if (accuracyRadiusExpression != null) {
      paint["accuracy-radius"] = accuracyRadiusExpression;
    } else if (accuracyRadius != null) {
      paint["accuracy-radius"] = accuracyRadius;
    }

    if (accuracyRadiusBorderColorExpression != null) {
      paint["accuracy-radius-border-color"] =
          accuracyRadiusBorderColorExpression;
    } else if (accuracyRadiusBorderColor != null) {
      paint["accuracy-radius-border-color"] =
          accuracyRadiusBorderColor?.toRGBA();
    }

    if (accuracyRadiusColorExpression != null) {
      paint["accuracy-radius-color"] = accuracyRadiusColorExpression;
    } else if (accuracyRadiusColor != null) {
      paint["accuracy-radius-color"] = accuracyRadiusColor?.toRGBA();
    }

    if (bearingExpression != null) {
      paint["bearing"] = bearingExpression;
    } else if (bearing != null) {
      paint["bearing"] = bearing;
    }

    if (bearingImageExpression != null) {
      paint["bearing-image"] = bearingImageExpression;
    } else if (bearingImage != null) {
      paint["bearing-image"] = bearingImage;
    }

    if (bearingImageSizeExpression != null) {
      paint["bearing-image-size"] = bearingImageSizeExpression;
    } else if (bearingImageSize != null) {
      paint["bearing-image-size"] = bearingImageSize;
    }

    if (emphasisCircleColorExpression != null) {
      paint["emphasis-circle-color"] = emphasisCircleColorExpression;
    } else if (emphasisCircleColor != null) {
      paint["emphasis-circle-color"] = emphasisCircleColor?.toRGBA();
    }

    if (emphasisCircleGlowRangeExpression != null) {
      paint["emphasis-circle-glow-range"] = emphasisCircleGlowRangeExpression;
    } else if (emphasisCircleGlowRange != null) {
      paint["emphasis-circle-glow-range"] = emphasisCircleGlowRange;
    }

    if (emphasisCircleRadiusExpression != null) {
      paint["emphasis-circle-radius"] = emphasisCircleRadiusExpression;
    } else if (emphasisCircleRadius != null) {
      paint["emphasis-circle-radius"] = emphasisCircleRadius;
    }

    if (imagePitchDisplacementExpression != null) {
      paint["image-pitch-displacement"] = imagePitchDisplacementExpression;
    } else if (imagePitchDisplacement != null) {
      paint["image-pitch-displacement"] = imagePitchDisplacement;
    }

    if (locationExpression != null) {
      paint["location"] = locationExpression;
    } else if (location != null) {
      paint["location"] = location;
    }

    if (locationIndicatorOpacityExpression != null) {
      paint["location-indicator-opacity"] = locationIndicatorOpacityExpression;
    } else if (locationIndicatorOpacity != null) {
      paint["location-indicator-opacity"] = locationIndicatorOpacity;
    }

    if (perspectiveCompensationExpression != null) {
      paint["perspective-compensation"] = perspectiveCompensationExpression;
    } else if (perspectiveCompensation != null) {
      paint["perspective-compensation"] = perspectiveCompensation;
    }

    if (shadowImageExpression != null) {
      paint["shadow-image"] = shadowImageExpression;
    } else if (shadowImage != null) {
      paint["shadow-image"] = shadowImage;
    }

    if (shadowImageSizeExpression != null) {
      paint["shadow-image-size"] = shadowImageSizeExpression;
    } else if (shadowImageSize != null) {
      paint["shadow-image-size"] = shadowImageSize;
    }

    if (topImageExpression != null) {
      paint["top-image"] = topImageExpression;
    } else if (topImage != null) {
      paint["top-image"] = topImage;
    }

    if (topImageSizeExpression != null) {
      paint["top-image-size"] = topImageSizeExpression;
    } else if (topImageSize != null) {
      paint["top-image-size"] = topImageSize;
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

  static LocationIndicatorLayer decode(String properties) {
    var map = json.decode(properties);
    if (map["layout"] == null) {
      map["layout"] = {};
    }
    if (map["paint"] == null) {
      map["paint"] = {};
    }
    return LocationIndicatorLayer(
      id: map["id"],
      minZoom: map["minzoom"]?.toDouble(),
      maxZoom: map["maxzoom"]?.toDouble(),
      slot: map["slot"],
      visibility: map["layout"]["visibility"] == null
          ? Visibility.VISIBLE
          : Visibility.values.firstWhere((e) => e.name
              .toLowerCase()
              .replaceAll("_", "-")
              .contains(map["layout"]["visibility"])),
      visibilityExpression: _optionalCastList(map["layout"]["visibility"]),
      filter: _optionalCastList(map["filter"]),
      accuracyRadius: _optionalCast(map["paint"]["accuracy-radius"]),
      accuracyRadiusExpression:
          _optionalCastList(map["paint"]["accuracy-radius"]),
      accuracyRadiusBorderColor:
          (map["paint"]["accuracy-radius-border-color"] as List?)?.toRGBAInt(),
      accuracyRadiusBorderColorExpression:
          _optionalCastList(map["paint"]["accuracy-radius-border-color"]),
      accuracyRadiusColor:
          (map["paint"]["accuracy-radius-color"] as List?)?.toRGBAInt(),
      accuracyRadiusColorExpression:
          _optionalCastList(map["paint"]["accuracy-radius-color"]),
      bearing: _optionalCast(map["paint"]["bearing"]),
      bearingExpression: _optionalCastList(map["paint"]["bearing"]),
      bearingImage: _optionalCast(map["paint"]["bearing-image"]),
      bearingImageExpression: _optionalCastList(map["paint"]["bearing-image"]),
      bearingImageSize: _optionalCast(map["paint"]["bearing-image-size"]),
      bearingImageSizeExpression:
          _optionalCastList(map["paint"]["bearing-image-size"]),
      emphasisCircleColor:
          (map["paint"]["emphasis-circle-color"] as List?)?.toRGBAInt(),
      emphasisCircleColorExpression:
          _optionalCastList(map["paint"]["emphasis-circle-color"]),
      emphasisCircleGlowRange:
          (map["paint"]["emphasis-circle-glow-range"] as List?)
              ?.map<double?>((e) => e.toDouble())
              .toList(),
      emphasisCircleGlowRangeExpression:
          _optionalCastList(map["paint"]["emphasis-circle-glow-range"]),
      emphasisCircleRadius:
          _optionalCast(map["paint"]["emphasis-circle-radius"]),
      emphasisCircleRadiusExpression:
          _optionalCastList(map["paint"]["emphasis-circle-radius"]),
      imagePitchDisplacement:
          _optionalCast(map["paint"]["image-pitch-displacement"]),
      imagePitchDisplacementExpression:
          _optionalCastList(map["paint"]["image-pitch-displacement"]),
      location: (map["paint"]["location"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      locationExpression: _optionalCastList(map["paint"]["location"]),
      locationIndicatorOpacity:
          _optionalCast(map["paint"]["location-indicator-opacity"]),
      locationIndicatorOpacityExpression:
          _optionalCastList(map["paint"]["location-indicator-opacity"]),
      perspectiveCompensation:
          _optionalCast(map["paint"]["perspective-compensation"]),
      perspectiveCompensationExpression:
          _optionalCastList(map["paint"]["perspective-compensation"]),
      shadowImage: _optionalCast(map["paint"]["shadow-image"]),
      shadowImageExpression: _optionalCastList(map["paint"]["shadow-image"]),
      shadowImageSize: _optionalCast(map["paint"]["shadow-image-size"]),
      shadowImageSizeExpression:
          _optionalCastList(map["paint"]["shadow-image-size"]),
      topImage: _optionalCast(map["paint"]["top-image"]),
      topImageExpression: _optionalCastList(map["paint"]["top-image"]),
      topImageSize: _optionalCast(map["paint"]["top-image-size"]),
      topImageSizeExpression: _optionalCastList(map["paint"]["top-image-size"]),
    );
  }
}

// End of generated file.
