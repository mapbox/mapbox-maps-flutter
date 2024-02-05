part of mapbox_maps_flutter;

/// A class that allows to configure Mapbox SDKs logging per application.
final class LogConfiguration {
  /// Sets the backend which writes the log.
  ///
  /// Pass backend which writes logs as [backend], if you provide null for this parameter then previously
  /// used logger backend will be replaced with Mapbox default implementation.
  static void registerLogWriterBackend(LogWriterBackend? backend) {
    LogWriterBackend.setup(backend);
  }
}
