import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/painting.dart';

import 'lut_builder.dart';

/// Particles that fall over the map in a [Mood].
enum Weather { none, snow, rain }

/// A camera position that a [Mood] flies to.
@immutable
class MoodCamera {
  const MoodCamera({
    required this.longitude,
    required this.latitude,
    required this.zoom,
    required this.pitch,
    this.bearing = 0,
    this.terrain = false,
  });

  final double longitude;
  final double latitude;
  final double zoom;
  final double pitch;
  final double bearing;

  /// Shows 3D terrain at this place.
  final bool terrain;
}

/// One look of the map: a color grade, an atmosphere, weather and light.
///
/// A preset only fills these values. The Tune panel edits them live.
@immutable
class Mood {
  const Mood({
    required this.lut,
    required this.fogColor,
    required this.highColor,
    required this.spaceColor,
    required this.horizonBlend,
    required this.starIntensity,
    this.fogRange = const [0.8, 8],
    this.weather = Weather.none,
    this.weatherIntensity = 0,
    this.weatherDensity = 0,
    this.weatherColor = const HSVColor.fromAHSV(1, 0, 0, 1),
    required this.ambientColor,
    required this.ambientIntensity,
    required this.directionalColor,
    required this.directionalIntensity,
    required this.lightPreset,
    this.pulse = false,
  });

  final LutParams lut;

  final HSVColor fogColor;
  final HSVColor highColor;
  final HSVColor spaceColor;
  final double horizonBlend;
  final double starIntensity;

  /// Start and end distance of the fog, in kilometers.
  final List<double> fogRange;

  final Weather weather;
  final double weatherIntensity;
  final double weatherDensity;
  final HSVColor weatherColor;

  final HSVColor ambientColor;
  final double ambientIntensity;
  final HSVColor directionalColor;
  final double directionalIntensity;

  /// The `lightPreset` config of the Standard style.
  final String lightPreset;

  /// Slowly changes the sky color, like an aurora.
  final bool pulse;

  Mood copyWith({
    LutParams? lut,
    HSVColor? fogColor,
    HSVColor? highColor,
    HSVColor? spaceColor,
    double? horizonBlend,
    double? starIntensity,
    Weather? weather,
    double? weatherIntensity,
    double? weatherDensity,
    HSVColor? weatherColor,
    HSVColor? ambientColor,
    double? ambientIntensity,
    String? lightPreset,
    bool? pulse,
  }) => Mood(
    lut: lut ?? this.lut,
    fogColor: fogColor ?? this.fogColor,
    highColor: highColor ?? this.highColor,
    spaceColor: spaceColor ?? this.spaceColor,
    horizonBlend: horizonBlend ?? this.horizonBlend,
    starIntensity: starIntensity ?? this.starIntensity,
    fogRange: fogRange,
    weather: weather ?? this.weather,
    weatherIntensity: weatherIntensity ?? this.weatherIntensity,
    weatherDensity: weatherDensity ?? this.weatherDensity,
    weatherColor: weatherColor ?? this.weatherColor,
    ambientColor: ambientColor ?? this.ambientColor,
    ambientIntensity: ambientIntensity ?? this.ambientIntensity,
    directionalColor: directionalColor,
    directionalIntensity: directionalIntensity,
    lightPreset: lightPreset ?? this.lightPreset,
    pulse: pulse ?? this.pulse,
  );
}

/// A named [Mood] with the place that shows it best.
@immutable
class MoodPreset {
  const MoodPreset({
    required this.name,
    required this.camera,
    required this.mood,
  });

  final String name;
  final MoodCamera camera;
  final Mood mood;
}

HSVColor _hsv(double hue, double saturation, double value) =>
    HSVColor.fromAHSV(1, hue, saturation, value);

