import 'viewport_state.dart';
import 'viewport_transition.dart';

/// Abstract interface for performing viewport transitions.
///
/// Platform implementations must provide a concrete implementation of this
/// interface to handle viewport state changes with optional animated transitions.
abstract interface class ViewportPlatformInterface {
  /// Transitions the map camera to the given [state], optionally using a [transition] animation.
  ///
  /// Returns `true` if the transition completed successfully, `false` if it was
  /// interrupted or cancelled.
  Future<bool> transition(ViewportState state, ViewportTransition? transition);
}
