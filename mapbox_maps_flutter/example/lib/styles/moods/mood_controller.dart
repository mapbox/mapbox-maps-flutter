// ignore_for_file: experimental_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'lut_builder.dart';
import 'mood.dart';

/// Applies a [Mood] to a map and keeps it in sync with edits.
///
/// One mood uses every color API of the style: a runtime color theme LUT,
/// the atmosphere, snow or rain, lights and the Standard config.
class MoodController extends ChangeNotifier {
  static const _routeSourceId = 'moods-route-source';
  static const _routeLayerId = 'moods-route-layer';
  static const _terrainSourceId = 'moods-terrain-dem';
  static const _basemapImportId = 'basemap';

  /// LUT size while a slider moves. It builds fast.
  static const draftTiles = 16;

  /// LUT size when a slider stops. It grades smoothly.
  static const finalTiles = 32;

  static const _flightDuration = 4500;

  MapboxMap? _map;
  Timer? _lutDebounce;
  Timer? _pulse;
  Timer? _orbit;
  var _lutGeneration = 0;

  // Custom lights replace the lights of the Standard `lightPreset`. They are
  // set only after the user tunes a light, so presets keep the Standard look.
  var _customLights = false;
  var _active = false;

  /// The preset that filled the current mood, or `null` after an edit.
  MoodPreset? get preset => _preset;
  MoodPreset? _preset = moodPresets.first;

  Mood get mood => _mood;
  Mood _mood = moodPresets.first.mood;

  /// Keeps the sample route out of the color theme.
  bool get keepTrueColors => _keepTrueColors;
  var _keepTrueColors = true;

  /// The current LUT as PNG, or `null` before the first build.
  Uint8List? get lutPng => _lutPng;
  Uint8List? _lutPng;

  set map(MapboxMap? map) => _map = map;

  /// Starts the scene with the current preset.
  Future<void> enter() async {
    _active = true;
    await selectPreset(_preset ?? moodPresets.first);
  }

  /// Stops the scene and removes what it added to the style.
  ///
  /// Custom lights have no remove call, so they stay until a new style
  /// loads.
  Future<void> leave() async {
    _active = false;
    _stopMotion();
    _lutDebounce?.cancel();
    final map = _map;
    if (map == null) return;
    await map.setStyleColorTheme(null);
    await map.setStyleImportColorTheme(_basemapImportId, null);
    await map.setStyleAtmosphere(null);
    await map.setStyleSnow(null);
    await map.setStyleRain(null);
    await _setTerrain(map, enabled: false);
    if (await map.styleLayerExists(_routeLayerId)) {
      await map.removeStyleLayer(_routeLayerId);
    }
    if (await map.styleSourceExists(_routeSourceId)) {
      await map.removeStyleSource(_routeSourceId);
    }
  }

  /// Applies the mood again after a new style replaced it.
  Future<void> reapply() async {
    if (!_active) return;
    final preset = _preset;
    if (preset != null) await _addRoute(preset.camera);
    await _setTerrain(_map, enabled: preset?.camera.terrain ?? false);
    await _applyAll();
  }

