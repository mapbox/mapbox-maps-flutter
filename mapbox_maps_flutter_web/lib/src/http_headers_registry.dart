/// Stores the custom HTTP headers that web map requests send.
///
/// The registry is process-wide: all maps read [instance]. It follows the
/// mobile SDKs. Host headers apply only when the request URL host is the same
/// as the host key, without case sensitivity. Host headers override global
/// headers with the same name.
final class HttpHeadersRegistry {
  /// The registry that the web maps read.
  static final HttpHeadersRegistry instance = HttpHeadersRegistry();

  Map<String, String> _globalHeaders = const {};

  // Keyed by the lowercase host.
  Map<String, Map<String, String>> _headersByHost = const {};

  /// Sets [headers] for all requests. Replaces the previous global headers.
  void setGlobalHeaders(Map<String, String> headers) {
    _globalHeaders = Map.unmodifiable(headers);
  }

  /// Sets [headers] for requests whose URL host is [host].
  ///
  /// An empty [headers] map removes the headers for [host].
  void setHeadersForHost(String host, Map<String, String> headers) {
    final key = host.toLowerCase();
    final headersByHost = {..._headersByHost};
    if (headers.isEmpty) {
      headersByHost.remove(key);
    } else {
      headersByHost[key] = Map.unmodifiable(headers);
    }
    _headersByHost = headersByHost;
  }

  /// Removes all global and host headers.
  void clear() {
    _globalHeaders = const {};
    _headersByHost = const {};
  }

  /// Returns the headers for a request to [url], or `null` if none apply.
  ///
  /// Returns a new map on each call, because the caller can change it.
  Map<String, String>? headersFor(String url) {
    final host = Uri.tryParse(url)?.host.toLowerCase();
    final hostHeaders = host == null ? null : _headersByHost[host];
    if (_globalHeaders.isEmpty && hostHeaders == null) {
      return null;
    }
    return {..._globalHeaders, ...?hostHeaders};
  }
}
