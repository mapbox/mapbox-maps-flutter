part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

/// Process-wide HTTP settings on Android and iOS. No map is necessary.
final class _HttpServiceMobile implements MapboxHttpServicePlatformInterface {
  final _messenger = _HttpServiceMessenger();

  @override
  Future<void> setCustomHeaders(Map<String, String> headers) =>
      _messenger.setCustomHeaders(headers);

  @override
  Future<void> setCustomHeadersForHost(
    String host,
    Map<String, String> headers,
  ) => _messenger.setCustomHeadersForHost(host, headers);

  @override
  Future<void> clearCustomHeaders() => _messenger.clearCustomHeaders();

  @override
  Future<void> setMaxRequestsPerHost(int max) =>
      _messenger.setMaxRequestsPerHost(max);
}
