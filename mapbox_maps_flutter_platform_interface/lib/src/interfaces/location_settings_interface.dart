import '../pigeons/platform_interface_data_types.dart';
import 'settings_interfaces.dart';

/// Abstract interface for managing the user location indicator.
abstract interface class LocationSettingsPlatformInterface
    implements SettingsPlatformInterface<LocationComponentSettings> {
  /// Pushes an externally-sourced location into the native location-provider
  /// override, replacing whatever the platform's default location provider
  /// (GPS) would otherwise show. The override is registered on first call;
  /// until then the puck behaves exactly as it does today.
  ///
  /// [timestamp] defaults to now if omitted. [floor] is only meaningful on
  /// iOS, whose native `Location` type carries it; Android's
  /// `LocationConsumer` API has no floor concept, so it is dropped there.
  ///
  /// Throws [UnsupportedError] on platforms without a location-provider
  /// override (currently web).
  Future<void> setExternalLocation({
    required double latitude,
    required double longitude,
    double? accuracy,
    double? heading,
    double? headingAccuracy,
    int? floor,
    DateTime? timestamp,
  });

  /// Clears the override and restores the platform's default location
  /// provider (i.e. back to normal GPS).
  ///
  /// Throws [UnsupportedError] on platforms without a location-provider
  /// override (currently web).
  Future<void> clearExternalLocation();
}
