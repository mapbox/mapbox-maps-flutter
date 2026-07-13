import 'dart:typed_data';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';
import 'package:turf/turf.dart' show Point;

import 'annotation/circle_annotation_manager_web.dart';
import 'annotation/point_annotation_manager_web.dart';
import 'annotation/polygon_annotation_manager_web.dart';
import 'annotation/polyline_annotation_manager_web.dart';

/// Throwing stubs for every [MapboxMapPlatformInterface] sub-interface that
/// the web implementation does not yet back with Mapbox GL JS.
///
/// Error-class choice follows the WS2 handoff checklist:
///   * [UnsupportedError]   — by-design not on web (debug/replay tools,
///                            native-file-system offline).
///   * [UnimplementedError] — not-yet-implemented; GL JS has a plausible
///                            analogue waiting to be wired.
///
/// Settings sub-interfaces (gestures/scale bar/compass/attribution/logo/
/// indoor selector) are all [UnimplementedError] — GL JS exposes gesture
/// handlers and a few built-in controls (attribution, scale), but none are
/// wired into this package yet. The web-parity follow-up epic owns unstub.

UnimplementedError _unimplemented(String method, String owner) =>
    UnimplementedError('$owner.$method is not yet implemented on web.');

UnsupportedError _unsupported(String method, String reason) =>
    UnsupportedError('$method is not supported on web: $reason');

class UnsupportedScaleBarSettingsWeb
    implements ScaleBarSettingsPlatformInterface {
  @override
  Future<ScaleBarSettings> getSettings() =>
      throw _unimplemented('getSettings', 'ScaleBarSettings');
  @override
  Future<void> updateSettings(ScaleBarSettings settings) =>
      throw _unimplemented('updateSettings', 'ScaleBarSettings');
}

class UnsupportedCompassSettingsWeb
    implements CompassSettingsPlatformInterface {
  @override
  Future<CompassSettings> getSettings() =>
      throw _unimplemented('getSettings', 'CompassSettings');
  @override
  Future<void> updateSettings(CompassSettings settings) =>
      throw _unimplemented('updateSettings', 'CompassSettings');
}

class UnsupportedAttributionSettingsWeb
    implements AttributionSettingsPlatformInterface {
  @override
  Future<AttributionSettings> getSettings() =>
      throw _unimplemented('getSettings', 'AttributionSettings');
  @override
  Future<void> updateSettings(AttributionSettings settings) =>
      throw _unimplemented('updateSettings', 'AttributionSettings');
}

class UnsupportedLogoSettingsWeb implements LogoSettingsPlatformInterface {
  @override
  Future<LogoSettings> getSettings() =>
      throw _unimplemented('getSettings', 'LogoSettings');
  @override
  Future<void> updateSettings(LogoSettings settings) =>
      throw _unimplemented('updateSettings', 'LogoSettings');
}

class UnsupportedIndoorSelectorSettingsWeb
    implements IndoorSelectorSettingsPlatformInterface {
  @override
  Future<IndoorSelectorSettings> getSettings() =>
      throw _unimplemented('getSettings', 'IndoorSelectorSettings');
  @override
  Future<void> updateSettings(IndoorSelectorSettings settings) =>
      throw _unimplemented('updateSettings', 'IndoorSelectorSettings');
}

class UnsupportedAnnotationManagerWeb
    implements AnnotationManagerPlatformInterface {
  @override
  Future<PointAnnotationManagerPlatformInterface> createPointAnnotationManager({
    String? id,
    String? below,
  }) async => UnsupportedPointAnnotationManagerWeb(id ?? '');
  @override
  Future<CircleAnnotationManagerPlatformInterface>
  createCircleAnnotationManager({String? id, String? below}) async =>
      UnsupportedCircleAnnotationManagerWeb(id ?? '');
  @override
  Future<PolylineAnnotationManagerPlatformInterface>
  createPolylineAnnotationManager({String? id, String? below}) async =>
      UnsupportedPolylineAnnotationManagerWeb(id ?? '');
  @override
  Future<PolygonAnnotationManagerPlatformInterface>
  createPolygonAnnotationManager({String? id, String? below}) async =>
      UnsupportedPolygonAnnotationManagerWeb(id ?? '');
  @override
  Future<void> removeAnnotationManager(
    BaseAnnotationManagerPlatformInterface manager,
  ) => throw _unimplemented('removeAnnotationManager', 'AnnotationManager');
  @override
  Future<void> removeAnnotationManagerById(String id) =>
      throw _unimplemented('removeAnnotationManagerById', 'AnnotationManager');
}

class UnsupportedHttpServiceWeb implements MapboxHttpServicePlatformInterface {
  @override
  Future<void> setCustomHeaders(Map<String, String> headers) =>
      throw _unimplemented('setCustomHeaders', 'HttpService');

  @override
  Future<void> setCustomHeadersForHost(
    String host,
    Map<String, String> headers,
  ) => throw _unimplemented('setCustomHeadersForHost', 'HttpService');

  @override
  Future<void> clearCustomHeaders() =>
      throw _unimplemented('clearCustomHeaders', 'HttpService');

  @override
  Future<void> setMaxRequestsPerHost(int max) =>
      throw _unimplemented('setMaxRequestsPerHost', 'HttpService');
}

class UnsupportedProjectionWeb implements ProjectionPlatformInterface {
  @override
  Future<double> getMetersPerPixelAtLatitude(double latitude, double zoom) =>
      throw _unimplemented('getMetersPerPixelAtLatitude', 'Projection');
  @override
  Future<ProjectedMeters> projectedMetersForCoordinate(Point coordinate) =>
      throw _unimplemented('projectedMetersForCoordinate', 'Projection');
  @override
  Future<Point> coordinateForProjectedMeters(ProjectedMeters projectedMeters) =>
      throw _unimplemented('coordinateForProjectedMeters', 'Projection');
  @override
  Future<MercatorCoordinate> project(Point coordinate, double zoomScale) =>
      throw _unimplemented('project', 'Projection');
  @override
  Future<Point> unproject(MercatorCoordinate coordinate, double zoomScale) =>
      throw _unimplemented('unproject', 'Projection');
}

@experimental
class UnsupportedMapRecorderWeb implements MapRecorderPlatformInterface {
  static const _reason = 'debug/replay tool is native-only';
  @override
  Future<void> startRecording({
    int? timeWindow,
    required bool loggingEnabled,
    required bool compressed,
  }) => throw _unsupported('MapRecorder.startRecording', _reason);
  @override
  Future<Uint8List> stopRecording() =>
      throw _unsupported('MapRecorder.stopRecording', _reason);
  @override
  Future<void> replay(
    Uint8List recordedSequence, {
    required int playbackCount,
    required double playbackSpeedMultiplier,
    required bool avoidPlaybackPauses,
  }) => throw _unsupported('MapRecorder.replay', _reason);
  @override
  Future<void> togglePause() =>
      throw _unsupported('MapRecorder.togglePause', _reason);
  @override
  Future<String> getState() =>
      throw _unsupported('MapRecorder.getState', _reason);
}
