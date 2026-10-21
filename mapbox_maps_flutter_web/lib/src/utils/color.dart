/// Formats an ARGB integer as a CSS `rgba(r, g, b, a)` color.
///
/// The platform APIs carry colors as `0xAARRGGBB`, matching the value of
/// Flutter's `Color`. The comma syntax is necessary because the GL JS style
/// parser does not accept the space-separated CSS Color 4 syntax.
String cssColor(int argb) {
  final alpha = (argb >> 24) & 0xFF;
  final red = (argb >> 16) & 0xFF;
  final green = (argb >> 8) & 0xFF;
  final blue = argb & 0xFF;
  return 'rgba($red, $green, $blue, ${alpha / 255})';
}
