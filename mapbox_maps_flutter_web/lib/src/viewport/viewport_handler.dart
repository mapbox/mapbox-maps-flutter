import '../bindings/map_bindings.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Contract for a web viewport state handler.
///
/// Each implementation encapsulates the logic for applying a specific
/// [ViewportState] to a [JSMap]. Handlers are async — they await JS events
/// (e.g. moveend, style.load) and return `true` on success, `false` on failure.
///
/// Cancellation is handled by the orchestrator via a generation counter.
/// Handlers don't need to manage their own cancellation.
abstract interface class WebViewportStateHandler {
  Future<bool> apply(JSMap map, ViewportTransition? transition);
}
