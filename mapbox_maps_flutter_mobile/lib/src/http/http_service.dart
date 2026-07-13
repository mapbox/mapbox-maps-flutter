part of mapbox_maps_flutter_mobile;

/// A service that handles HTTP-related functionality for Mapbox
class MapboxHttpService implements MapboxHttpServicePlatformInterface {
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

  @override
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

  /// Sets custom HTTP headers scoped to a specific [host].
  ///
  /// The headers are attached only to requests whose URL host matches [host]
  /// exactly (case-insensitive); there is no subdomain or substring matching.
  ///
  /// [host] is the target host, for example `"tiles.example.com"`.
  /// [headers] is a map of header names to header values. Passing an empty map
  /// removes any headers previously configured for [host].
  ///
  /// Calls for different hosts accumulate; calling again for the same host
  /// replaces that host's headers. This is a process-global setting that
  /// applies to all map instances.
  ///
  /// Throws a [PlatformException] if the native implementation is not available
  /// or if the operation fails.
  Future<void> setCustomHeadersForHost(
    String host,
    Map<String, String> headers,
  ) async {
    try {
      await _channel.invokeMethod('map#setCustomHeadersForHost', {
        'host': host,
        'headers': headers,
      });
    } on MissingPluginException catch (e) {
      throw PlatformException(
        code: 'MISSING_IMPLEMENTATION',
        message:
            'Native implementation for setCustomHeadersForHost is not available',
        details: e.toString(),
      );
    } catch (e) {
      throw PlatformException(
        code: 'SET_HEADERS_FAILED',
        message: 'Failed to set custom headers for host',
        details: e.toString(),
      );
    }
  }

  /// Removes all custom headers previously configured via [setCustomHeaders] or
  /// [setCustomHeadersForHost].
  ///
  /// Throws a [PlatformException] if the native implementation is not available
  /// or if the operation fails.
  Future<void> clearCustomHeaders() async {
    try {
      await _channel.invokeMethod('map#clearCustomHeaders');
    } on MissingPluginException catch (e) {
      throw PlatformException(
        code: 'MISSING_IMPLEMENTATION',
        message:
            'Native implementation for clearCustomHeaders is not available',
        details: e.toString(),
      );
    } catch (e) {
      throw PlatformException(
        code: 'CLEAR_HEADERS_FAILED',
        message: 'Failed to clear custom headers',
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
  @override
  Future<void> setMaxRequestsPerHost(int max) async {
    try {
      await _channel.invokeMethod('map#setMaxRequestsPerHost', {'max': max});
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
