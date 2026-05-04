part of mapbox_maps_flutter_mobile;

/// A class that allows to configure Mapbox SDKs logging per application.
///
/// Facade callers reach this through
/// `MapboxMapsFlutterPlatform.instance.logConfiguration`
/// (via [LogConfigurationPlatformInterface]); the class also keeps a
/// mobile-internal static entry point used by [_setupDebugLoggingIfNeeded].
final class LogConfiguration implements LogConfigurationPlatformInterface {
  static bool _initialized = false;

  /// Instance used by `MapboxMapsFlutterMobile.logConfiguration` to
  /// satisfy [LogConfigurationPlatformInterface].
  static final LogConfiguration shared = LogConfiguration._();

  LogConfiguration._();

  /// Bridges [LogWriterBackend] (hand-written, lives in
  /// platform_interface) to Pigeon's mobile-internal
  /// `_LogWriterBackendApi`. Passing `null` unregisters.
  @override
  void registerLogWriterBackend(LogWriterBackend? backend) {
    _LogWriterBackendApi.setUp(
      backend == null ? null : _LogWriterBackendBridge(backend),
    );
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
      shared.registerLogWriterBackend(_DebugLoggingBackend());
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

final class _DebugLoggingBackend implements LogWriterBackend {
  @override
  void writeLog(LoggingLevel level, String message) {
    developer.log(
      message,
      level: level.asFlutterLoggingLevel.value,
      name: 'mapbox-maps-flutter',
    );
  }
}

/// Pigeon-side handler that forwards to a hand-written [LogWriterBackend].
/// Keeps the Pigeon FlutterApi class entirely internal to the mobile
/// package.
final class _LogWriterBackendBridge extends _LogWriterBackendApi {
  final LogWriterBackend _backend;

  _LogWriterBackendBridge(this._backend);

  @override
  void writeLog(LoggingLevel level, String message) {
    _backend.writeLog(level, message);
  }
}
