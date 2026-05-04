import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Global log-backend configuration for Mapbox SDKs.
///
/// Users subclass [LogWriterBackend] and pass an instance to
/// [registerLogWriterBackend]; passing `null` restores the default backend.
final class LogConfiguration {
  /// Registers [backend] as the backend that writes log messages.
  /// Passing `null` restores the default backend.
  static void registerLogWriterBackend(LogWriterBackend? backend) {
    MapboxMapsFlutterPlatform.instance.logConfiguration
        .registerLogWriterBackend(backend);
  }
}
