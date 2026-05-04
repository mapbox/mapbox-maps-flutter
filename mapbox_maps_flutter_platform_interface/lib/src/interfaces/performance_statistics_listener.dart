import '../pigeons/platform_interface_data_types.dart';

/// Performance-statistics callback — users subclass and pass an instance
/// to `MapboxMap.startPerformanceStatisticsCollection` to receive sampled
/// [PerformanceStatistics] snapshots.
abstract interface class PerformanceStatisticsListener {
  /// Invoked each time a sampling window completes with [statistics].
  void onPerformanceStatisticsCollected(PerformanceStatistics statistics);
}
