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
  MapboxHttpService({
    required this.binaryMessenger,
    required this.channelSuffix,
  }) {
    _channel = MethodChannel(
      'plugins.flutter.io.${channelSuffix.toString()}',
      const StandardMethodCodec(),
      binaryMessenger,
    );
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

  /// Sets the maximum number of concurrent HTTP requests per host that the
  /// underlying HTTP service may issue.
  ///
  /// Lowering this value reduces the chance of hitting per-token rate limits
  /// when downloading large amounts of data (for example, offline tile
  /// regions), at the cost of slower throughput.
  ///
  /// This is a global setting that applies to all Mapbox HTTP requests across
  /// the process; calling it on any map instance updates it for all of them.
  ///
  /// [max] must be in the range 1..255.
  ///
  /// Throws a [PlatformException] if the native implementation is not available
  /// or if the operation fails.
  Future<void> setMaxRequestsPerHost(int max) async {
    try {
      await _channel
          .invokeMethod('map#setMaxRequestsPerHost', {'max': max});
    } on MissingPluginException catch (e) {
      throw PlatformException(
        code: 'MISSING_IMPLEMENTATION',
        message:
            'Native implementation for setMaxRequestsPerHost is not available',
        details: e.toString(),
      );
    } catch (e) {
      throw PlatformException(
        code: 'SET_MAX_REQUESTS_PER_HOST_FAILED',
        message: 'Failed to set max requests per host',
        details: e.toString(),
      );
    }
  }
}
