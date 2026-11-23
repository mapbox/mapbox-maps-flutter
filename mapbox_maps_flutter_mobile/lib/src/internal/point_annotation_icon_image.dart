part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

/// Derives [PointAnnotationOptions.iconImage] / [PointAnnotation.iconImage]
/// from a hash of [PointAnnotationOptions.image] / [PointAnnotation.image],
/// when the caller has not set an explicit [iconImage].
///
/// Neither iOS nor Android compares image bytes. Both platforms re-apply an
/// icon only when its style-image id changes. A hash-based id makes
/// `update()` work without the caller managing ids: a content change
/// changes the hash. Callers who set [iconImage] themselves keep full
/// control of the style-image name.
///
/// [iconImage] is never null after the first hash is derived: both
/// `create()` and `getAnnotations()` return it. So deriving only when
/// [iconImage] is null would derive once, then never again. Every later
/// `update()` would treat the old hash as an explicit id, making a
/// bytes-only change a no-op again — the original #532 bug. Instead, this
/// method re-derives whenever the current [iconImage] is absent, or starts
/// with [_autoIconImagePrefix]. A prefixed id can only come from a previous
/// derivation, never from the caller, so it is safe to overwrite.
extension DerivePointAnnotationOptionsIconImage on PointAnnotationOptions {
  /// See [DerivePointAnnotationOptionsIconImage].
  void deriveIconImageIfNeeded() {
    final bytes = image;
    if (bytes != null && _shouldDeriveIconImage(iconImage)) {
      iconImage = _iconImageIdForBytes(bytes);
    }
  }
}

/// See [DerivePointAnnotationOptionsIconImage].
extension DerivePointAnnotationIconImage on PointAnnotation {
  /// See [DerivePointAnnotationOptionsIconImage].
  void deriveIconImageIfNeeded() {
    final bytes = image;
    if (bytes != null && _shouldDeriveIconImage(iconImage)) {
      iconImage = _iconImageIdForBytes(bytes);
    }
  }
}

const _autoIconImagePrefix = 'mbx_auto_icon_';

bool _shouldDeriveIconImage(String? currentIconImage) =>
    currentIconImage == null ||
    currentIconImage.startsWith(_autoIconImagePrefix);

String _iconImageIdForBytes(Uint8List bytes) =>
    '$_autoIconImagePrefix${_fnv1a64(bytes).toRadixString(16)}';

/// FNV-1a, 64-bit. Not cryptographic: chosen only to give distinct icon
/// bytes distinct ids cheaply (a single pass over already-in-memory bytes,
/// no image decoding), not to resist adversarial collisions.
int _fnv1a64(Uint8List bytes) {
  const prime = 0x100000001b3;
  const mask = 0xFFFFFFFFFFFFFFFF;
  var hash = 0xcbf29ce484222325;
  for (final byte in bytes) {
    hash = (hash ^ byte) & mask;
    hash = (hash * prime) & mask;
  }
  return hash;
}
