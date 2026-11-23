// ignore_for_file: deprecated_member_use_from_same_package
import '../pigeons/platform_interface_data_types.dart';
import '../public/style_image.dart';

/// Bridges the deprecated [MbxImage] to [StyleImage].
extension MbxImageToStyleImage on MbxImage {
  /// Converts to [StyleImage].
  ///
  /// [MbxImage] carries no format tag, unlike [StyleImage]: when [data]'s
  /// length matches `4 * width * height`, it is treated as raw premultiplied
  /// RGBA; otherwise, as encoded PNG/JPEG/WebP bytes.
  StyleImage toStyleImage() {
    if (data.length == width * height * 4) {
      return StyleImage.rgba(width: width, height: height, pixels: data);
    }
    return StyleImage.bytes(data);
  }
}

/// Bridges [StyleImage] to the deprecated [MbxImage].
extension StyleImageToMbxImage on StyleImage {
  /// Converts to [MbxImage]. Lossless: the concrete [StyleImage] variant is
  /// always known, so no format guessing is involved.
  MbxImage toMbxImage() => switch (this) {
    StyleImageRgba(:final width, :final height, :final pixels) => MbxImage(
      width: width,
      height: height,
      data: pixels,
    ),
    StyleImageBytes(:final bytes) => MbxImage(width: 0, height: 0, data: bytes),
  };
}
