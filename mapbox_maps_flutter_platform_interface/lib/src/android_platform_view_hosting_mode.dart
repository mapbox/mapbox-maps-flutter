import 'package:meta/meta.dart';

/// A mode for platform MapView to be hosted in Flutter on Android.
///
/// As per https://github.com/flutter/flutter/blob/master/docs/platforms/android/Android-Platform-Views.md
// Constant names mirror the native Android hosting-mode names verbatim.
@experimental
enum AndroidPlatformViewHostingMode {
  /// Texture Layer Hybrid Composition with fallback to Virtual Display
  /// when the SDK version is < 23 or `MapWidget.textureView` is `false`.
  // ignore: constant_identifier_names
  TLHC_VD,

  /// Texture Layer Hybrid Composition with fallback to Hybrid Composition
  /// when the SDK version is < 23 or `MapWidget.textureView` is `false`.
  // ignore: constant_identifier_names
  TLHC_HC,

  /// Always use Hybrid Composition hosting mode.
  // ignore: constant_identifier_names
  HC,

  /// Always use Virtual Display hosting mode.
  // ignore: constant_identifier_names
  VD,
}
