import 'package:meta/meta.dart';

/// A mode for platform MapView to be hosted in Flutter on Android.
///
/// As per https://github.com/flutter/flutter/blob/master/docs/platforms/android/Android-Platform-Views.md
@experimental
enum AndroidPlatformViewHostingMode {
  /// Texture Layer Hybrid Composition with fallback to Virtual Display
  /// when the SDK version is < 23 or `MapWidget.textureView` is `false`.
  TLHC_VD,

  /// Texture Layer Hybrid Composition with fallback to Hybrid Composition
  /// when the SDK version is < 23 or `MapWidget.textureView` is `false`.
  TLHC_HC,

  /// Always use Hybrid Composition hosting mode.
  HC,

  /// Always use Virtual Display hosting mode.
  VD,
}
