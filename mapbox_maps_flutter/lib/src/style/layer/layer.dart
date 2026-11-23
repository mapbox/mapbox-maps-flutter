import 'package:meta/meta.dart';

import '../style_types.dart';

/// Base class for all style layers.
abstract base class Layer {
  Layer({
    required this.id,
    this.visibility,
    this.visibilityExpression,
    this.filter,
    this.maxZoom,
    this.minZoom,
    this.slot,
  });

  /// The ID of the Layer.
  String id;

  /// The visibility of the layer.
  Visibility? visibility;

  /// The visibility of the layer, expressed as a style expression.
  List<Object>? visibilityExpression;

  /// Expression specifying conditions on source features.
  /// Only features that match the filter are displayed.
  List<Object>? filter;

  /// Minimum zoom level. At zoom levels less than this, the layer is hidden.
  /// Range: 0 to 24.
  double? minZoom;

  /// Maximum zoom level. At zoom levels equal to or greater than this, the
  /// layer is hidden. Range: 0 to 24.
  double? maxZoom;

  /// The slot this layer is assigned to. If specified and a slot with that
  /// name exists, the layer is placed at that slot's position in the layer order.
  String? slot;

  /// Returns the layer's type as a String (e.g. "fill", "line").
  String getType();

  /// Encodes the layer as a JSON string to be passed over the platform
  /// channel. Implemented by generated subclasses.
  @internal
  @mustBeOverridden
  Future<String> encode();
}
