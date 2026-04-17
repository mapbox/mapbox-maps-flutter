import 'dart:convert';

import 'events.dart';
import 'pigeons/platform_interface_data_types.dart';

/// Geometry for querying rendered features.
class RenderedQueryGeometry {
  @Deprecated(
    'Use RenderedQueryGeometry.fromList()/fromScreenBox()/fromScreenCoordinate() instead',
  )
  RenderedQueryGeometry({required this.value, required this.type});

  RenderedQueryGeometry.fromList(List<ScreenCoordinate> points)
    : value = jsonEncode(
        points.map((e) => <String, dynamic>{'x': e.x, 'y': e.y}).toList(),
      ),
      type = Type.LIST;

  RenderedQueryGeometry.fromScreenBox(ScreenBox box)
    : value = jsonEncode(<String, dynamic>{
        'min': <String, dynamic>{'x': box.min.x, 'y': box.min.y},
        'max': <String, dynamic>{'x': box.max.x, 'y': box.max.y},
      }),
      type = Type.SCREEN_BOX;

  RenderedQueryGeometry.fromScreenCoordinate(ScreenCoordinate point)
    : value = jsonEncode(<String, dynamic>{'x': point.x, 'y': point.y}),
      type = Type.SCREEN_COORDINATE;

  /// ScreenCoordinate/List<ScreenCoordinate>/ScreenBox in Json mode.
  String value;

  /// Type of the geometry encoded in [value].
  Type type;
}

/// A [FeaturesetFeature] with a typed [FeaturesetDescriptor]. This is used to
/// provide typed access to the specific properties and state of a feature with
/// a known type such as StandardPOIs or StandardBuildings.
class TypedFeaturesetFeature<T extends FeaturesetDescriptor>
    extends FeaturesetFeature {
  TypedFeaturesetFeature(
    T featureset,
    Map<String?, Object?> geometry,
    Map<String, Object?> properties,
    Map<String, Object?> state, {
    super.id,
  }) : super(
         featureset: featureset,
         geometry: geometry,
         properties: properties,
         state: state,
       );

  /// Creates a [TypedFeaturesetFeature] from a [FeaturesetFeature].
  TypedFeaturesetFeature.fromFeaturesetFeature(FeaturesetFeature feature)
    : super(
        id: feature.id,
        featureset: feature.featureset,
        geometry: feature.geometry,
        properties: feature.properties,
        state: feature.state,
      );
}

enum _SupportedInteractionType { tap, longTap }

/// The kind of gesture an [Interaction] listens for.
///
/// Well-known values are [InteractionType.tap] and [InteractionType.longTap].
/// New values may be added in future SDK versions without breaking existing
/// code — unlike an enum, there is no exhaustiveness requirement on switches.
///
/// Values cannot be constructed outside of the platform interface package.
extension type const InteractionType._(_SupportedInteractionType _kind) {
  /// A single tap (mobile) or click (GL-JS).
  static const tap = InteractionType._(_SupportedInteractionType.tap);

  /// A long press. Not available on web.
  static const longTap = InteractionType._(_SupportedInteractionType.longTap);
}

/// Base class for interactions that can be added to the map.
///
/// To create an interaction use [TapInteraction] and [LongTapInteraction].
///
/// See also: `MapboxMap.addInteraction`.
class Interaction {
  /// The featureset descriptor that specifies the featureset to be included in the interaction.
  FeaturesetDescriptor? featuresetDescriptor;

  /// The kind of gesture this interaction listens for.
  InteractionType interactionType;

  /// Whether to stop the propagation of the interaction to the map. Defaults to true.
  bool stopPropagation;

  /// An optional filter of features that should trigger the interaction.
  String? filter;

  /// Radius of a tappable area.
  double? radius;

  Interaction({
    this.featuresetDescriptor,
    required this.interactionType,
    this.stopPropagation = true,
    this.filter,
    this.radius,
  });
}

/// An [Interaction] with an action that has a typed [FeaturesetFeature] as input.
base class TypedInteraction<T extends TypedFeaturesetFeature>
    extends Interaction {
  TypedInteraction({
    super.featuresetDescriptor,
    required super.interactionType,
    super.filter,
    super.radius,
    super.stopPropagation = true,
    required this.action,
    required this.featureFactory,
  });

  OnInteraction<T> action;

  /// Constructs a typed feature from a raw [FeaturesetFeature].
  ///
  /// The factory captures the static type [T] at construction time, avoiding
  /// unsafe runtime casts.
  final T Function(FeaturesetFeature) featureFactory;
}
