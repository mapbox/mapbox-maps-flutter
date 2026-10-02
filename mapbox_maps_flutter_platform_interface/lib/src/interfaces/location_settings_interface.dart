import '../pigeons/platform_interface_data_types.dart';
import 'settings_interfaces.dart';

/// Abstract interface for managing the user location indicator.
abstract interface class LocationSettingsPlatformInterface
    implements SettingsPlatformInterface<LocationComponentSettings> {
  /// Pushes an externally-sourced location into the native location-provider
  /// override, replacing whatever the default location provider (GPS) would
  /// otherwise show.
  ///
  /// Amuse fork addition (not in upstream `mapbox_maps_flutter`). Supported on
  /// Android and iOS only; web throws [UnsupportedError].
  Future<void> setExternalLocation({
    required double latitude,
    required double longitude,
    double? accuracy,
    double? heading,
    double? headingAccuracy,
    int? floor,
    DateTime? timestamp,
  });

  /// Clears the override and restores the default location provider.
  ///
  /// Amuse fork addition. A no-op on web, where no override can be active.
  Future<void> clearExternalLocation();
}
