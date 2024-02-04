import 'package:pigeon/pigeon.dart';

class MbxEdgeInsets {
  MbxEdgeInsets({
    required this.top,
    required this.left,
    required this.bottom,
    required this.right,
  });

  /// Padding from the top.
  double top;

  /// Padding from the left.
  double left;

  /// Padding from the bottom.
  double bottom;

  /// Padding from the right.
  double right;
}

class ScreenCoordinate {
  ScreenCoordinate({
    required this.x,
    required this.y,
  });

  /// A value representing the x position of this coordinate.
  double x;

  /// A value representing the y position of this coordinate.
  double y;
}

class CameraOptions {
  CameraOptions({
    this.center,
    this.padding,
    this.anchor,
    this.zoom,
    this.bearing,
    this.pitch,
  });

  /// Coordinate at the center of the camera.
  Map<String?, Object?>? center;

  /// Padding around the interior of the view that affects the frame of
  /// reference for `center`.
  MbxEdgeInsets? padding;

  /// Point of reference for `zoom` and `angle`, assuming an origin at the
  /// top-left corner of the view.
  ScreenCoordinate? anchor;

  /// Zero-based zoom level. Constrained to the minimum and maximum zoom
  /// levels.
  double? zoom;

  /// Bearing, measured in degrees from true north. Wrapped to [0, 360).
  double? bearing;

  /// Pitch toward the horizon measured in degrees.
  double? pitch;
}

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

class CoordinateBounds {
  CoordinateBounds({
    required this.southwest,
    required this.northeast,
    required this.infiniteBounds,
  });

  /// Coordinate at the southwest corner.
  /// Note: setting this field with invalid values (infinite, NaN) will crash the application.
  Map<String?, Object?> southwest;

  /// Coordinate at the northeast corner.
  /// Note: setting this field with invalid values (infinite, NaN) will crash the application.
  Map<String?, Object?> northeast;

  /// If set to `true`, an infinite (unconstrained) bounds covering the world coordinates would be used.
  /// Coordinates provided in `southwest` and `northeast` fields would be omitted and have no effect.
  bool infiniteBounds;
}

class CameraState {
  CameraState({
    required this.center,
    required this.padding,
    required this.zoom,
    required this.bearing,
    required this.pitch,
  });

  /// Coordinate at the center of the camera.
  Map<String?, Object?> center;

  /// Padding around the interior of the view that affects the frame of
  /// reference for `center`.
  MbxEdgeInsets padding;

  /// Zero-based zoom level. Constrained to the minimum and maximum zoom
  /// levels.
  double zoom;

  /// Bearing, measured in degrees from true north. Wrapped to [0, 360).
  double bearing;

  /// Pitch toward the horizon measured in degrees.
  double pitch;
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
abstract class _SnapshotterMessager {
  void cancel(String id);

  void destroy(String id);

  void setCamera(String id, CameraOptions cameraOptions);

  void setStyleUri(String id, String styleUri);

  void setStyleJson(String id, String styleJson);

  void setSize(String id, Size size);

  CameraOptions cameraForCoordinates(String id, List<Map<String?, Object?>?> coordinates,
      MbxEdgeInsets padding, double? bearing, double? pitch);

  CoordinateBounds coordinateBoundsForCamera(String id, CameraOptions camera);

  CameraState getCameraState(String id);

  Size getSize(String id);

  String getStyleJson(String id);

  String getStyleUri(String id);

  @async
  MbxImage? start(String id);
}

@FlutterApi()
abstract class OnSnapshotStyleListener {
  void onDidFinishLoadingStyle();

  void onDidFullyLoadStyle();

  void onDidFailLoadingStyle(String message);

  void onStyleImageMissing(String imageId);
}