/// The presets of the Moods scene.
final moodPresets = [
  MoodPreset(
    name: 'Christmas',
    camera: const MoodCamera(
      longitude: 25.8090,
      latitude: 66.5436,
      zoom: 14.2,
      pitch: 70,
      bearing: -25,
      terrain: true,
    ),
    mood: Mood(
      lut: LutParams(
        temperature: -0.35,
        tint: -0.05,
        saturation: 0.85,
        contrast: 1.1,
        shadowColor: _hsv(215, 0.5, 1),
        highlightColor: _hsv(38, 0.3, 1),
      ),
      fogColor: _hsv(212, 0.1, 0.96),
      highColor: _hsv(218, 0.45, 0.6),
      spaceColor: _hsv(228, 0.75, 0.1),
      horizonBlend: 0.12,
      starIntensity: 0.6,
      fogRange: const [0.6, 7],
      weather: Weather.snow,
      weatherIntensity: 0.85,
      weatherDensity: 0.9,
      weatherColor: _hsv(210, 0.04, 1),
      ambientColor: _hsv(34, 0.55, 1),
      ambientIntensity: 0.2,
      directionalColor: _hsv(212, 0.2, 1),
      directionalIntensity: 0.12,
      lightPreset: 'night',
    ),
  ),
  MoodPreset(
    name: 'Mars',
    camera: const MoodCamera(
      longitude: -112.1129,
      latitude: 36.0980,
      zoom: 12.6,
      pitch: 75,
      bearing: 160,
      terrain: true,
    ),
    mood: Mood(
      lut: LutParams(
        temperature: 0.55,
        tint: 0.1,
        hueShift: -12,
        saturation: 1.3,
        contrast: 1.2,
        shadowColor: _hsv(12, 0.7, 1),
        highlightColor: _hsv(32, 0.45, 1),
      ),
      fogColor: _hsv(22, 0.55, 0.8),
      highColor: _hsv(30, 0.5, 0.75),
      spaceColor: _hsv(15, 0.6, 0.15),
      horizonBlend: 0.3,
      starIntensity: 0.2,
      fogRange: const [0.5, 6],
      ambientColor: _hsv(20, 0.6, 1),
      ambientIntensity: 0.4,
      directionalColor: _hsv(28, 0.7, 1),
      directionalIntensity: 0.6,
      lightPreset: 'dusk',
    ),
  ),
  MoodPreset(
    name: 'Cherry blossom',
    camera: const MoodCamera(
      longitude: 135.6720,
      latitude: 35.0130,
      zoom: 15.4,
      pitch: 62,
      bearing: 80,
      terrain: true,
    ),
    mood: Mood(
      lut: LutParams(
        temperature: 0.05,
        tint: 0.2,
        saturation: 1.1,
        contrast: 0.95,
        shadowColor: _hsv(280, 0.25, 1),
        highlightColor: _hsv(340, 0.35, 1),
      ),
      fogColor: _hsv(345, 0.12, 1),
      highColor: _hsv(210, 0.35, 0.95),
      spaceColor: _hsv(220, 0.4, 0.5),
      horizonBlend: 0.1,
      starIntensity: 0,
      fogRange: const [3, 14],
      weather: Weather.snow,
      weatherIntensity: 0.7,
      weatherDensity: 0.7,
      weatherColor: _hsv(335, 0.65, 1),
      ambientColor: _hsv(340, 0.2, 1),
      ambientIntensity: 0.5,
      directionalColor: _hsv(30, 0.25, 1),
      directionalIntensity: 0.5,
      lightPreset: 'day',
    ),
  ),
  MoodPreset(
    name: 'Northern lights',
    camera: const MoodCamera(
      longitude: 18.9553,
      latitude: 69.6492,
      zoom: 11.5,
      pitch: 80,
      bearing: 10,
      terrain: true,
    ),
    mood: Mood(
      lut: LutParams(
        temperature: -0.25,
        tint: -0.3,
        saturation: 1.15,
        contrast: 1.15,
        shadowColor: _hsv(265, 0.55, 1),
        highlightColor: _hsv(140, 0.4, 1),
      ),
      fogColor: _hsv(230, 0.4, 0.18),
      highColor: _hsv(145, 0.85, 0.75),
      spaceColor: _hsv(270, 0.75, 0.12),
      horizonBlend: 0.15,
      starIntensity: 1,
      weather: Weather.snow,
      weatherIntensity: 0.3,
      weatherDensity: 0.35,
      weatherColor: _hsv(200, 0.05, 1),
      ambientColor: _hsv(160, 0.4, 0.7),
      ambientIntensity: 0.12,
      directionalColor: _hsv(150, 0.5, 1),
      directionalIntensity: 0.08,
      lightPreset: 'night',
      pulse: true,
    ),
  ),
  MoodPreset(
    name: 'Neon rain',
    camera: const MoodCamera(
      longitude: 139.7006,
      latitude: 35.6595,
      zoom: 16.2,
      pitch: 65,
      bearing: -30,
    ),
    mood: Mood(
      lut: LutParams(
        tint: 0.4,
        hueShift: -15,
        saturation: 1.5,
        contrast: 1.25,
        shadowColor: _hsv(195, 0.7, 1),
        highlightColor: _hsv(315, 0.6, 1),
      ),
      fogColor: _hsv(320, 0.5, 0.3),
      highColor: _hsv(300, 0.6, 0.25),
      spaceColor: _hsv(250, 0.8, 0.06),
      horizonBlend: 0.08,
      starIntensity: 0,
      fogRange: const [0.6, 8],
      weather: Weather.rain,
      weatherIntensity: 0.95,
      weatherDensity: 1,
      weatherColor: _hsv(310, 0.45, 1),
      ambientColor: _hsv(310, 0.6, 1),
      ambientIntensity: 0.18,
      directionalColor: _hsv(190, 0.7, 1),
      directionalIntensity: 0.12,
      lightPreset: 'night',
    ),
  ),
];
