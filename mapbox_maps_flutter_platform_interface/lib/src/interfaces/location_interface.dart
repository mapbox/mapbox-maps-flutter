import '../pigeons/platform_interface_data_types.dart';

/// Abstract interface for managing the user location indicator.
abstract interface class LocationInterface {
  Future<LocationComponentSettings> getSettings();
  Future<void> updateSettings(LocationComponentSettings settings);
}
