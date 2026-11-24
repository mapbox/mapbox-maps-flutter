import '../public/viewport/viewport_transition.dart';
import '../public/viewport/viewport_state.dart';

/// Returns true when a map widget update must apply [viewport].
///
/// A changed viewport always applies. A new transition or completion means
/// a new `ViewportController.moveTo`, which re-applies a viewport equal to
/// the old one, for example after a gesture made the viewport idle.
/// Rebuilds that pass the same values do not restart the move.
bool viewportNeedsUpdate({
  required ViewportState? viewport,
  required ViewportState? oldViewport,
  required ViewportTransition? transition,
  required ViewportTransition? oldTransition,
  required Object? completion,
  required Object? oldCompletion,
}) {
  if (viewport == null) return false;
  if (viewport != oldViewport) return true;
  return transition != null &&
      (transition != oldTransition || completion != oldCompletion);
}
