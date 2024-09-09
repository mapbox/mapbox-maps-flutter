part of mapbox_maps_flutter;

/// A class that allows to configure Mapbox SDKs logging per application.
final class LogConfiguration {
  // create an instance here to initialize debug logging once
  static LogConfiguration _instance = LogConfiguration._();

  LogConfiguration._() {
    if (kDebugMode) {
      LogConfiguration.registerLogWriterBackend(_DebugLoggingBackend());
    }
  }

  /// Sets the backend which writes the log.
  ///
  /// Pass backend which writes logs as [backend], if you provide null for this parameter then previously
  /// used logger backend will be replaced with Mapbox default implementation.
  static void registerLogWriterBackend(LogWriterBackend? backend) {
    LogWriterBackend.setUp(backend);
  }

  static void _setupDebugLoggingIfNeeded() {
    // access the instance so lazy loading gets triggered
    _instance;
  }
}

final class _DebugLoggingBackend extends LogWriterBackend {
  @override
  void writeLog(LoggingLevel level, String message) {
    print(message);
  }
}
