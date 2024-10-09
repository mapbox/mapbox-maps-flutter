part of mapbox_maps_flutter;

class ImmediateViewportTransition implements ViewportTransition {
  ImmediateViewportTransition._();

  @override
  Cancelable run(ViewportState toState, Function(bool success) completion) {
    throw UnimplementedError();
  }
}
