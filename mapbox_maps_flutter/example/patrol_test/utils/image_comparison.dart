import 'dart:typed_data';
import 'dart:ui' as ui;

/// Whether [a] and [b] decode to pixel-identical images.
///
/// Every image field round-trips through a native decode/re-encode step
/// (Bitmap -> PNG on Android, UIImage -> pngData() on iOS) before Flutter
/// ever sees it again. That re-encoding produces a different file -
/// different size, different compression - but doesn't touch a single
/// pixel.
Future<bool> isSameImage(Uint8List? a, Uint8List? b) async {
  if (a == null || b == null) return a == b;

  final imageA = await _decode(a);
  final imageB = await _decode(b);
  try {
    if (imageA.width != imageB.width || imageA.height != imageB.height) {
      return false;
    }

    final pixelsA = await _rawRgba(imageA);
    final pixelsB = await _rawRgba(imageB);
    for (var i = 0; i < pixelsA.length; i++) {
      if (pixelsA[i] != pixelsB[i]) return false;
    }
    return true;
  } finally {
    imageA.dispose();
    imageB.dispose();
  }
}

Future<ui.Image> _decode(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  return frame.image;
}

Future<Uint8List> _rawRgba(ui.Image image) async {
  final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  return data!.buffer.asUint8List();
}
