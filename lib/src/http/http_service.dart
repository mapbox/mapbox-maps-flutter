part of mapbox_maps_flutter;

/// Represents an HTTP request that can be intercepted and modified.
///
/// This class is passed to the [HttpRequestInterceptor] callback, allowing
/// you to inspect and modify the request before it is sent.
///
/// The following fields can be modified using [copyWith]:
/// - [url] - The request URL
/// - [headers] - The request headers
/// - [body] - The request body
///
/// Note: [method] is included for inspection but cannot be modified by the
/// native HTTP interceptor.
class HttpInterceptorRequest {
  /// The URL of the request. Can be modified.
  final String url;

  /// The HTTP method (e.g., "GET", "POST").
  /// Note: This field is read-only and cannot be modified by the interceptor.
  final String method;

  /// The headers of the request. Can be modified.
  final Map<String, String> headers;

  /// The request body, if any. Can be modified.
  final Uint8List? body;

  /// Creates a new [HttpInterceptorRequest].
  HttpInterceptorRequest({
    required this.url,
    required this.method,
    required this.headers,
    this.body,
  });

  /// Creates a copy of this request with the given fields replaced.
  HttpInterceptorRequest copyWith({
    String? url,
    String? method,
    Map<String, String>? headers,
    Uint8List? body,
  }) {
    return HttpInterceptorRequest(
      url: url ?? this.url,
      method: method ?? this.method,
      headers: headers ?? Map.from(this.headers),
      body: body ?? this.body,
    );
  }

  /// Converts this request to a map for serialization.
  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'method': method,
      'headers': headers,
      'body': body,
    };
  }

  /// Creates a request from a map.
  factory HttpInterceptorRequest.fromMap(Map<dynamic, dynamic> map) {
    return HttpInterceptorRequest(
      url: map['url'] as String,
      method: map['method'] as String,
      headers: Map<String, String>.from(map['headers'] ?? {}),
      body: map['body'] as Uint8List?,
    );
  }

  @override
  String toString() {
    return 'HttpInterceptorRequest(url: $url, method: $method, headers: $headers)';
  }
}

/// Represents an HTTP response that can be intercepted.
///
/// This class is passed to the [HttpResponseInterceptor] callback, allowing
/// you to inspect the response after it is received.
class HttpInterceptorResponse {
  /// The URL of the original request.
  final String url;

  /// The HTTP status code of the response.
  final int statusCode;

  /// The response headers.
  final Map<String, String> headers;

  /// The response body, if any.
  final Uint8List? data;

  /// The headers from the original request.
  /// Useful for correlating requests with responses using custom headers
  /// like `X-Request-Id`.
  final Map<String, String> requestHeaders;

  /// Creates a new [HttpInterceptorResponse].
  HttpInterceptorResponse({
    required this.url,
    required this.statusCode,
    required this.headers,
    this.data,
    this.requestHeaders = const {},
  });

  /// Creates a response from a map.
  factory HttpInterceptorResponse.fromMap(Map<dynamic, dynamic> map) {
    // statusCode might come as int or long depending on platform
    final statusCodeValue = map['statusCode'];
    final int statusCode;
    if (statusCodeValue is int) {
      statusCode = statusCodeValue;
    } else if (statusCodeValue is num) {
      statusCode = statusCodeValue.toInt();
    } else {
      statusCode = -1;
    }

    // data might come as Uint8List or List<int> depending on platform
    final dataValue = map['data'];
    final Uint8List? data;
    if (dataValue is Uint8List) {
      data = dataValue;
    } else if (dataValue is List) {
      data = Uint8List.fromList(dataValue.cast<int>());
    } else {
      data = null;
    }

    return HttpInterceptorResponse(
      url: map['url'] as String,
      statusCode: statusCode,
      headers: Map<String, String>.from(map['headers'] ?? {}),
      data: data,
      requestHeaders: Map<String, String>.from(map['requestHeaders'] ?? {}),
    );
  }

  @override
  String toString() {
    return 'HttpInterceptorResponse(url: $url, statusCode: $statusCode, headers: $headers)';
  }
}

/// Callback type for intercepting HTTP requests.
///
/// Return the modified [HttpInterceptorRequest] to use the modified request,
/// or return null to use the original request unchanged.
///
/// Example:
/// ```dart
/// Future<HttpInterceptorRequest?> onRequest(HttpInterceptorRequest request) async {
///   // Add authorization header only for specific domains
///   if (request.url.contains('my-tile-server.com')) {
///     return request.copyWith(
///       headers: {...request.headers, 'Authorization': 'Bearer token'},
///     );
///   }
///   return null; // Use original request for other domains
/// }
/// ```
typedef HttpRequestInterceptor = Future<HttpInterceptorRequest?> Function(
    HttpInterceptorRequest request);

/// Callback type for intercepting HTTP responses.
///
/// This callback is called after a response is received, allowing you to
/// inspect or log the response. Note that the response cannot be modified.
typedef HttpResponseInterceptor = Future<void> Function(
    HttpInterceptorResponse response);

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
