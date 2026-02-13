part of mapbox_maps_flutter;

/// Static controller for managing HTTP interceptors.
///
/// This controller communicates with the native HTTP interceptor channel
/// that is set up before any map is created, ensuring all HTTP requests
/// (including those made during map initialization) can be intercepted.
class _HttpInterceptorController {
  static final _HttpInterceptorController _instance =
      _HttpInterceptorController._internal();

  factory _HttpInterceptorController() => _instance;

  _HttpInterceptorController._internal() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static const MethodChannel _channel =
      MethodChannel('com.mapbox.maps.flutter/http_interceptor');

  HttpRequestInterceptor? _requestInterceptor;
  HttpResponseInterceptor? _responseInterceptor;

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'http#onRequest':
        if (_requestInterceptor != null) {
          final requestMap = call.arguments as Map<dynamic, dynamic>;
          final request = HttpInterceptorRequest.fromMap(requestMap);
          final modifiedRequest = await _requestInterceptor!(request);
          if (modifiedRequest != null) {
            return modifiedRequest.toMap();
          }
        }
        return null;
      case 'http#onResponse':
        if (_responseInterceptor != null) {
          try {
            final responseMap = call.arguments as Map<dynamic, dynamic>;
            final response = HttpInterceptorResponse.fromMap(responseMap);
            await _responseInterceptor!(response);
          } catch (e) {
            print('Error handling http#onResponse: $e');
            print('Arguments: ${call.arguments}');
          }
        }
        return null;
      default:
        throw MissingPluginException(
            'No handler for method ${call.method} on channel ${_channel.name}');
    }
  }

  /// Sets custom HTTP headers that will be applied to all Mapbox HTTP requests.
  ///
  /// These headers are applied statically to all requests before any
  /// request interceptor is called.
  Future<void> setCustomHeaders(Map<String, String> headers) async {
    await _channel.invokeMethod('setCustomHeaders', {'headers': headers});
  }

  /// Sets a callback to intercept HTTP requests before they are sent.
  ///
  /// The [interceptor] callback is called for each HTTP request made by Mapbox.
  /// You can modify the request by returning a new [HttpInterceptorRequest],
  /// or return null to use the original request unchanged.
  ///
  /// This should be called before creating any [MapWidget] to ensure all
  /// requests (including those made during map initialization) are intercepted.
  Future<void> setHttpRequestInterceptor(
      HttpRequestInterceptor? interceptor) async {
    _requestInterceptor = interceptor;
    await _updateInterceptorState();
  }

  /// Sets a callback to intercept HTTP responses after they are received.
  ///
  /// The [interceptor] callback is called for each HTTP response received by Mapbox.
  /// This is useful for logging, monitoring, or debugging HTTP traffic.
  ///
  /// Note: The response cannot be modified; this is for observation only.
  ///
  /// This should be called before creating any [MapWidget] to ensure all
  /// responses (including those from map initialization requests) are captured.
  Future<void> setHttpResponseInterceptor(
      HttpResponseInterceptor? interceptor) async {
    _responseInterceptor = interceptor;
    await _updateInterceptorState();
  }

  Future<void> _updateInterceptorState() async {
    final shouldEnable =
        _requestInterceptor != null || _responseInterceptor != null;
    final interceptRequests = _requestInterceptor != null;
    final interceptResponses = _responseInterceptor != null;

    await _channel.invokeMethod('setHttpInterceptorEnabled', {
      'enabled': shouldEnable,
      'interceptRequests': interceptRequests,
      'interceptResponses': interceptResponses,
    });
  }
}
