import 'package:meta/meta.dart';

/// Controls whether a color property is affected by the style color theme.
@experimental
@immutable
final class ColorUseTheme {
  const ColorUseTheme._(this.value);

  /// The style-spec string for this value.
  final String value;

  /// The color property is affected by the current color theme.
  static const ColorUseTheme useDefault = ColorUseTheme._('default');

  /// The color property is not affected by the color theme and always
  /// appears exactly as specified.
  static const ColorUseTheme none = ColorUseTheme._('none');

  /// All values that this SDK supports.
  static const List<ColorUseTheme> values = [useDefault, none];

  /// Returns the value with the style-spec string [value], or `null` if
  /// [value] is not a string that this SDK supports.
  static ColorUseTheme? fromValue(Object? value) {
    for (final candidate in values) {
      if (candidate.value == value) return candidate;
    }
    return null;
  }

  @override
  String toString() => 'ColorUseTheme($value)';
}

/// A color theme that applies a color grading look-up table (LUT) to a style.
///
/// The LUT is a PNG image of a 3D color cube, laid out as a horizontal strip
/// of square slices.
@experimental
@immutable
final class ColorTheme {
  /// Creates a color theme from a base64-encoded PNG LUT.
  const ColorTheme.base64(String data) : _data = data;

  /// Creates a color theme from an expression that evaluates to a
  /// base64-encoded PNG LUT.
  const ColorTheme.expression(List<Object> expression) : _data = expression;

  final Object _data;

  /// Encodes this theme as a style-spec `color-theme` object.
  Map<String, Object> toJson() => {'data': _data};
}
