import 'package:turf/turf.dart';

import '../pigeons/platform_interface_data_types.dart';
import '../public/style_projection.dart';

StyleProjection createStyleProjection(
  StyleProjectionType type, {
  Point? center,
  StyleProjectionParallels? parallels,
}) => StyleProjection.fromType(type, center: center, parallels: parallels);

extension StyleProjectionToStyleProjectionType on StyleProjection {
  StyleProjectionType get styleProjectionType => type;
}
