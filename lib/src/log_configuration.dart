part of mapbox_maps_flutter;

/// A class that allows to configure Mapbox SDKs logging per application.
final class LogConfiguration {
  static bool _initialized = false;

  LogConfiguration._() {}

  /// Sets the backend which writes the log.
  ///
  /// Pass backend which writes logs as [backend], if you provide null for this parameter then previously
  /// used logger backend will be replaced with Mapbox default implementation.
  static void registerLogWriterBackend(LogWriterBackend? backend) {
    LogWriterBackend.setUp(backend);
  }

  static void _setupDebugLoggingIfNeeded() {
    if (!kDebugMode) {
      return;
    }

    if (_initialized) {
      return;
    }
    _initialized = true;

    if (bool.fromEnvironment('MAPBOX_LOG_DEBUG', defaultValue: true)) {
      LogConfiguration.registerLogWriterBackend(_DebugLoggingBackend());
    }
  }
}

enum _FlutterLoggingLevel {
  debug(500),
  info(800),
  warning(900),
  error(1000);

  final int value;

  const _FlutterLoggingLevel(this.value);
}

extension on LoggingLevel {
  _FlutterLoggingLevel get asFlutterLoggingLevel {
    switch (this) {
      case LoggingLevel.debug:
        return _FlutterLoggingLevel.debug;
      case LoggingLevel.info:
        return _FlutterLoggingLevel.info;
      case LoggingLevel.warning:
        return _FlutterLoggingLevel.warning;
      case LoggingLevel.error:
        return _FlutterLoggingLevel.error;
    }
  }
}

final class _DebugLoggingBackend extends LogWriterBackend {
  @override
  void writeLog(LoggingLevel level, String message) {
    developer.log(message,
        level: level.asFlutterLoggingLevel.value, name: 'mapbox-maps-flutter');
  }
}
