// This file is generated.
part of mapbox_maps_flutter;

/// Location Indicator layer.
class LocationIndicatorLayer extends Layer {
  LocationIndicatorLayer({
    required String id,
    Visibility? visibility,
    List<Object>? visibilityExpression,
    double? minZoom,
    double? maxZoom,
    String? slot,
    String? this.bearingImage,
    List<Object>? this.bearingImageExpression,
    String? this.shadowImage,
    List<Object>? this.shadowImageExpression,
    String? this.topImage,
    List<Object>? this.topImageExpression,
    double? this.accuracyRadius,
    List<Object>? this.accuracyRadiusExpression,
    int? this.accuracyRadiusBorderColor,
    List<Object>? this.accuracyRadiusBorderColorExpression,
    int? this.accuracyRadiusColor,
    List<Object>? this.accuracyRadiusColorExpression,
    double? this.bearing,
    List<Object>? this.bearingExpression,
    double? this.bearingImageSize,
    List<Object>? this.bearingImageSizeExpression,
    int? this.emphasisCircleColor,
    List<Object>? this.emphasisCircleColorExpression,
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
    double? this.shadowImageSize,
    List<Object>? this.shadowImageSizeExpression,
    double? this.topImageSize,
    List<Object>? this.topImageSizeExpression,
  }) : super(
            id: id,
            visibility: visibility,
            maxZoom: maxZoom,
            minZoom: minZoom,
            slot: slot);

  @override
  String getType() => "location-indicator";

  /// Name of image in sprite to use as the middle of the location indicator.
  String? bearingImage;

  /// Name of image in sprite to use as the middle of the location indicator.
  List<Object>? bearingImageExpression;

  /// Name of image in sprite to use as the background of the location indicator.
  String? shadowImage;

  /// Name of image in sprite to use as the background of the location indicator.
  List<Object>? shadowImageExpression;

  /// Name of image in sprite to use as the top of the location indicator.
  String? topImage;

  /// Name of image in sprite to use as the top of the location indicator.
  List<Object>? topImageExpression;

  /// The accuracy, in meters, of the position source used to retrieve the position of the location indicator.
  double? accuracyRadius;

  /// The accuracy, in meters, of the position source used to retrieve the position of the location indicator.
  List<Object>? accuracyRadiusExpression;

  /// The color for drawing the accuracy radius border. To adjust transparency, set the alpha component of the color accordingly.
  int? accuracyRadiusBorderColor;

  /// The color for drawing the accuracy radius border. To adjust transparency, set the alpha component of the color accordingly.
  List<Object>? accuracyRadiusBorderColorExpression;

  /// The color for drawing the accuracy radius, as a circle. To adjust transparency, set the alpha component of the color accordingly.
  int? accuracyRadiusColor;

  /// The color for drawing the accuracy radius, as a circle. To adjust transparency, set the alpha component of the color accordingly.
  List<Object>? accuracyRadiusColorExpression;

  /// The bearing of the location indicator.
  double? bearing;

  /// The bearing of the location indicator.
  List<Object>? bearingExpression;

  /// The size of the bearing image, as a scale factor applied to the size of the specified image.
  double? bearingImageSize;

  /// The size of the bearing image, as a scale factor applied to the size of the specified image.
  List<Object>? bearingImageSizeExpression;

  /// The color of the circle emphasizing the indicator. To adjust transparency, set the alpha component of the color accordingly.
  int? emphasisCircleColor;

  /// The color of the circle emphasizing the indicator. To adjust transparency, set the alpha component of the color accordingly.
  List<Object>? emphasisCircleColorExpression;

  /// The radius, in pixel, of the circle emphasizing the indicator, drawn between the accuracy radius and the indicator shadow.
  double? emphasisCircleRadius;

  /// The radius, in pixel, of the circle emphasizing the indicator, drawn between the accuracy radius and the indicator shadow.
  List<Object>? emphasisCircleRadiusExpression;

  /// The displacement off the center of the top image and the shadow image when the pitch of the map is greater than 0. This helps producing a three-dimensional appearence.
  double? imagePitchDisplacement;

