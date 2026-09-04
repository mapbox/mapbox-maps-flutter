import 'dart:typed_data';

/// An encoded raster image format recognized in `StyleImage.bytes` content.
///
/// Internal: used to pick a MIME type for encoded bytes handed to web APIs
/// (`Blob`). Not part of the public `StyleImage` API surface — native
/// platforms decode encoded bytes with their own image codec and never need
/// this.
enum StyleImageFormat {
  png('image/png'),
  jpeg('image/jpeg'),
  webp('image/webp');

  const StyleImageFormat(this.mimeType);

  /// The MIME type for this format.
  final String mimeType;

  /// Detects the encoded image format from its magic bytes.
  ///
  /// Throws [ArgumentError] if [bytes] does not start with a recognized
  /// PNG, JPEG, or WebP signature.
  factory StyleImageFormat.fromBytes(Uint8List bytes) {
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return StyleImageFormat.png;
    }

    if (bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
      return StyleImageFormat.jpeg;
    }

    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return StyleImageFormat.webp;
    }

    throw ArgumentError.value(
      bytes,
      'bytes',
      'Unrecognized image format (supported: PNG, JPEG, WebP)',
    );
  }
}
