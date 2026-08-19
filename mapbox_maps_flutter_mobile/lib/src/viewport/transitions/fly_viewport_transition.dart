part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

extension on FlyViewportTransition {
  _ViewportTransitionStorage _toStorage() {
    return _ViewportTransitionStorage(
      type: _ViewportTransitionType.fly,
      options: _FlyViewportTransitionOptions(
        durationMs: duration?.inMilliseconds,
      ),
    );
  }
}