  /// Flies to [preset] and morphs the map into its mood.
  Future<void> selectPreset(MoodPreset preset) async {
    _stopMotion();
    _preset = preset;
    _mood = preset.mood;
    notifyListeners();
    final map = _map;
    if (map == null || !_active) return;

    if (_customLights) {
      // Only a style load removes custom lights.
      _customLights = false;
      await map.setStyleURI(MapboxStyles.STANDARD);
    }

    final camera = preset.camera;
    await map.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(camera.longitude, camera.latitude)),
        zoom: camera.zoom,
        pitch: camera.pitch,
        bearing: camera.bearing,
      ),
      MapAnimationOptions(duration: _flightDuration),
    );
    await _setTerrain(map, enabled: camera.terrain);
    await _addRoute(camera);
    await _applyAll();
    // Turns the camera slowly around the center after the flight.
    _orbit = Timer(const Duration(milliseconds: _flightDuration), () {
      map.easeTo(
        CameraOptions(bearing: camera.bearing + 120),
        MapAnimationOptions(duration: 60000),
      );
    });
  }

  /// Replaces the mood with an edit from the Tune panel.
  ///
  /// Set [dragging] while a slider moves: the LUT then builds small and
  /// waits for a short pause. Call [settle] when the slider stops.
  void update(Mood mood, {bool dragging = false}) {
    final lutChanged = !identical(mood.lut, _mood.lut);
    _customLights |=
        mood.ambientColor != _mood.ambientColor ||
        mood.ambientIntensity != _mood.ambientIntensity;
    _mood = mood;
    _preset = null;
    notifyListeners();
    if (!_active) return;
    if (lutChanged) {
      _scheduleLut(dragging ? draftTiles : finalTiles);
    }
    _applyAtmosphere();
    _applyWeather();
    if (_customLights) _applyLights();
    _applyPulse();
  }

  /// Builds the full-size LUT after a slider stops.
  void settle() {
    if (_active) _scheduleLut(finalTiles);
  }

  Future<void> setKeepTrueColors(bool value) async {
    _keepTrueColors = value;
    notifyListeners();
    final map = _map;
    if (map == null || !await map.styleLayerExists(_routeLayerId)) return;
    await map.setStyleLayerProperty(
      _routeLayerId,
      'line-color-use-theme',
      _routeUseTheme.value,
    );
  }

  @override
  void dispose() {
    _stopMotion();
    _lutDebounce?.cancel();
    super.dispose();
  }

  ColorUseTheme get _routeUseTheme =>
      _keepTrueColors ? ColorUseTheme.none : ColorUseTheme.useDefault;

  void _stopMotion() {
    _pulse?.cancel();
    _pulse = null;
    _orbit?.cancel();
    _orbit = null;
  }

  Future<void> _applyAll() async {
    await _applyLut(finalTiles);
    await _applyAtmosphere();
    await _applyWeather();
    if (_customLights) await _applyLights();
    await _map?.setStyleImportConfigProperty(
      _basemapImportId,
      'lightPreset',
      _mood.lightPreset,
    );
    _applyPulse();
  }

  void _scheduleLut(int tiles) {
    _lutDebounce?.cancel();
    _lutDebounce = Timer(
      const Duration(milliseconds: 100),
      () => _applyLut(tiles),
    );
  }

  Future<void> _applyLut(int tiles) async {
    final generation = ++_lutGeneration;
    final png = await LutBuilder.build(_mood.lut, tiles);
    // A newer build started while this one ran.
    if (generation != _lutGeneration || !_active) return;
    _lutPng = png;
    notifyListeners();
    final theme = ColorTheme.base64(base64Encode(png));
    // The Standard import has its own color theme, which on Android and iOS
    // takes priority over the root theme for the basemap.
    await _map?.setStyleImportColorTheme(_basemapImportId, theme);
    await _map?.setStyleColorTheme(theme);
  }

  Future<void> _applyAtmosphere() async {
    final mood = _mood;
    await _map?.setStyleAtmosphere(
      Atmosphere(
        color: _argb(mood.fogColor),
        highColor: _argb(mood.highColor),
        spaceColor: _argb(mood.spaceColor),
        horizonBlend: mood.horizonBlend,
        starIntensity: mood.starIntensity,
        range: mood.fogRange,
      ),
    );
  }

  Future<void> _applyWeather() async {
    final map = _map;
    if (map == null) return;
    final mood = _mood;
    final color = _argb(mood.weatherColor);
    await map.setStyleSnow(
      mood.weather == Weather.snow
          ? Snow(
              intensity: mood.weatherIntensity,
              density: mood.weatherDensity,
              color: color,
              vignette: 0.3,
              vignetteColor: color,
            )
          : null,
    );
    await map.setStyleRain(
      mood.weather == Weather.rain
          ? Rain(
              intensity: mood.weatherIntensity,
              density: mood.weatherDensity,
              color: color,
              vignette: 0.4,
              vignetteColor: color,
            )
          : null,
    );
  }

  Future<void> _applyLights() async {
    final mood = _mood;
    final ambient = AmbientLight(id: 'moods-ambient')
      ..color = _argb(mood.ambientColor)
      ..intensity = mood.ambientIntensity;
    final directional = DirectionalLight(id: 'moods-directional')
      ..color = _argb(mood.directionalColor)
      ..intensity = mood.directionalIntensity
      ..direction = [200, 40]
      ..castShadows = true;
    await _map?.setLights(ambient, directional);
  }

  /// Moves the sky color around its tuned value, like an aurora.
  ///
  /// Each step is one style call, so the steps are far apart.
  void _applyPulse() {
    if (!_mood.pulse) {
      _pulse?.cancel();
      _pulse = null;
      return;
    }
    _pulse ??= Timer.periodic(const Duration(milliseconds: 200), (timer) {
      final base = _mood.highColor;
      final phase = timer.tick * 0.2 / 6 * 2 * math.pi;
      final color = base
          .withHue((base.hue + 25 * math.sin(phase)) % 360)
          .withValue((base.value * (0.85 + 0.15 * math.sin(phase * 1.7))));
      _map?.setStyleAtmosphereProperty('high-color', _argb(color).toRGBA());
    });
  }

  Future<void> _addRoute(MoodCamera camera) async {
    final map = _map;
    if (map == null) return;
    final data = _routeAround(camera);
    if (await map.styleSourceExists(_routeSourceId)) {
      await map.setStyleSourceProperty(_routeSourceId, 'data', data);
    } else {
      await map.addSource(GeoJsonSource(id: _routeSourceId, data: data));
    }
    if (!await map.styleLayerExists(_routeLayerId)) {
      await map.addLayer(
        LineLayer(
          id: _routeLayerId,
          sourceId: _routeSourceId,
          slot: 'top',
          lineJoin: LineJoin.ROUND,
          lineCap: LineCap.ROUND,
          lineColor: _routeColor,
          lineColorUseTheme: _routeUseTheme,
          lineWidth: 6,
          lineEmissiveStrength: 1,
        ),
      );
    }
  }

  Future<void> _setTerrain(MapboxMap? map, {required bool enabled}) async {
    if (map == null) return;
    final hasSource = await map.styleSourceExists(_terrainSourceId);
    if (enabled) {
      if (!hasSource) {
        await map.addStyleSource(
          _terrainSourceId,
          json.encode({
            'type': 'raster-dem',
            'url': 'mapbox://mapbox.mapbox-terrain-dem-v1',
            'tileSize': 514,
          }),
        );
      }
      await map.setStyleTerrain(
        json.encode({'source': _terrainSourceId, 'exaggeration': 1.3}),
      );
    } else if (hasSource) {
      await map.removeStyleTerrain();
      await map.removeStyleSource(_terrainSourceId);
    }
  }
}

/// A bright orange that shows clearly when the color theme changes it.
const _routeColor = 0xFFFF7A1A;

int _argb(HSVColor color) => color.toColor().toARGB32();

/// Returns a closed loop with a soft wave around the [camera] center.
String _routeAround(MoodCamera camera) {
  const points = 48;
  final latScale = math.cos(camera.latitude * math.pi / 180);
  // About 300 m at zoom 16, larger when the camera is farther away.
  final radius = 0.0027 * math.pow(2, 16 - camera.zoom);
  final coordinates = [
    for (var i = 0; i <= points; i++)
      () {
        final angle = i / points * 2 * math.pi;
        final r = radius * (1 + 0.18 * math.sin(angle * 3));
        return [
          camera.longitude + r * math.cos(angle) / latScale,
          camera.latitude + r * math.sin(angle),
        ];
      }(),
  ];
  return json.encode({
    'type': 'Feature',
    'properties': <String, Object>{},
    'geometry': {'type': 'LineString', 'coordinates': coordinates},
  });
}
