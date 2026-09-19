import 'dart:async';
import 'dart:js_interop';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:web/web.dart';

import 'viewport_handler.dart';
import 'viewport_utils.dart';

import '../bindings/binding_adapters.dart';
import '../bindings/map_bindings.dart';

/// Follows the puck. The entry honors [ViewportTransition] (Fly/Easing/
/// Default) on the first position event; subsequent events drive
/// continuous tracking with `flyTo`'s distance-proportional duration.
final class FollowPuckHandler extends WebViewportStateHandler {
  final FollowPuckViewportState state;
  final Stream<GeolocationCoordinates> positions;

  StreamSubscription<GeolocationCoordinates>? _subscription;

  FollowPuckHandler(this.state, this.positions);

  @override
  Future<void> runApply(JSMap map, ViewportTransition? transition) {
    map.stop();

    final firstUpdate = Completer<void>();
    final padding = state.padding?.toJSPadding();

    _subscription = positions.listen((coords) async {
      final bearing = _bearingFor(coords);

      if (!firstUpdate.isCompleted) {
        // Pause so subsequent positions don't interrupt the transition mid-flight.
        _subscription?.pause();

        animateCamera(
          map,
          JSLngLat(coords.longitude, coords.latitude),
          state.zoom,
          bearing,
          state.pitch,
          padding,
          transition ?? const DefaultViewportTransition(),
        );
        await map.onceAsync('moveend').toDart;

        _subscription?.resume();
        firstUpdate.complete();
        return;
      }

      map.flyTo(
        JSCameraOptions(
          center: JSLngLat(coords.longitude, coords.latitude),
          zoom: state.zoom,
          bearing: bearing,
          pitch: state.pitch,
          padding: padding,
          essential: true,
        ),
      );
    });

    return firstUpdate.future;
  }

  @override
  void cancel() {
    _subscription?.cancel();
    _subscription = null;
    super.cancel();
  }

  double? _bearingFor(GeolocationCoordinates coords) {
    final bearing = state.bearing;
    if (bearing == null) return null;
    return switch (bearing) {
      FollowPuckViewportStateBearingConstant(:final bearing) => bearing,
      FollowPuckViewportStateBearingHeading() ||
      FollowPuckViewportStateBearingCourse() => coords.heading,
    };
  }
}
