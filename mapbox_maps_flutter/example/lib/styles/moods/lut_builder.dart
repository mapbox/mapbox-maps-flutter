import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/painting.dart';

/// The color grade that [LutBuilder] bakes into a look-up table (LUT).
///
/// The neutral value of each field leaves colors unchanged.
@immutable
class LutParams {
  const LutParams({
    this.temperature = 0,
    this.tint = 0,
    this.hueShift = 0,
    this.saturation = 1,
    this.contrast = 1,
    this.shadowColor = _noTone,
    this.highlightColor = _noTone,
  });

  static const _noTone = HSVColor.fromAHSV(1, 0, 0, 1);

  /// Parameters that keep every color as it is.
  static const neutral = LutParams();

  /// Warm (positive) or cool (negative) white balance, from -1 to 1.
  final double temperature;

  /// Magenta (positive) or green (negative) white balance, from -1 to 1.
  final double tint;

  /// Rotation of all hues around the gray axis, in degrees.
  final double hueShift;

  /// Color strength. 0 is gray, 1 is unchanged.
  final double saturation;

  /// Contrast around mid-gray. 1 is unchanged.
  final double contrast;

  /// Tone added to dark colors. The saturation sets the strength.
  final HSVColor shadowColor;

  /// Tone added to bright colors. The saturation sets the strength.
  final HSVColor highlightColor;

  LutParams copyWith({
    double? temperature,
    double? tint,
    double? hueShift,
    double? saturation,
    double? contrast,
    HSVColor? shadowColor,
    HSVColor? highlightColor,
  }) => LutParams(
    temperature: temperature ?? this.temperature,
    tint: tint ?? this.tint,
    hueShift: hueShift ?? this.hueShift,
    saturation: saturation ?? this.saturation,
    contrast: contrast ?? this.contrast,
    shadowColor: shadowColor ?? this.shadowColor,
    highlightColor: highlightColor ?? this.highlightColor,
  );
}

/// Builds a color theme LUT at runtime.
///
/// The LUT is a strip of `tiles` square tiles, `tiles * tiles` pixels wide and
/// `tiles` pixels high. In each pixel, the column in the tile is red, the row
/// is green and the tile index is blue.
abstract final class LutBuilder {
  /// Returns the RGBA pixels of the LUT that maps each color to itself.
  static Uint8List identityPixels(int tiles) {
    final width = tiles * tiles;
    final pixels = Uint8List(width * tiles * 4);
    for (var y = 0; y < tiles; y++) {
      for (var x = 0; x < width; x++) {
        final i = (y * width + x) * 4;
        pixels[i] = _channel(x % tiles, tiles);
        pixels[i + 1] = _channel(y, tiles);
        pixels[i + 2] = _channel(x ~/ tiles, tiles);
        pixels[i + 3] = 255;
      }
    }
    return pixels;
  }

  /// Returns the RGBA pixels of the identity LUT graded with [params].
  static Uint8List transform(LutParams params, int tiles) {
    final pixels = identityPixels(tiles);
    final grade = _Grade(params);
    for (var i = 0; i < pixels.length; i += 4) {
      grade.apply(pixels, i);
    }
    return pixels;
  }

  /// Returns [params] baked into a LUT, encoded as PNG.
  static Future<Uint8List> build(LutParams params, int tiles) async {
    final pixels = transform(params, tiles);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels,
      tiles * tiles,
      tiles,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );
    final image = await completer.future;
    try {
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      return png!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }

  static int _channel(int index, int tiles) =>
      (index * 255 / (tiles - 1)).round();
}

/// The color math of [LutParams], prepared once per LUT.
class _Grade {
  _Grade(LutParams params)
    : _gainR = 1 + 0.25 * params.temperature,
      _gainG = 1 - 0.2 * params.tint,
      _gainB = 1 - 0.25 * params.temperature,
      _saturation = params.saturation,
      _contrast = params.contrast,
      _shadow = _tone(params.shadowColor),
      _highlight = _tone(params.highlightColor) {
    // Rotation around the gray axis (1, 1, 1). Zero degrees is the exact
    // identity matrix, so a neutral grade keeps every pixel.
    final angle = params.hueShift * math.pi / 180;
    final c = math.cos(angle);
    final s = math.sin(angle) / math.sqrt(3);
    final k = (1 - c) / 3;
    _hue = [c + k, k - s, k + s, k + s, c + k, k - s, k - s, k + s, c + k];
  }

  final double _gainR, _gainG, _gainB, _saturation, _contrast;
  final List<double> _shadow, _highlight;
  late final List<double> _hue;

  /// Returns a tone as signed RGB offsets, scaled by its saturation.
  static List<double> _tone(HSVColor tone) {
    final color = tone.withSaturation(1).withValue(1).toColor();
    final strength = tone.saturation * 0.35;
    return [
      (color.r - 0.5) * strength,
      (color.g - 0.5) * strength,
      (color.b - 0.5) * strength,
    ];
  }

  void apply(Uint8List pixels, int i) {
    var r = pixels[i] / 255 * _gainR;
    var g = pixels[i + 1] / 255 * _gainG;
    var b = pixels[i + 2] / 255 * _gainB;

    final h = _hue;
    final hr = h[0] * r + h[1] * g + h[2] * b;
    final hg = h[3] * r + h[4] * g + h[5] * b;
    final hb = h[6] * r + h[7] * g + h[8] * b;

    final luma = 0.2126 * hr + 0.7152 * hg + 0.0722 * hb;
    r = (luma + (hr - luma) * _saturation - 0.5) * _contrast + 0.5;
    g = (luma + (hg - luma) * _saturation - 0.5) * _contrast + 0.5;
    b = (luma + (hb - luma) * _saturation - 0.5) * _contrast + 0.5;

    final l = luma.clamp(0.0, 1.0);
    final shadow = (1 - l) * (1 - l);
    final highlight = l * l;
    r += shadow * _shadow[0] + highlight * _highlight[0];
    g += shadow * _shadow[1] + highlight * _highlight[1];
    b += shadow * _shadow[2] + highlight * _highlight[2];

    pixels[i] = (r.clamp(0.0, 1.0) * 255).round();
    pixels[i + 1] = (g.clamp(0.0, 1.0) * 255).round();
    pixels[i + 2] = (b.clamp(0.0, 1.0) * 255).round();
  }
}
