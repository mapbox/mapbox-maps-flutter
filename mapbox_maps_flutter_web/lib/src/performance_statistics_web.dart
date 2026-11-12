import 'dart:js_interop';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import 'bindings/performance_statistics_bindings.dart';

extension PerformanceStatisticsOptionsToJS on PerformanceStatisticsOptions {
  JSPerformanceStatisticsOptions toJS() => JSPerformanceStatisticsOptions(
    samplers: [
      for (final sampler in samplerOptions)
        switch (sampler) {
          PerformanceSamplerOptions.CUMULATIVE => 'cumulative'.toJS,
          PerformanceSamplerOptions.PER_FRAME => 'per-frame'.toJS,
        },
    ].toJS,
    samplingDurationMillis: samplingDurationMillis,
  );
}

extension JSPerformanceStatisticsToDart on JSPerformanceStatistics {
  /// GL JS does not track GPU memory, so the byte counters stay null.
  PerformanceStatistics toDart() {
    final cumulative = cumulativeStatistics;
    final perFrame = perFrameStatistics;
    return PerformanceStatistics(
      collectionDurationMillis: collectionDurationMillis,
      mapRenderDurationStatistics: mapRenderDurationStatistics.toDart(),
      cumulativeStatistics: cumulative == null
          ? null
          : CumulativeRenderingStatistics(
              drawCalls: cumulative.drawCalls,
              graphicsPrograms: cumulative.graphicsPrograms,
              graphicsProgramsCreationTimeMillis:
                  cumulative.graphicsProgramsCreationTimeMillis,
              fboSwitchCount: cumulative.fboSwitchCount,
            ),
      perFrameStatistics: perFrame == null
          ? null
          : PerFrameRenderingStatistics(
              topRenderGroups: perFrame.topRenderGroups.toDart
                  .map((group) => group.toDart())
                  .toList(),
              topRenderLayers: perFrame.topRenderLayers.toDart
                  .map((group) => group.toDart())
                  .toList(),
              shadowMapDurationStatistics: perFrame.shadowMapDurationStatistics
                  .toDart(),
              uploadDurationStatistics: perFrame.uploadDurationStatistics
                  .toDart(),
            ),
    );
  }
}

extension on JSDurationStatistics {
  DurationStatistics toDart() =>
      DurationStatistics(maxMillis: maxMillis, medianMillis: medianMillis);
}

extension on JSGroupPerformanceStatistics {
  GroupPerformanceStatistics toDart() =>
      GroupPerformanceStatistics(durationMillis: durationMillis, name: name);
}
