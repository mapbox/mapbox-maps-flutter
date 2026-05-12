import '../pigeons/platform_interface_data_types.dart';

/// Generic interface for reading and updating a map settings object of type [T].
abstract interface class SettingsInterface<T> {
  Future<T> getSettings();
  Future<void> updateSettings(T settings);
}

/// Interface for gesture configuration settings.
abstract interface class GesturesSettingsInterface
    implements SettingsInterface<GesturesSettings> {}

/// Interface for scale bar ornament settings.
abstract interface class ScaleBarSettingsInterface
    implements SettingsInterface<ScaleBarSettings> {}

/// Interface for compass ornament settings.
abstract interface class CompassSettingsInterface
    implements SettingsInterface<CompassSettings> {}

/// Interface for attribution ornament settings.
abstract interface class AttributionSettingsInterface
    implements SettingsInterface<AttributionSettings> {}

/// Interface for logo ornament settings.
abstract interface class LogoSettingsInterface
    implements SettingsInterface<LogoSettings> {}

/// Interface for indoor floor selector settings.
abstract interface class IndoorSelectorSettingsInterface
    implements SettingsInterface<IndoorSelectorSettings> {}
