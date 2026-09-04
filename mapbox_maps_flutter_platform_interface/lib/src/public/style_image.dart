import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show listEquals;

/// An image that can be added to a map style (icons, patterns, image sources).
///
/// Prefer [StyleImage.bytes] for the common case — PNG/JPEG/WebP from
/// `rootBundle`, the network, or a file. Use [StyleImage.rgba] only when
/// generating pixels yourself.
///
/// ```dart
/// final image = StyleImage.bytes(
///   (await rootBundle.load('assets/icon.png')).buffer.asUint8List(),
/// );
/// ```
sealed class StyleImage {
  const StyleImage._();

  /// Encoded image bytes (PNG, JPEG, WebP, …).
  ///
  /// Dimensions come from the decoder — do not pass width/height.
  /// Typical source: `rootBundle.load`, HTTP response body, file read.
  const factory StyleImage.bytes(Uint8List bytes) = StyleImageBytes;

  /// Premultiplied RGBA pixel buffer.
  ///
  /// [pixels] must contain exactly `4 * width * height` bytes (one scanline
  /// after another). Prefer [StyleImage.bytes] unless you are generating
  /// pixels procedurally.
  factory StyleImage.rgba({
    required int width,
    required int height,
    required Uint8List pixels,
  }) = StyleImageRgba;

  /// Converts a `dart:ui` [ui.Image] to a [StyleImage].
  ///
  /// Reads [ui.ImageByteFormat.rawRgba] pixels, which are already
  /// premultiplied. This skips the PNG encode and decode steps.
  ///
  /// The return type is [StyleImage], not [StyleImageRgba]. This keeps room
  /// to switch to PNG later without a breaking change.
  static Future<StyleImage> fromImage(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) {
      throw StateError('Failed to read pixels from ui.Image.');
    }
    return StyleImage.rgba(
      width: image.width,
      height: image.height,
      pixels: byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
    );
  }
}

/// Encoded image file bytes. See [StyleImage.bytes].
final class StyleImageBytes extends StyleImage {
  const StyleImageBytes(this.bytes) : super._();

  /// Encoded image file contents.
  final Uint8List bytes;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StyleImageBytes && listEquals(bytes, other.bytes);

  @override
  int get hashCode => Object.hashAll(bytes);

  @override
  String toString() => 'StyleImage.bytes(${bytes.length} bytes)';
}

/// Raw premultiplied RGBA pixels. See [StyleImage.rgba].
final class StyleImageRgba extends StyleImage {
  /// Throws [ArgumentError] if [pixels] length is not `4 * width * height`.
  StyleImageRgba({
    required this.width,
    required this.height,
    required this.pixels,
  }) : super._() {
    if (pixels.length != 4 * width * height) {
      throw ArgumentError.value(
        pixels.length,
        'pixels',
        'must be 4 * width * height (${4 * width * height}) for a ${width}x$height image',
      );
    }
  }

  /// Width in pixels.
  final int width;

  /// Height in pixels.
  final int height;

  /// Premultiplied RGBA scanlines (`4 * width * height` bytes).
  final Uint8List pixels;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StyleImageRgba &&
          width == other.width &&
          height == other.height &&
          listEquals(pixels, other.pixels);

  @override
  int get hashCode => Object.hash(width, height, Object.hashAll(pixels));

  @override
  String toString() => 'StyleImage.rgba(${width}x$height)';
}
