import 'package:meta/meta.dart';

import 'pigeons/platform_interface_data_types.dart';

/// Additional information about a keyboard-driven map gesture.
///
/// Unlike [MapContentGestureContext], keyboard input has no associated
/// touch/cursor position, so this carries the camera state produced by the
/// gesture instead of a screen coordinate.
@immutable
final class MapKeyboardGestureContext {
  const MapKeyboardGestureContext({
    required this.cameraState,
    required this.gestureState,
  });

  /// The state of the camera at the time of the event.
  final CameraState cameraState;

  /// The state of the gesture.
  final GestureState gestureState;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapKeyboardGestureContext &&
        other.runtimeType == runtimeType &&
        other.cameraState == cameraState &&
        other.gestureState == gestureState;
  }

  @override
  int get hashCode => Object.hash(cameraState, gestureState);

  @override
  String toString() =>
      'MapKeyboardGestureContext(cameraState: $cameraState, gestureState: $gestureState)';
}
