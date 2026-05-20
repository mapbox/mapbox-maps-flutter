import '../pigeons/platform_interface_data_types.dart';

/// Generic interface for reading and updating a map settings object of type [T].
abstract interface class SettingsPlatformInterface<T> {
  Future<T> getSettings();
  Future<void> updateSettings(T settings);
}

/// Interface for gesture configuration and observability.
///
/// Gesture-event streams emit a [MapContentGestureContext] each time the
/// corresponding gesture transitions (started / changed / ended). Streams
/// are broadcast — multiple listeners may subscribe.
abstract interface class GesturesSettingsPlatformInterface
    implements SettingsPlatformInterface<GesturesSettings> {
  Stream<MapContentGestureContext> get panEvents;
  Stream<MapContentGestureContext> get zoomEvents;
  Stream<MapContentGestureContext> get rotateEvents;
  Stream<MapContentGestureContext> get pitchEvents;
}

/// Interface for scale bar ornament settings.
abstract interface class ScaleBarSettingsPlatformInterface
    implements SettingsPlatformInterface<ScaleBarSettings> {}

/// Interface for compass ornament settings.
abstract interface class CompassSettingsPlatformInterface
    implements SettingsPlatformInterface<CompassSettings> {}

/// Interface for attribution ornament settings.
abstract interface class AttributionSettingsPlatformInterface
    implements SettingsPlatformInterface<AttributionSettings> {}

/// Interface for logo ornament settings.
abstract interface class LogoSettingsPlatformInterface
    implements SettingsPlatformInterface<LogoSettings> {}

/// Interface for indoor floor selector settings.
abstract interface class IndoorSelectorSettingsPlatformInterface
    implements SettingsPlatformInterface<IndoorSelectorSettings> {}
