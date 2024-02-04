import 'package:pigeon/pigeon.dart';

class Size {
  Size({
    required this.width,
    required this.height,
  });

  /// Width of the size.
  double width;

  /// Height of the size.
  double height;
}

class MapSnapshotOptions {
  MapSnapshotOptions(this.size, this.pixelRatio);

  Size size;
  double pixelRatio;
}

class SnapshotOverlayOptions {
  SnapshotOverlayOptions({this.showLogo = true, this.showAttributes = true});

  bool showLogo;
  bool showAttributes;
}

class MbxImage {
  MbxImage({
    required this.width,
    required this.height,
    required this.data,
  });

  /// The width of the image, in screen pixels.
  int width;

  /// The height of the image, in screen pixels.
  int height;

  /// 32-bit premultiplied RGBA image data.
  ///
  /// An uncompressed image data encoded in 32-bit RGBA format with premultiplied
  /// alpha channel. This field should contain exactly `4 * width * height` bytes. It
  /// should consist of a sequence of scanlines.
  Uint8List data;
}

@HostApi()
abstract class _SnapShotManager {
  /// After generate, modify and return Snapshotter to take more func
  String create(MapSnapshotOptions options, SnapshotOverlayOptions overlayOptions);

  @async
  MbxImage? snapshot();
}
