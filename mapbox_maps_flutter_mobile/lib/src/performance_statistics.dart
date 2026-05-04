part of mapbox_maps_flutter_mobile;

/// Pigeon-side handler that forwards to a hand-written
/// [PerformanceStatisticsListener]. Keeps the Pigeon FlutterApi class
/// entirely internal to the mobile package.
final class _PerformanceStatisticsListenerBridge
    extends _PerformanceStatisticsListenerApi {
  final PerformanceStatisticsListener _listener;

  _PerformanceStatisticsListenerBridge(this._listener);

  @override
  void onPerformanceStatisticsCollected(PerformanceStatistics statistics) {
    _listener.onPerformanceStatisticsCollected(statistics);
  }
}