  /// The displacement off the center of the top image and the shadow image when the pitch of the map is greater than 0. This helps producing a three-dimensional appearence.
  List<Object>? imagePitchDisplacementExpression;

  /// An array of [latitude, longitude, altitude] position of the location indicator.
  List<double?>? location;

  /// An array of [latitude, longitude, altitude] position of the location indicator.
  List<Object>? locationExpression;

  /// The opacity of the entire location indicator layer.
  double? locationIndicatorOpacity;

  /// The opacity of the entire location indicator layer.
  List<Object>? locationIndicatorOpacityExpression;

  /// The amount of the perspective compensation, between 0 and 1. A value of 1 produces a location indicator of constant width across the screen. A value of 0 makes it scale naturally according to the viewing projection.
  double? perspectiveCompensation;

  /// The amount of the perspective compensation, between 0 and 1. A value of 1 produces a location indicator of constant width across the screen. A value of 0 makes it scale naturally according to the viewing projection.
  List<Object>? perspectiveCompensationExpression;

  /// The size of the shadow image, as a scale factor applied to the size of the specified image.
  double? shadowImageSize;

  /// The size of the shadow image, as a scale factor applied to the size of the specified image.
  List<Object>? shadowImageSizeExpression;

  /// The size of the top image, as a scale factor applied to the size of the specified image.
  double? topImageSize;

  /// The size of the top image, as a scale factor applied to the size of the specified image.
  List<Object>? topImageSizeExpression;

