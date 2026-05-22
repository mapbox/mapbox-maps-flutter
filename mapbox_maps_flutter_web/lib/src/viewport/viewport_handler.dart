import 'dart:async';

import 'package:meta/meta.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import '../bindings/map_bindings.dart';

/// Contract for a web viewport state handler.
///
/// The base owns a [Completer] scoped to a single transition: [apply]
/// dispatches to [runApply] and forwards its result; [cancel] completes
/// with `false`. Whichever wins first sticks — later completions are
/// no-ops. Subclasses that need extra cleanup override [cancel] and call
/// `super.cancel()`.
abstract base class WebViewportStateHandler {
  Completer<bool>? _completer;

  @mustCallSuper
  Future<bool> apply(JSMap map, ViewportTransition? transition) {
    final completer = Completer<bool>();
    _completer = completer;
    runApply(
      map,
      transition,
    ).then((_) => _complete(true), onError: (_) => _complete(false));
    return completer.future;
  }

  @visibleForOverriding
  Future<void> runApply(JSMap map, ViewportTransition? transition);

  @mustCallSuper
  void cancel() {
    _complete(false);
  }

  void _complete(bool result) {
    final completer = _completer;
    _completer = null;
    if (completer != null && !completer.isCompleted) {
      completer.complete(result);
    }
  }
}
