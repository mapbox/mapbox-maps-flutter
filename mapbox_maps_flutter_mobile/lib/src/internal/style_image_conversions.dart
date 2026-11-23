part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

/// Bridges the public [StyleImage] to its pigeon wire representation.
extension StyleImageToWire on StyleImage {
  /// Converts to [StyleImageWire]. Lossless: the concrete variant is always
  /// known, so no format guessing is involved.
  StyleImageWire toWire() => switch (this) {
    StyleImageRgba(:final width, :final height, :final pixels) =>
      StyleImageWireRgba(width: width, height: height, pixels: pixels),
    StyleImageBytes(:final bytes) => StyleImageWireBytes(data: bytes),
  };
}

/// Bridges [StyleImageWireRgba] to the public [StyleImageRgba].
extension StyleImageWireRgbaToStyleImageRgba on StyleImageWireRgba {
  /// Converts to [StyleImageRgba].
  StyleImageRgba toStyleImageRgba() =>
      StyleImageRgba(width: width, height: height, pixels: pixels);
}
