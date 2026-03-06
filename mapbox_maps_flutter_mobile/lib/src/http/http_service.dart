part of mapbox_maps_flutter;

/// A service that handles HTTP-related functionality for Mapbox
class MapboxHttpService {
  late final MethodChannel _channel;
  final BinaryMessenger binaryMessenger;
  final int channelSuffix;

  /// Creates a new MapboxHttpService instance
  ///
  /// [binaryMessenger] is used for platform channel communication
  /// [channelSuffix] is used to create a unique channel identifier when multiple instances
  /// of the service are needed. This should match the suffix used on the platform side.
  MapboxHttpService(
      {required this.binaryMessenger, required this.channelSuffix}) {
    _channel = MethodChannel('plugins.flutter.io.${channelSuffix.toString()}',
        const StandardMethodCodec(), binaryMessenger);
  }

  /// Sets custom headers for all Mapbox HTTP requests
  ///
  /// [headers] is a map of header names to header values
  ///
  /// Throws a [PlatformException] if the native implementation is not available
  /// or if the operation fails
  Future<void> setCustomHeaders(Map<String, String> headers) async {
    try {
      await _channel.invokeMethod('map#setCustomHeaders', {'headers': headers});
    } on MissingPluginException catch (e) {
      throw PlatformException(
        code: 'MISSING_IMPLEMENTATION',
        message: 'Native implementation for setCustomHeaders is not available',
        details: e.toString(),
      );
    } catch (e) {
      throw PlatformException(
        code: 'SET_HEADERS_FAILED',
        message: 'Failed to set custom headers',
        details: e.toString(),
      );
    }
  }
}