  @override
  String _encode() {
    var layout = {};
    if (visibility != null) {
      layout["visibility"] =
          visibility?.name.toLowerCase().replaceAll("_", "-");
    }
    if (bearingImage != null) {
      layout["bearing-image"] = bearingImage;
    }
    if (shadowImage != null) {
      layout["shadow-image"] = shadowImage;
    }
    if (topImage != null) {
      layout["top-image"] = topImage;
    }
    var paint = {};
    if (accuracyRadiusExpression != null) {
      paint["accuracy-radius"] = accuracyRadiusExpression;
    }
    if (accuracyRadius != null) {
      paint["accuracy-radius"] = accuracyRadius;
    }

    if (accuracyRadiusBorderColorExpression != null) {
      paint["accuracy-radius-border-color"] =
          accuracyRadiusBorderColorExpression;
    }
    if (accuracyRadiusBorderColor != null) {
      paint["accuracy-radius-border-color"] =
          accuracyRadiusBorderColor?.toRGBA();
    }

    if (accuracyRadiusColorExpression != null) {
      paint["accuracy-radius-color"] = accuracyRadiusColorExpression;
    }
    if (accuracyRadiusColor != null) {
      paint["accuracy-radius-color"] = accuracyRadiusColor?.toRGBA();
    }

    if (bearingExpression != null) {
      paint["bearing"] = bearingExpression;
    }
    if (bearing != null) {
      paint["bearing"] = bearing;
    }

    if (bearingImageSizeExpression != null) {
      paint["bearing-image-size"] = bearingImageSizeExpression;
    }
    if (bearingImageSize != null) {
      paint["bearing-image-size"] = bearingImageSize;
    }

    if (emphasisCircleColorExpression != null) {
      paint["emphasis-circle-color"] = emphasisCircleColorExpression;
    }
    if (emphasisCircleColor != null) {
      paint["emphasis-circle-color"] = emphasisCircleColor?.toRGBA();
    }

    if (emphasisCircleRadiusExpression != null) {
      paint["emphasis-circle-radius"] = emphasisCircleRadiusExpression;
    }
    if (emphasisCircleRadius != null) {
      paint["emphasis-circle-radius"] = emphasisCircleRadius;
    }

    if (imagePitchDisplacementExpression != null) {
      paint["image-pitch-displacement"] = imagePitchDisplacementExpression;
    }
    if (imagePitchDisplacement != null) {
      paint["image-pitch-displacement"] = imagePitchDisplacement;
    }

    if (locationExpression != null) {
      paint["location"] = locationExpression;
    }
    if (location != null) {
      paint["location"] = location;
    }

    if (locationIndicatorOpacityExpression != null) {
      paint["location-indicator-opacity"] = locationIndicatorOpacityExpression;
    }
    if (locationIndicatorOpacity != null) {
      paint["location-indicator-opacity"] = locationIndicatorOpacity;
    }

    if (perspectiveCompensationExpression != null) {
      paint["perspective-compensation"] = perspectiveCompensationExpression;
    }
    if (perspectiveCompensation != null) {
      paint["perspective-compensation"] = perspectiveCompensation;
    }

    if (shadowImageSizeExpression != null) {
      paint["shadow-image-size"] = shadowImageSizeExpression;
    }
    if (shadowImageSize != null) {
      paint["shadow-image-size"] = shadowImageSize;
    }

    if (topImageSizeExpression != null) {
      paint["top-image-size"] = topImageSizeExpression;
    }
    if (topImageSize != null) {
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
      bearingImage: optionalCast(map["layout"]["bearing-image"]),
      bearingImageExpression: optionalCast(map["layout"]["bearing-image"]),
      shadowImage: optionalCast(map["layout"]["shadow-image"]),
      shadowImageExpression: optionalCast(map["layout"]["shadow-image"]),
      topImage: optionalCast(map["layout"]["top-image"]),
      topImageExpression: optionalCast(map["layout"]["top-image"]),
      accuracyRadius: optionalCast(map["paint"]["accuracy-radius"]),
      accuracyRadiusExpression: optionalCast(map["layout"]["accuracy-radius"]),
      accuracyRadiusBorderColor:
          (map["paint"]["accuracy-radius-border-color"] as List?)?.toRGBAInt(),
      accuracyRadiusBorderColorExpression:
          optionalCast(map["layout"]["accuracy-radius-border-color"]),
      accuracyRadiusColor:
          (map["paint"]["accuracy-radius-color"] as List?)?.toRGBAInt(),
      accuracyRadiusColorExpression:
          optionalCast(map["layout"]["accuracy-radius-color"]),
      bearing: optionalCast(map["paint"]["bearing"]),
      bearingExpression: optionalCast(map["layout"]["bearing"]),
      bearingImageSize: optionalCast(map["paint"]["bearing-image-size"]),
      bearingImageSizeExpression:
          optionalCast(map["layout"]["bearing-image-size"]),
      emphasisCircleColor:
          (map["paint"]["emphasis-circle-color"] as List?)?.toRGBAInt(),
      emphasisCircleColorExpression:
          optionalCast(map["layout"]["emphasis-circle-color"]),
      emphasisCircleRadius:
          optionalCast(map["paint"]["emphasis-circle-radius"]),
      emphasisCircleRadiusExpression:
          optionalCast(map["layout"]["emphasis-circle-radius"]),
      imagePitchDisplacement:
          optionalCast(map["paint"]["image-pitch-displacement"]),
      imagePitchDisplacementExpression:
          optionalCast(map["layout"]["image-pitch-displacement"]),
      location: (map["paint"]["location"] as List?)
          ?.map<double?>((e) => e.toDouble())
          .toList(),
      locationExpression: optionalCast(map["layout"]["location"]),
      locationIndicatorOpacity:
          optionalCast(map["paint"]["location-indicator-opacity"]),
      locationIndicatorOpacityExpression:
          optionalCast(map["layout"]["location-indicator-opacity"]),
      perspectiveCompensation:
          optionalCast(map["paint"]["perspective-compensation"]),
      perspectiveCompensationExpression:
          optionalCast(map["layout"]["perspective-compensation"]),
      shadowImageSize: optionalCast(map["paint"]["shadow-image-size"]),
      shadowImageSizeExpression:
          optionalCast(map["layout"]["shadow-image-size"]),
      topImageSize: optionalCast(map["paint"]["top-image-size"]),
      topImageSizeExpression: optionalCast(map["layout"]["top-image-size"]),
    );
  }
}

// End of generated file.
