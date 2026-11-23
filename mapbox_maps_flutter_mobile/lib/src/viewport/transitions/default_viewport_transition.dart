part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

extension on DefaultViewportTransition {
  _ViewportTransitionStorage _toStorage() => _ViewportTransitionStorage(
    type: _ViewportTransitionType.defaultTransition,
    options: _DefaultViewportTransitionOptions(
      maxDurationMs: maxDuration.inMilliseconds,
    ),
  );
}
