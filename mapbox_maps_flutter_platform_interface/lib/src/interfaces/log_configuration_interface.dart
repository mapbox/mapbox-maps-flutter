import '../pigeons/platform_interface_data_types.dart';

/// An interface for implementing log writing backends — e.g. for using
/// platform-specific log backends or logging to a notification service.
///
/// Users subclass [LogWriterBackend] and pass an instance to
/// [LogConfigurationPlatformInterface.registerLogWriterBackend] (or
/// `LogConfiguration.registerLogWriterBackend` on the facade).
abstract interface class LogWriterBackend {
  /// Invoked for each log message at [level] with its [message] text.
  void writeLog(LoggingLevel level, String message);
}

/// Global log-backend configuration for Mapbox SDKs.
///
/// Mirrors mobile's in-production single-method shape at
/// `packages/mapbox_maps_flutter_mobile/lib/src/log_configuration.dart`:
/// one entry point, nullable argument doubles as "restore default".
abstract interface class LogConfigurationPlatformInterface {
  /// Registers [backend] as the sink for log messages. Passing `null`
  /// restores the default backend.
  void registerLogWriterBackend(LogWriterBackend? backend);
}
