// ignore_for_file: deprecated_member_use_from_same_package
import 'package:meta/meta.dart';
import 'package:turf/turf.dart';

import '../pigeons/platform_interface_data_types.dart';

/// The style projection name.
@Deprecated(
  'Use StyleProjection.mercator, StyleProjection.globe or StyleProjection.albers',
)
enum StyleProjectionName { mercator, globe }

/// The standard parallels of a conic projection, as latitudes in degrees.
typedef StyleProjectionParallels = ({double start, double end});

/// The style projection.
class StyleProjection {
  @Deprecated(
    'Use StyleProjection.mercator, StyleProjection.globe or StyleProjection.albers',
  )
  StyleProjection({required StyleProjectionName name})
    : this.fromType(StyleProjectionType.values.byName(name.name));

  @internal
  StyleProjection.fromType(this.type, {this.center, this.parallels});

  /// An Albers equal-area projection centered on the continental United States. You can configure the projection for a different region by setting `center` and `parallels` properties. You may want to set max bounds to constrain the map to the relevant region.
  @experimental
  StyleProjection.albers({this.center, this.parallels})
    : type = StyleProjectionType.albers;

  @internal
  StyleProjectionType type;

  /// The reference longitude and latitude of the projection. `center` takes the form of [lng, lat]. This property is only configurable for conic projections (Albers and Lambert Conformal Conic). All other projections are centered on [0, 0].
  @experimental
  final Point? center;

  /// The standard parallels of the projection, denoting the desired latitude range with minimal distortion. `parallels` takes the form of [lat0, lat1]. This property is only configurable for conic projections (Albers and Lambert Conformal Conic).
  @experimental
  final StyleProjectionParallels? parallels;

  /// The Mercator projection. This is the default projection.
  static StyleProjection get mercator =>
      StyleProjection.fromType(StyleProjectionType.mercator);

  /// A globe projection.
  static StyleProjection get globe =>
      StyleProjection.fromType(StyleProjectionType.globe);

  /// The projection name. Throws an [UnsupportedError] for [albers].
  @Deprecated(
    'Compare with StyleProjection.mercator, StyleProjection.globe or StyleProjection.albers',
  )
  StyleProjectionName get name => switch (type) {
    StyleProjectionType.mercator => StyleProjectionName.mercator,
    StyleProjectionType.globe => StyleProjectionName.globe,
    _ => throw UnsupportedError(
      'StyleProjectionName does not have ${type.name}',
    ),
  };

  @Deprecated(
    'Use StyleProjection.mercator, StyleProjection.globe or StyleProjection.albers',
  )
  set name(StyleProjectionName value) {
    type = StyleProjectionType.values.byName(value.name);
  }

  @Deprecated('This is an internal method and will be removed.')
  Object encode() => <Object?>[name];

  @Deprecated('This is an internal method and will be removed.')
  static StyleProjection decode(Object result) {
    result as List<Object?>;
    return StyleProjection(name: result[0]! as StyleProjectionName);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is StyleProjection &&
      other.type == type &&
      other.center == center &&
      other.parallels == parallels;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => Object.hash(type, center, parallels);

  @override
  String toString() => [
    'StyleProjection(${type.name}',
    if (center != null) ', center: ${center!.coordinates.toJson()}',
    if (parallels != null) ', parallels: $parallels',
    ')',
  ].join();
}
