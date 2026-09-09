import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

/// Whether [a] and [b] decode to pixel-identical images.
///
/// [a] may be raw, premultiplied RGBA pixel data (for example
/// `StyleImageRgba.pixels` from `getImage()`) or an encoded image container
/// like PNG (for example a bundled asset). [_decode] checks for
/// a PNG signature and falls back to raw RGBA using [widthA]/[heightA]
/// otherwise. [b] is always genuine PNG bytes built by the test, so it
/// never needs a width or height.
Future<bool> isSameImage(
  Uint8List? a,
  Uint8List? b, {
  int? widthA,
  int? heightA,
}) async {
  if (a == null || b == null) return a == b;

  final imageA = await _decode(a, width: widthA, height: heightA);
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

final _pngSignature = <int>[0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];

bool _isPng(Uint8List bytes) {
  if (bytes.length < _pngSignature.length) return false;
  for (var i = 0; i < _pngSignature.length; i++) {
    if (bytes[i] != _pngSignature[i]) return false;
  }
  return true;
}

Future<ui.Image> _decode(Uint8List bytes, {int? width, int? height}) async {
  if (_isPng(bytes)) {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  if (width == null || height == null) {
    throw ArgumentError('Raw pixel data needs a width and a height.');
  }
  final completer = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    bytes,
    width,
    height,
    ui.PixelFormat.rgba8888,
    completer.complete,
  );
  return completer.future;
}

Future<Uint8List> _rawRgba(ui.Image image) async {
  final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  return data!.buffer.asUint8List();
}
