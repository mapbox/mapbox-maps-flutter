import '../public/log_writer_backend.dart';

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
