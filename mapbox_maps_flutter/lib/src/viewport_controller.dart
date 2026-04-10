import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// A controller for imperatively changing the map's viewport with animations.
///
/// Use [ViewportController] when you need to animate the camera to a new position
/// in response to user actions or other events. For static camera positioning,
/// use [MapWidget.viewport] instead.
///
/// The controller follows the same pattern as [TextEditingController] or [ScrollController]:
/// create it, pass it to [MapWidget.viewportController], call [moveTo] to animate,
/// and [dispose] when done.
///
/// ```dart
/// class _MyWidgetState extends State<MyWidget> {
///   final _viewportController = ViewportController();
///
///   void _flyToNewYork() {
///     _viewportController.moveTo(
///       CameraViewportState(
///         center: Point(coordinates: Position(-74.0, 40.7)),
///         zoom: 12,
///       ),
///       transition: FlyViewportTransition(duration: Duration(seconds: 2)),
///       completion: (finished) => print('Animation finished: $finished'),
///     );
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return MapWidget(
///       viewport: CameraViewportState(center: Point(coordinates: Position(0, 0))),
///       viewportController: _viewportController,
///     );
///   }
///
///   @override
///   void dispose() {
///     _viewportController.dispose();
///     super.dispose();
///   }
/// }
/// ```
class ViewportController extends ChangeNotifier {
  ViewportState? _state;
  ViewportTransition? _pendingTransition;
  void Function(bool)? _pendingCompletion;

  /// The current viewport state, or `null` if [moveTo] has not been called yet.
  ViewportState? get state => _state;

  /// Animates the map camera to the given [state].
  ///
  /// If a previous animation is still in progress, its [completion] callback
  /// is called with `false` before the new animation starts.
  ///
  /// [transition] controls the animation style. Defaults to [DefaultViewportTransition].
  /// Pass `null` to jump to the new state without animation.
  ///
  /// [completion] is called when the animation finishes. The boolean parameter
  /// is `true` if the animation completed normally, `false` if it was cancelled
  /// (e.g., by another [moveTo] call or user interaction).
  void moveTo(
    ViewportState state, {
    ViewportTransition? transition = const DefaultViewportTransition(),
    void Function(bool)? completion,
  }) {
    _pendingCompletion?.call(false);
    _state = state;
    _pendingTransition = transition;
    _pendingCompletion = completion;
    notifyListeners();
  }

  /// Consumes the pending transition, returning it and clearing the internal reference.
  ///
  /// This is called by [MapWidget] during build to extract the one-shot transition.
  @internal
  ViewportTransition? consumeTransition() {
    final t = _pendingTransition;
    _pendingTransition = null;
    return t;
  }

  /// Consumes the pending completion callback, returning a wrapped version
  /// that prevents double-invocation.
  ///
  /// This is called by [MapWidget] during build to extract the one-shot completion.
  @internal
  void Function(bool)? consumeCompletion() {
    final completion = _pendingCompletion;
    if (completion == null) return null;
    return (bool result) {
      // Clear only if this is still the active completion,
      // preventing a subsequent moveTo() from re-cancelling it.
      if (_pendingCompletion == completion) {
        _pendingCompletion = null;
      }
      completion(result);
    };
  }
}
