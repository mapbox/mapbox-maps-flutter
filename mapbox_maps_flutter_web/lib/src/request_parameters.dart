import 'dart:js_interop';

import 'bindings/map_bindings.dart';
import 'http_headers_registry.dart';

/// Returns the GL JS request parameters for [url] with the headers from
/// [registry].
JSRequestParameters requestParametersFor(
  String url,
  HttpHeadersRegistry registry,
) {
  final headers = registry.headersFor(url);
  // GL JS passes `headers` to `fetch`, which rejects `null`, so omit the key.
  return headers == null
      ? JSRequestParameters(url: url)
      : JSRequestParameters(url: url, headers: headers.jsify());
}
