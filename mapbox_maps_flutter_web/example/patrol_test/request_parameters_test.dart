import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_web/src/http_headers_registry.dart';
import 'package:mapbox_maps_flutter_web/src/request_parameters.dart';

import 'patrol.dart';

// The request parameters are JS objects, so these tests run in the browser
// with the Patrol tests and not with the unit tests on the Dart VM.
void main() {
  late HttpHeadersRegistry registry;

  setUp(() => registry = HttpHeadersRegistry());

  patrolTest('adds the registered headers for the request host', ($) async {
    registry.setGlobalHeaders({'X-App': 'demo'});
    registry.setHeadersForHost('tiles.example.com', {'X-Key': '1'});

    final params = requestParametersFor(
      'https://tiles.example.com/1/2/3.png',
      registry,
    );

    expect(
      params.getProperty<JSString>('url'.toJS).toDart,
      'https://tiles.example.com/1/2/3.png',
    );
    expect(params.getProperty<JSAny?>('headers'.toJS).dartify(), {
      'X-App': 'demo',
      'X-Key': '1',
    });
  });

  patrolTest('omits the headers key when no headers apply', ($) async {
    registry.setHeadersForHost('tiles.example.com', {'X-Key': '1'});

    final params = requestParametersFor('https://other.example.com/', registry);

    expect(
      params.getProperty<JSString>('url'.toJS).toDart,
      'https://other.example.com/',
    );
    expect(params.hasProperty('headers'.toJS).toDart, isFalse);
  });

  patrolTest('returns a new headers object for each request', ($) async {
    registry.setHeadersForHost('tiles.example.com', {'X-Key': '1'});

    final first = requestParametersFor('https://tiles.example.com/', registry);
    first
        .getProperty<JSObject>('headers'.toJS)
        .setProperty('accept'.toJS, 'image/webp'.toJS);
    final second = requestParametersFor('https://tiles.example.com/', registry);

    expect(second.getProperty<JSAny?>('headers'.toJS).dartify(), {
      'X-Key': '1',
    });
  });
}
