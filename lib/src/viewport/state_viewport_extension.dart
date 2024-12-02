part of mapbox_maps_flutter;

ViewportTransition? _viewportTransition;
Function(bool)? _viewportTransitionCompletion;

extension WidgetViewportAnimation on State {
  /// Applies the animation to the map viewport.
  ///
  /// Use this function to apply animation to viewport state change.
  ///
  /// ```dart
  /// final _viewport = ...
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   TextButton(onPressed: () {
  ///     setStateWithViewportAnimation(() {
  ///     _viewport = CameraViewportState(...);
  //    });
  /// }
  /// ```
  ///
  /// See [ViewportState] and [ViewportTransition] documentation for more details.
  @experimental
  void setStateWithViewportAnimation(VoidCallback fn,
      {ViewportTransition? transition = const DefaultViewportTransition(),
      void Function(bool)? completion}) {
    _viewportTransition = transition;
    _viewportTransitionCompletion?.call(false);
    _viewportTransitionCompletion = completion;
    // ignore: invalid_use_of_protected_member
    setState(fn);
  }
}
