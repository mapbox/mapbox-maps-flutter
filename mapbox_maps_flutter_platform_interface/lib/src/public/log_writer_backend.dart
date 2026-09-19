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
