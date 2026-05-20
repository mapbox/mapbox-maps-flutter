import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Manages gesture configuration and observability for the map.
///
/// Exposes the four gestures common to iOS, Android, and Web —
/// [pan], [zoom], [rotate], [pitch] — each as a typed [MapGesture] that
/// publishes [MapContentGestureContext] events through its
/// `gestureEvents` broadcast stream.
final class GesturesSettingsManager {
  final GesturesSettingsPlatformInterface _impl;

  /// The pan (drag) gesture.
  final MapPanGesture pan;

  /// The zoom (pinch / wheel / double-tap) gesture.
  final MapZoomGesture zoom;

  /// The rotate gesture.
  final MapRotateGesture rotate;

  /// The pitch (tilt) gesture.
  final MapPitchGesture pitch;

  @internal
  GesturesSettingsManager(this._impl)
    : pan = MapPanGesture._(gestureEvents: _impl.panEvents),
      zoom = MapZoomGesture._(gestureEvents: _impl.zoomEvents),
      rotate = MapRotateGesture._(gestureEvents: _impl.rotateEvents),
      pitch = MapPitchGesture._(gestureEvents: _impl.pitchEvents);

  /// Returns the current [GesturesSettings].
  ///
  /// Supported [GesturesSettings] fields per platform:
  /// * Mobile (iOS / Android): all fields.
  /// * Web: [GesturesSettings.scrollEnabled],
  ///   [GesturesSettings.pinchToZoomEnabled],
  ///   [GesturesSettings.rotateEnabled], [GesturesSettings.pitchEnabled],
  ///   [GesturesSettings.doubleTapToZoomInEnabled]. Other fields return
  ///   null.
  Future<GesturesSettings> getSettings() => _impl.getSettings();

  /// Applies [GesturesSettings] configuration changes.
  ///
  /// Supported [GesturesSettings] fields per platform:
  /// * Mobile (iOS / Android): all fields.
  /// * Web: [GesturesSettings.scrollEnabled],
  ///   [GesturesSettings.pinchToZoomEnabled],
  ///   [GesturesSettings.rotateEnabled], [GesturesSettings.pitchEnabled],
  ///   [GesturesSettings.doubleTapToZoomInEnabled]. Other fields are
  ///   ignored.
  ///
  /// > **Note:** on Web, [GesturesSettings.scrollEnabled] = `false`
  /// > disables pointer/touch pan but keyboard arrow-pan stays on for
  /// > accessibility. A fine-grained keyboard pan toggle is pending
  /// > GL JS support ([GLJS-1828](https://mapbox.atlassian.net/browse/GLJS-1828)).
  Future<void> updateSettings(GesturesSettings settings) =>
      _impl.updateSettings(settings);
}

/// Deprecated: Use [GesturesSettingsManager] instead.
@Deprecated('Use GesturesSettingsManager instead.')
typedef GesturesSettingsInterface = GesturesSettingsManager;

/// Common base for gesture surfaces — currently [MapPanGesture],
/// [MapZoomGesture], [MapRotateGesture], [MapPitchGesture] — exposing
/// a broadcast `gestureEvents` stream of [MapContentGestureContext]s.
abstract base class MapGesture {
  /// Broadcast stream of gesture events for this surface.
  ///
  /// > **Note:** on Web, this stream currently covers pointer/touch input
  /// > only. Keyboard-driven camera changes (arrow keys, `+`/`-`,
  /// > shift+arrows) are not yet emitted here.
  final Stream<MapContentGestureContext> gestureEvents;

  MapGesture._({required this.gestureEvents});
}

/// The pan (drag) gesture surface on a [MapboxMap].
final class MapPanGesture extends MapGesture {
  MapPanGesture._({required super.gestureEvents}) : super._();
}

/// The zoom gesture surface on a [MapboxMap].
final class MapZoomGesture extends MapGesture {
  MapZoomGesture._({required super.gestureEvents}) : super._();
}

/// The rotate gesture surface on a [MapboxMap].
final class MapRotateGesture extends MapGesture {
  MapRotateGesture._({required super.gestureEvents}) : super._();
}

/// The pitch (tilt) gesture surface on a [MapboxMap].
final class MapPitchGesture extends MapGesture {
  MapPitchGesture._({required super.gestureEvents}) : super._();
}
