import 'dart:js_interop';

// `JSON.parse` / `JSON.stringify` accessors deliberately kept in a library
// without a `@JS('mapboxgl')` prefix — the prefix on neighbouring binding
// files would resolve `JSON.parse` as `mapboxgl.JSON.parse`, which is
// undefined. dart2js's interop binds external names against the host
// library's `@JS(prefix)`, so these globals need their own home.

@JS('JSON.parse')
external JSAny jsonParse(String text);

@JS('JSON.stringify')
external String jsonStringify(JSAny? value);
