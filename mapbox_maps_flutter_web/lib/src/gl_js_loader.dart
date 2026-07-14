import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart';

import 'gl_js_version.dart';

const String _glJsUrl =
    'https://api.mapbox.com/mapbox-gl-js/v$mapboxGLJSVersion/mapbox-gl.js';
const String _glCssUrl =
    'https://api.mapbox.com/mapbox-gl-js/v$mapboxGLJSVersion/mapbox-gl.css';

final Completer<void> glJsReady = Completer();

Completer<void> _loadCompleter = Completer();
bool _isLoading = false;

/// Ensures Mapbox GL JS is loaded and ready to use, injecting the
/// `<script>`/`<link>` tags into `document.head` on first call. Safe to
/// call repeatedly — the underlying work only runs once.
///
/// If `mapboxgl` is already present on the global scope (e.g. the host app
/// still loads it manually, or this is a web hot-restart), it is reused
/// instead of injecting a second copy.
Future<void> ensureMapboxGlJsLoaded() {
  if (glJsReady.isCompleted) return glJsReady.future;
  if (_isLoading) return _loadCompleter.future;

  // Reuse an existing Mapbox GL JS if it's already on the global scope (the
  // host app loaded it via a manual <script> tag, or it lingers from a web
  // hot-restart) rather than injecting a second copy.
  if (globalContext.has('mapboxgl')) {
    _loadCompleter.complete();
    glJsReady.complete();
    return _loadCompleter.future;
  }

  _isLoading = true;
  final completer = _loadCompleter;

  unawaited(Future.wait([
    _loadResource(_glCssUrl, 'link'),
    _loadResource(_glJsUrl, 'script'),
  ], eagerError: true).then(
    (_) {
      _isLoading = false;
      completer.complete();
      glJsReady.complete();
    },
    onError: (Object err) {
      // Hand a fresh completer to the next caller so a later MapWidget can
      // retry, then fail this attempt's future so its awaiter sees the error
      // instead of hanging on the replacement completer.
      _isLoading = false;
      _loadCompleter = Completer();
      completer.completeError(err);
    },
  ));

  return completer.future;
}

Future<void> _loadResource(String url, String type) {
  final completer = Completer();
  final element = document.createElement(type);

  switch (type) {
    case 'link':
      (element as HTMLLinkElement)
        ..rel = 'stylesheet'
        ..href = url;
    case 'script':
      (element as HTMLScriptElement)
        ..src = url
        ..async = true;
    default:
      break;
  }

  element.addEventListener(
    'load',
    (JSAny _) {
      if (completer.isCompleted) return;
      completer.complete();
    }.toJS,
  );
  element.addEventListener(
    'error',
    (JSAny _) {
      completer.completeError(
        StateError(
          'Failed to load Mapbox $type from $url. This is '
          'usually caused by a Content-Security-Policy that blocks '
          'api.mapbox.com, or the device being offline.',
        ),
      );
    }.toJS,
  );
  document.head!.appendChild(element);

  return completer.future;
}
