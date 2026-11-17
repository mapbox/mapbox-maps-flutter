import 'dart:js_interop';

import 'map_bindings.dart';

/// Options accepted by `Map#startPerformanceStatisticsCollection`.
@JS()
@anonymous
extension type JSPerformanceStatisticsOptions._(JSObject _)
    implements JSObject {
  external factory JSPerformanceStatisticsOptions({
    JSArray<JSString> samplers,
    double samplingDurationMillis,
  });
}

/// GL JS `DurationStatistics`.
extension type JSDurationStatistics._(JSObject _) implements JSObject {
  external double get maxMillis;
  external double get medianMillis;
}

/// GL JS `GroupPerformanceStatistics`.
extension type JSGroupPerformanceStatistics._(JSObject _) implements JSObject {
  external String get name;
  external double get durationMillis;
}

/// GL JS `CumulativeRenderingStatistics`.
extension type JSCumulativeRenderingStatistics._(JSObject _)
    implements JSObject {
  external int get drawCalls;
  external int get graphicsPrograms;
  external double get graphicsProgramsCreationTimeMillis;
  external int get fboSwitchCount;
}

/// GL JS `PerFrameRenderingStatistics`.
extension type JSPerFrameRenderingStatistics._(JSObject _) implements JSObject {
  external JSArray<JSGroupPerformanceStatistics> get topRenderGroups;
  external JSArray<JSGroupPerformanceStatistics> get topRenderLayers;
  external JSDurationStatistics get shadowMapDurationStatistics;
  external JSDurationStatistics get uploadDurationStatistics;
}

/// GL JS `PerformanceStatistics`.
extension type JSPerformanceStatistics._(JSObject _) implements JSObject {
  external double get collectionDurationMillis;
  external JSDurationStatistics get mapRenderDurationStatistics;
  external JSCumulativeRenderingStatistics? get cumulativeStatistics;
  external JSPerFrameRenderingStatistics? get perFrameStatistics;
}

/// Performance statistics JSMap externs.
extension MapPerformanceStatistics on JSMap {
  external void startPerformanceStatisticsCollection(
    JSPerformanceStatisticsOptions options,
    JSFunction callback,
  );

  external void stopPerformanceStatisticsCollection();
}
