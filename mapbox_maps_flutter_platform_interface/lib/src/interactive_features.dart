import 'dart:convert';

import 'package:flutter/foundation.dart' show immutable, listEquals;

import 'events.dart';
import 'pigeons/platform_interface_data_types.dart';

/// Geometry for querying rendered features.
///
/// Construct via [RenderedQueryGeometry.fromScreenCoordinate],
/// [RenderedQueryGeometry.fromScreenBox], or [RenderedQueryGeometry.fromList].
@immutable
sealed class RenderedQueryGeometry {
  const RenderedQueryGeometry._();

  /// Query a single screen point.
  const factory RenderedQueryGeometry.fromScreenCoordinate(
    ScreenCoordinate point,
  ) = ScreenCoordinateRenderedQueryGeometry;

  /// Query a rectangular screen area.
  const factory RenderedQueryGeometry.fromScreenBox(ScreenBox box) =
      ScreenBoxRenderedQueryGeometry;

  /// Query a screen area defined by a list of points.
  ///
  /// On web, GL JS only accepts a point or an axis-aligned bounding box. The
  /// points are always reduced to their bounding box before querying. This
  /// also applies to a two-point list: it becomes a rectangle on web. On
  /// mobile, the native hit-test receives the points as given.
  factory RenderedQueryGeometry.fromList(List<ScreenCoordinate> points) =
      ScreenCoordinateListRenderedQueryGeometry;

  /// JSON-encoded representation of the geometry.
  @Deprecated(
    'Use pattern matching on the RenderedQueryGeometry subclasses '
    '(ScreenCoordinateRenderedQueryGeometry, ScreenBoxRenderedQueryGeometry, '
    'ScreenCoordinateListRenderedQueryGeometry) instead. Will be removed in '
    'a future release.',
  )
  String get value => switch (this) {
    ScreenCoordinateRenderedQueryGeometry(:final point) => jsonEncode(
      <String, dynamic>{'x': point.x, 'y': point.y},
    ),
    ScreenBoxRenderedQueryGeometry(:final box) => jsonEncode(<String, dynamic>{
      'min': <String, dynamic>{'x': box.min.x, 'y': box.min.y},
      'max': <String, dynamic>{'x': box.max.x, 'y': box.max.y},
    }),
    ScreenCoordinateListRenderedQueryGeometry(:final points) => jsonEncode(
      points.map((e) => <String, dynamic>{'x': e.x, 'y': e.y}).toList(),
    ),
  };

  /// The type of geometry encoded in [value].
  @Deprecated(
    'Use pattern matching on the RenderedQueryGeometry subclasses instead. '
    'Will be removed in a future release.',
  )
  Type get type => switch (this) {
    ScreenCoordinateRenderedQueryGeometry() => Type.SCREEN_COORDINATE,
    ScreenBoxRenderedQueryGeometry() => Type.SCREEN_BOX,
    ScreenCoordinateListRenderedQueryGeometry() => Type.LIST,
  };
}

/// [RenderedQueryGeometry] for a single screen point.
final class ScreenCoordinateRenderedQueryGeometry
    extends RenderedQueryGeometry {
  const ScreenCoordinateRenderedQueryGeometry(this.point) : super._();

  /// The screen point to query.
  final ScreenCoordinate point;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScreenCoordinateRenderedQueryGeometry && other.point == point);

  @override
  int get hashCode => point.hashCode;
}

/// [RenderedQueryGeometry] for a rectangular screen area.
final class ScreenBoxRenderedQueryGeometry extends RenderedQueryGeometry {
  const ScreenBoxRenderedQueryGeometry(this.box) : super._();

  /// The screen box to query.
  final ScreenBox box;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScreenBoxRenderedQueryGeometry && other.box == box);

  @override
  int get hashCode => box.hashCode;
}

/// [RenderedQueryGeometry] for a screen area defined by a list of points.
final class ScreenCoordinateListRenderedQueryGeometry
    extends RenderedQueryGeometry {
  ScreenCoordinateListRenderedQueryGeometry(List<ScreenCoordinate> points)
    : points = List.unmodifiable(points),
      super._();

  /// The screen points defining the queried area.
  final List<ScreenCoordinate> points;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScreenCoordinateListRenderedQueryGeometry &&
          listEquals(other.points, points));

  @override
  int get hashCode => Object.hashAll(points);
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
