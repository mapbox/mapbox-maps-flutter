import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

import 'style_types.dart';

@internal
T? styleOptionalCast<T>(dynamic value) {
  if (value is T) return value;
  if (value is num && T == double) return value.toDouble() as T;
  return null;
}

@internal
List<T>? styleOptionalCastList<T>(dynamic value) {
  if (value is List) {
    return value.whereType<T>().toList();
  }
  return null;
}

const _colorFunctions = {'rgb', 'rgba', 'hsl', 'hsla'};

/// Returns `true` for a constant color list such as `["rgba", 255, 0, 0, 1]`.
/// A color list with a sub-expression is an expression.
bool _isColorList(Object? value) =>
    value is List &&
    _colorFunctions.contains(value.firstOrNull) &&
    value.skip(1).every((component) => component is num);

final _rgbPattern = RegExp(
  r'^rgba?\(\s*([\d.]+)\s*,\s*([\d.]+)\s*,\s*([\d.]+)\s*(?:,\s*([\d.]+)\s*)?\)$',
);
final _hexPattern = RegExp(
  r'^#([0-9a-fA-F]{3,4}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$',
);

/// Returns the ARGB value of a CSS color string in `rgb(...)`, `rgba(...)` or
/// hex form, or `null` for other forms.
int? _cssColor(String value) {
  final rgb = _rgbPattern.firstMatch(value.trim());
  if (rgb != null) {
    int channel(int group) =>
        double.parse(rgb.group(group)!).round().clamp(0, 255);
    final alpha = double.parse(rgb.group(4) ?? '1');
    return (alpha * 255).round().clamp(0, 255) << 24 |
        channel(1) << 16 |
        channel(2) << 8 |
        channel(3);
  }
  final hex = _hexPattern.firstMatch(value.trim())?.group(1);
  if (hex == null) return null;
  final digits = hex.length <= 4
      ? hex.split('').map((digit) => '$digit$digit').join()
      : hex;
  final rgbValue = int.parse(digits.substring(0, 6), radix: 16);
  final alpha = digits.length == 8
      ? int.parse(digits.substring(6), radix: 16)
      : 0xFF;
  return alpha << 24 | rgbValue;
}

/// Returns the color of a style JSON value: a CSS color string in
/// `rgb(...)`, `rgba(...)` or hex form, or a constant color list such as
/// `["rgba", r, g, b, a]`. Returns `null` for other values.
@internal
int? styleColorFromJson(Object? value) {
  if (value is String) return _cssColor(value);
  if (_isColorList(value)) return (value as List).toRGBAInt();
  return null;
}

/// Returns the numbers of a style JSON array of numbers, or `null` if the
/// value is not an array of numbers.
@internal
List<double?>? styleNumberListFromJson(Object? value) {
  if (value is! List || !value.every((element) => element is num)) {
    return null;
  }
  return [for (final element in value) (element as num).toDouble()];
}

/// Returns the expression of a style JSON value, or `null` if the value is
/// a constant. An expression is a list that starts with an operator name.
@internal
List<Object>? styleExpressionFromJson(Object? value) {
  if (value is! List || value.firstOrNull is! String || _isColorList(value)) {
    return null;
  }
  return styleOptionalCastList<Object>(value);
}

@internal
Future<String?> resolveFlutterAssetPath(String? flutterAssetUri) =>
    MapboxMapsFlutterPlatform.instance.mapboxMapsOptions.getFlutterAssetPath(
      flutterAssetUri,
    );
