import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

/// Lights a 3D city with the style light API.
///
/// The sun study scene puts the directional light where the sun and the moon
/// really are, for any place, day and time. The light studio sets each
/// ambient and directional light property by hand.
class LightExample extends StatefulWidget {
  const LightExample({super.key});

  @override
  State<LightExample> createState() => _LightExampleState();
}

enum _Scene { sunStudy, studio }

const _scenes = [
  Scene(
    id: 'sunStudy',
    title: 'Sun study',
    subtitle: 'Real sun and moon light, any day',
    icon: Icons.wb_sunny_outlined,
  ),
  Scene(
    id: 'studio',
    title: 'Light studio',
    subtitle: 'Ambient and directional by hand',
    icon: Icons.tune,
  ),
];

/// A place with tall buildings, and the camera that frames it.
class _City {
  const _City({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.utcOffset,
    this.zoom = 15.5,
    this.bearing = 0,
  });

  final String name;
  final double latitude;
  final double longitude;

  /// Standard time offset from UTC, in hours. Daylight saving time is not
  /// applied.
  final int utcOffset;
  final double zoom;
  final double bearing;
}

const _cities = [
  _City(
    name: 'Manhattan',
    latitude: 40.7484,
    longitude: -73.9857,
    utcOffset: -5,
    bearing: 29,
  ),
  _City(
    name: 'Dubai',
    latitude: 25.1972,
    longitude: 55.2744,
    utcOffset: 4,
    zoom: 15,
  ),
  _City(name: 'Singapore', latitude: 1.2830, longitude: 103.8585, utcOffset: 8),
  _City(
    name: 'Helsinki',
    latitude: 60.1699,
    longitude: 24.9384,
    utcOffset: 2,
    zoom: 16,
  ),
  _City(
    name: 'Tromsø',
    latitude: 69.6496,
    longitude: 18.9560,
    utcOffset: 1,
    zoom: 16,
  ),
];

/// Days of the year of the equinoxes and solstices, in calendar order.
const _seasonDays = [79, 172, 265, 355];

/// Season names for [_seasonDays]. All [_cities] are in the northern
/// hemisphere.
const _seasons = ['Spring', 'Summer', 'Fall', 'Winter'];

enum _LightColor {
  white('White', Color(0xFFFFFFFF)),
  warm('Warm', Color(0xFFFFB46B)),
  cool('Cool', Color(0xFF9EC3FF)),
  neon('Neon', Color(0xFFFF4FD8));

  const _LightColor(this.label, this.color);

  final String label;
  final Color color;
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

class _LightExampleState extends State<LightExample> {
  static const _ambientId = 'ambient';
  static const _directionalId = 'directional';
  static const _terrainSourceId = 'terrain-dem';

  /// Simulated minutes per animation frame: a full day takes about 20 s.
  static const _playStep = 3;

  MapboxMap? _mapboxMap;
  var _styleLoaded = false;
  var _scene = _Scene.sunStudy;
  String? _error;

  // Sun study.
  final _year = DateTime.now().year;
  var _city = _cities.first;
  late int _dayOfYear;
  late int _minuteOfDay;
  var _natural = true;
  var _matchPreset = true;
  var _terrain = true;
  String? _preset;
  Timer? _player;
  late SolarDay _solarDay;
  late SkyPosition _sun;
  late MoonPosition _moon;
  late SkyLighting _lighting;

  // Light studio.
  var _ambientColor = _LightColor.white;
  var _ambientIntensity = 0.4;
  var _directionalColor = _LightColor.warm;
  var _directionalIntensity = 0.7;
  var _azimuth = 210.0;
  var _polar = 45.0;
  var _castShadows = true;
  var _shadowIntensity = 1.0;
  var _transitionMs = 600.0;

  // Light updates are queued so that fast slider drags and the animation
  // never stack calls. Only the latest pending update runs.
  Future<void> Function()? _pending;
  var _applying = false;

  late final CameraViewportState _initialViewport;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().toUtc().add(Duration(hours: _city.utcOffset));
    _dayOfYear = now.difference(DateTime.utc(now.year)).inDays + 1;
    _updateSolarDay();
    // Start 90 minutes before sunset, when the shadows are long and warm.
    final sunset = _solarDay.sunset;
    _minuteOfDay = sunset == null
        ? 12 * 60
        : (_localMinutes(sunset) - 90).clamp(0, Duration.minutesPerDay - 1);
    _updateSky();
    _initialViewport = CameraViewportState(
      center: Point(coordinates: Position(_city.longitude, _city.latitude)),
      zoom: _city.zoom,
      bearing: _city.bearing,
      pitch: 62,
    );
  }

  @override
  void dispose() {
    _player?.cancel();
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData _) async {
    _styleLoaded = true;
    // The Standard style resets its light preset on load.
    _preset = null;
    if (_terrain) unawaited(_setTerrain(true));
    _applyScene();
  }

  // ===== Terrain =====

  /// Adds or removes 3D terrain. Building shadows fall onto the slopes, but
  /// the terrain itself does not cast shadows.
  Future<void> _setTerrain(bool enabled) async {
    final map = _mapboxMap;
    if (map == null) return;
    if (enabled) {
      if (!await map.styleSourceExists(_terrainSourceId)) {
        await map.addStyleSource(
          _terrainSourceId,
          jsonEncode({
            'type': 'raster-dem',
            'url': 'mapbox://mapbox.mapbox-terrain-dem-v1',
            'tileSize': 514,
          }),
        );
      }
      await map.setStyleTerrain(jsonEncode({'source': _terrainSourceId}));
    } else if (await map.styleSourceExists(_terrainSourceId)) {
      await map.removeStyleTerrain();
      await map.removeStyleSource(_terrainSourceId);
    }
  }

  void _toggleTerrain(bool enabled) {
    setState(() => _terrain = enabled);
    if (_styleLoaded) unawaited(_setTerrain(enabled));
  }

  // ===== Update queue =====

  void _schedule(Future<void> Function() update) {
    if (!_styleLoaded) return;
    _pending = update;
    if (!_applying) _drain();
  }

  Future<void> _drain() async {
    _applying = true;
    while (_pending != null) {
      final update = _pending!;
      _pending = null;
      try {
        await update();
        if (_error != null && mounted) setState(() => _error = null);
      } catch (error) {
        if (mounted) setState(() => _error = '$error');
      }
    }
    _applying = false;
  }

  void _applyScene() => switch (_scene) {
    _Scene.sunStudy => _schedule(_applySunStudy),
    _Scene.studio => _schedule(_applyStudio),
  };

  void _selectScene(String id) {
    final scene = _Scene.values.byName(id);
    if (scene != _Scene.sunStudy) _pause();
    setState(() => _scene = scene);
    _applyScene();
  }

  // ===== Sun study =====

  /// Start of the local day, as a UTC instant.
  DateTime get _localMidnight => DateTime.utc(
    _year,
    1,
    _dayOfYear,
  ).subtract(Duration(hours: _city.utcOffset));

  DateTime get _instant => _localMidnight.add(Duration(minutes: _minuteOfDay));

  int get _daysInYear =>
      DateTime.utc(_year + 1).difference(DateTime.utc(_year)).inDays;

  int _localMinutes(DateTime instant) =>
      instant.difference(_localMidnight).inMinutes;

  void _updateSolarDay() {
    _solarDay = solarDay(_localMidnight, _city.latitude, _city.longitude);
  }

  void _updateSky() {
    _sun = sunPosition(_instant, _city.latitude, _city.longitude);
    _moon = moonPosition(_instant, _city.latitude, _city.longitude);
    _lighting = SkyLighting.from(sun: _sun, moon: _moon, natural: _natural);
  }

  void _setTime(int minuteOfDay) {
    setState(() {
      _minuteOfDay = minuteOfDay;
      _updateSky();
    });
    _schedule(_applySunStudy);
  }

  void _setDay(int dayOfYear) {
    setState(() {
      _dayOfYear = dayOfYear;
      _updateSolarDay();
      _updateSky();
    });
    _schedule(_applySunStudy);
  }

  Future<void> _setCity(_City city) async {
    setState(() {
      _city = city;
      _updateSolarDay();
      _updateSky();
    });
    _schedule(_applySunStudy);
    await _mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(city.longitude, city.latitude)),
        zoom: city.zoom,
        bearing: city.bearing,
        pitch: 62,
      ),
      MapAnimationOptions(duration: 2500),
    );
  }

  void _setNow() {
    final now = DateTime.now().toUtc().add(Duration(hours: _city.utcOffset));
    setState(() {
      _dayOfYear = now.difference(DateTime.utc(now.year)).inDays + 1;
      _minuteOfDay = now.hour * 60 + now.minute;
      _updateSolarDay();
      _updateSky();
    });
    _schedule(_applySunStudy);
  }

  void _togglePlay() {
    if (_player != null) {
      _pause();
      return;
    }
    setState(() {
      _player = Timer.periodic(const Duration(milliseconds: 40), (_) {
        _setTime((_minuteOfDay + _playStep) % Duration.minutesPerDay);
      });
    });
  }

  void _pause() {
    if (_player == null) return;
    _player!.cancel();
    setState(() => _player = null);
  }

  /// Matches the Standard light preset to the sky, so that windows and
  /// street lights turn on after dark.
  String _presetForSky() {
    if (_sun.elevation < -6) return 'night';
    if (_sun.elevation < 6) return _sun.azimuth < 180 ? 'dawn' : 'dusk';
    return 'day';
  }

  Future<void> _setPreset(String preset) async {
    if (preset == _preset) return;
    _preset = preset;
    await _mapboxMap?.setStyleImportConfigProperty(
      'basemap',
      'lightPreset',
      preset,
    );
  }

  Future<void> _applySunStudy() async {
    final map = _mapboxMap;
    if (map == null) return;
    final lighting = _lighting;
    // While the time changes every frame, a transition only adds lag.
    final instant = TransitionOptions(duration: 0, delay: 0);
    await map.setLights(
      AmbientLight(
        id: _ambientId,
        color: lighting.ambientColor.toARGB32(),
        colorTransition: instant,
        intensity: lighting.ambientIntensity,
        intensityTransition: instant,
      ),
      DirectionalLight(
        id: _directionalId,
        color: lighting.directionalColor.toARGB32(),
        colorTransition: instant,
        intensity: lighting.directionalIntensity,
        intensityTransition: instant,
        direction: lighting.direction,
        directionTransition: instant,
        castShadows: lighting.castShadows,
        shadowIntensity: lighting.shadowIntensity,
        shadowIntensityTransition: instant,
      ),
    );
    await _setPreset(_matchPreset ? _presetForSky() : 'day');
  }

  // ===== Light studio =====

  Future<void> _applyStudio() async {
    final map = _mapboxMap;
    if (map == null) return;
    final transition = TransitionOptions(
      duration: _transitionMs.round(),
      delay: 0,
    );
    await map.setLights(
      AmbientLight(
        id: _ambientId,
        color: _ambientColor.color.toARGB32(),
        colorTransition: transition,
        intensity: _ambientIntensity,
        intensityTransition: transition,
      ),
      DirectionalLight(
        id: _directionalId,
        color: _directionalColor.color.toARGB32(),
        colorTransition: transition,
        intensity: _directionalIntensity,
        intensityTransition: transition,
        direction: [_azimuth, _polar],
        directionTransition: transition,
        castShadows: _castShadows,
        shadowIntensity: _shadowIntensity,
        shadowIntensityTransition: transition,
      ),
    );
    await _setPreset('day');
  }

  /// Updates one studio value and applies the lights again.
  void _studio(VoidCallback change) {
    setState(change);
    _schedule(_applyStudio);
  }

  // ===== UI =====

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      scenes: _scenes,
      selectedSceneId: _scene.name,
      onSceneSelected: _selectScene,
      controlsTitle: 'Lights',
      controlsSheetSize: ControlsSheetSize.large,
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey('mapWidget'),
            styleUri: MapboxStyles.STANDARD,
            viewport: _initialViewport,
            onMapCreated: _onMapCreated,
            onStyleLoadedListener: _onStyleLoaded,
          ),
          _hud(),
        ],
      ),
      controlsBuilder: () => switch (_scene) {
        _Scene.sunStudy => _sunStudyControls(),
        _Scene.studio => _studioControls(),
      },
    );
  }

  Widget _hud() {
    final error = _error;
    final (title, rows) = switch (_scene) {
      _Scene.sunStudy => (
        '${_city.name} · ${_formatDay(_dayOfYear)}',
        _sunStudyHud(),
      ),
      _Scene.studio => (
        'Ambient + directional',
        [
          MapHudRow(
            'direction',
            '${_azimuth.round()}° / ${_polar.round()}°',
            emphasized: true,
          ),
          MapHudRow('shadows', _castShadows ? 'on' : 'off'),
          MapHudRow('transition', '${_transitionMs.round()} ms'),
        ],
      ),
    };
    return MapHud(
      title: title,
      width: 260,
      rows: [
        ...rows,
        if (error != null) MapHudRow('error', error, emphasized: true),
      ],
    );
  }

  List<MapHudRow> _sunStudyHud() {
    final shadow = _sun.shadowRatio;
    final sunrise = _solarDay.sunrise;
    final sunset = _solarDay.sunset;
    final sign = _city.utcOffset < 0 ? '−' : '+';
    return [
      MapHudRow(
        'local time',
        '${_formatMinutes(_minuteOfDay)} UTC$sign${_city.utcOffset.abs()}',
        emphasized: true,
      ),
      MapHudRow('sky', SkyPhase.of(_sun.elevation).label, emphasized: true),
      MapHudRow(
        'sun',
        '${_sun.elevation.toStringAsFixed(1)}° up · '
            '${_sun.azimuth.round()}° ${_compass(_sun.azimuth)}',
      ),
      MapHudRow(
        'shadow',
        shadow == null || shadow > 99
            ? '—'
            : '${shadow.toStringAsFixed(1)}× height',
      ),
      MapHudRow(
        'moon',
        '${_moon.elevation.toStringAsFixed(1)}° up · '
            '${(_moon.illumination * 100).round()}% lit',
      ),
      MapHudRow(
        'sunrise / sunset',
        sunrise == null && sunset == null
            ? (_sun.elevation > 0 ? 'midnight sun' : 'polar night')
            : '${_formatInstant(sunrise)} / ${_formatInstant(sunset)}',
      ),
      MapHudRow('solar noon', _formatInstant(_solarDay.solarNoon)),
      MapHudRow('light source', _lighting.source.label),
    ];
  }

  List<Widget> _sunStudyControls() => [
    ControlRow(
      label: 'Place',
      child: ControlChoices<_City>(
        options: {for (final city in _cities) city: city.name},
        value: _city,
        onChanged: _setCity,
        columns: 3,
      ),
    ),
    ControlSlider(
      label: 'Local time',
      value: _minuteOfDay.toDouble(),
      min: 0,
      max: Duration.minutesPerDay - 1,
      valueText: _formatMinutes(_minuteOfDay),
      onChanged: (value) => _setTime(value.round()),
    ),
    ControlSlider(
      label: 'Date',
      value: _dayOfYear.toDouble(),
      min: 1,
      max: _daysInYear.toDouble(),
      valueText: _formatDay(_dayOfYear),
      onChanged: (value) => _setDay(value.round()),
    ),
    ControlRow(
      label: 'Season',
      child: ControlChoices<int>(
        options: {for (final (i, day) in _seasonDays.indexed) day: _seasons[i]},
        value: _dayOfYear,
        columns: 4,
        onChanged: _setDay,
      ),
    ),
    ControlAction(
      label: _player == null ? 'Play the day' : 'Pause',
      icon: _player == null ? Icons.play_arrow : Icons.pause,
      onPressed: _togglePlay,
    ),
    ControlAction(label: 'Now', icon: Icons.schedule, onPressed: _setNow),
    ControlSwitch(
      label: 'Golden hour and moonlight colors',
      value: _natural,
      onChanged: (value) {
        setState(() {
          _natural = value;
          _updateSky();
        });
        _schedule(_applySunStudy);
      },
    ),
    ControlSwitch(
      label: 'Match basemap light preset',
      value: _matchPreset,
      onChanged: (value) {
        setState(() => _matchPreset = value);
        _schedule(_applySunStudy);
      },
    ),
    ControlSwitch(
      label: '3D terrain',
      value: _terrain,
      onChanged: _toggleTerrain,
    ),
    const _Note(
      'The directional light follows the real sun, or the moon after dark. '
      'Its direction is the azimuth of the body and its polar angle from '
      'overhead. The renderer limits shadows to 75° from overhead, so very '
      'low sun gives shorter shadows than the HUD shows. Terrain receives '
      'building shadows but does not cast its own. The season buttons pick '
      'the equinox or solstice day. Times use standard time without '
      'daylight saving.',
    ),
  ];

  List<Widget> _studioControls() => [
    ControlRow(
      label: 'Ambient color',
      child: ControlChoices<_LightColor>(
        options: {for (final c in _LightColor.values) c: c.label},
        value: _ambientColor,
        onChanged: (value) => _studio(() => _ambientColor = value),
        columns: 4,
      ),
    ),
    ControlSlider(
      label: 'Ambient intensity',
      value: _ambientIntensity,
      min: 0,
      max: 1,
      fractionDigits: 2,
      onChanged: (value) => _studio(() => _ambientIntensity = value),
    ),
    ControlRow(
      label: 'Directional color',
      child: ControlChoices<_LightColor>(
        options: {for (final c in _LightColor.values) c: c.label},
        value: _directionalColor,
        onChanged: (value) => _studio(() => _directionalColor = value),
        columns: 4,
      ),
    ),
    ControlSlider(
      label: 'Directional intensity',
      value: _directionalIntensity,
      min: 0,
      max: 1,
      fractionDigits: 2,
      onChanged: (value) => _studio(() => _directionalIntensity = value),
    ),
    ControlSlider(
      label: 'Azimuth',
      value: _azimuth,
      min: 0,
      max: 360,
      fractionDigits: 0,
      unit: '°',
      onChanged: (value) => _studio(() => _azimuth = value),
    ),
    const _Note(
      'Compass direction the light comes from: 0° north, 90° east, '
      '180° south, 270° west.',
      bottom: 10,
    ),
    ControlSlider(
      label: 'Polar angle',
      value: _polar,
      min: 0,
      max: 90,
      fractionDigits: 0,
      unit: '°',
      onChanged: (value) => _studio(() => _polar = value),
    ),
    const _Note(
      'Angle down from straight overhead: 0° is a light at the zenith with '
      'short shadows, 90° is a light at the horizon with long shadows.',
      bottom: 10,
    ),
    ControlSwitch(
      label: 'Cast shadows',
      value: _castShadows,
      onChanged: (value) => _studio(() => _castShadows = value),
    ),
    ControlSlider(
      label: 'Shadow intensity',
      value: _shadowIntensity,
      min: 0,
      max: 1,
      fractionDigits: 2,
      onChanged: (value) => _studio(() => _shadowIntensity = value),
    ),
    ControlSwitch(
      label: '3D terrain',
      value: _terrain,
      onChanged: _toggleTerrain,
    ),
    ControlSlider(
      label: 'Transition',
      value: _transitionMs,
      min: 0,
      max: 3000,
      fractionDigits: 0,
      unit: ' ms',
      onChanged: (value) => setState(() => _transitionMs = value),
    ),
    const _Note(
      'setLights replaces the ambient and directional lights together. Each '
      'property has a transition, so a color or direction change animates '
      'over the transition time. Select a color to see it.',
    ),
  ];

  String _formatMinutes(int minutes) =>
      '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
      '${(minutes % 60).toString().padLeft(2, '0')}';

  String _formatInstant(DateTime? instant) {
    if (instant == null) return '—';
    final minutes = _localMinutes(instant);
    return _formatMinutes(minutes % Duration.minutesPerDay);
  }

  String _formatDay(int dayOfYear) {
    final date = DateTime.utc(_year, 1, dayOfYear);
    return '${_months[date.month - 1]} ${date.day}';
  }

  String _compass(double azimuth) => const [
    'N',
    'NE',
    'E',
    'SE',
    'S',
    'SW',
    'W',
    'NW',
  ][((azimuth + 22.5) ~/ 45) % 8];
}

class _Note extends StatelessWidget {
  const _Note(this.text, {this.bottom = 0});

  final String text;

  /// Space below the note, to separate it from the next control.
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4, bottom: bottom),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          height: 1.35,
          color: MapboxGlass.labelFaint,
        ),
      ),
    );
  }
}

/// Phase of the day, from the sun elevation. Photographers plan shoots
/// around the golden and blue hours.
enum SkyPhase {
  night('Night'),
  astronomicalTwilight('Astronomical twilight'),
  nauticalTwilight('Nautical twilight'),
  blueHour('Blue hour'),
  goldenHour('Golden hour'),
  day('Day');

  const SkyPhase(this.label);

  final String label;

  static SkyPhase of(double sunElevation) => switch (sunElevation) {
    < -18 => night,
    < -12 => astronomicalTwilight,
    < -6 => nauticalTwilight,
    < -4 => blueHour,
    < 6 => goldenHour,
    _ => day,
  };
}

/// The style lights for one moment: what lights the scene, and how.
class SkyLighting {
  const SkyLighting({
    required this.source,
    required this.direction,
    required this.directionalColor,
    required this.directionalIntensity,
    required this.castShadows,
    required this.shadowIntensity,
    required this.ambientColor,
    required this.ambientIntensity,
  });

  /// The body that the directional light follows.
  final LightSource source;

  /// `[azimuth, polar]`, in the format of the `direction` light property.
  final List<double> direction;
  final Color directionalColor;
  final double directionalIntensity;
  final bool castShadows;
  final double shadowIntensity;
  final Color ambientColor;
  final double ambientIntensity;

  /// Calculates the lights for a sun and moon position.
  ///
  /// When [natural] is true, the colors follow the sky: white at noon, warm
  /// near the horizon, blue in twilight and cool moonlight at night. When
  /// false, the lights are white and only the direction changes.
  factory SkyLighting.from({
    required SkyPosition sun,
    required MoonPosition moon,
    required bool natural,
  }) {
    final e = sun.elevation;

    if (e > 0) {
      // Low sun goes through more atmosphere, so it is dimmer and warmer.
      final height = (e / 30).clamp(0.0, 1.0);
      final warmth = (e / 12).clamp(0.0, 1.0);
      return SkyLighting(
        source: LightSource.sun,
        direction: [sun.azimuth, sun.polar],
        directionalColor: natural
            ? Color.lerp(_sunsetOrange, _noonWhite, warmth)!
            : _noonWhite,
        directionalIntensity: lerpDouble(0.25, 0.8, height)!,
        castShadows: true,
        shadowIntensity: lerpDouble(0.6, 1, height)!,
        ambientColor: natural
            ? Color.lerp(_goldenAmbient, _dayAmbient, warmth)!
            : _noonWhite,
        ambientIntensity: lerpDouble(0.3, 0.45, height)!,
      );
    }

    // Between sunset and full night the sky fades from warm to deep blue.
    final dusk = (-e / 18).clamp(0.0, 1.0);
    final ambientColor = natural
        ? Color.lerp(_twilightAmbient, _nightAmbient, dusk)!
        : _noonWhite;
    // The night floor keeps the city readable when no moon is up.
    final ambientIntensity = lerpDouble(0.3, _nightAmbientIntensity, dusk)!;

    if (moon.elevation > 0) {
      // The lit fraction of the moon sets the strength of its light.
      return SkyLighting(
        source: LightSource.moon,
        direction: [moon.azimuth, moon.polar],
        directionalColor: natural ? _moonlight : _noonWhite,
        directionalIntensity: math.max(
          _nightGlowIntensity,
          0.03 + 0.2 * moon.illumination,
        ),
        castShadows: moon.illumination > 0.25,
        shadowIntensity: 0.5 * moon.illumination,
        ambientColor: ambientColor,
        ambientIntensity: ambientIntensity,
      );
    }

    // Without a moon, a faint glow from high above keeps walls and roofs
    // apart. Ambient light alone lights every face the same.
    return SkyLighting(
      source: LightSource.none,
      direction: [sun.azimuth, _nightGlowPolar],
      directionalColor: natural ? _moonlight : _noonWhite,
      directionalIntensity: _nightGlowIntensity,
      castShadows: false,
      shadowIntensity: 0,
      ambientColor: ambientColor,
      ambientIntensity: ambientIntensity,
    );
  }
}

/// The body that lights the scene.
enum LightSource {
  sun('Sun'),
  moon('Moon'),
  none('None');

  const LightSource(this.label);

  final String label;
}

const _noonWhite = Color(0xFFFFF6EA);
const _sunsetOrange = Color(0xFFFF7B2E);
const _dayAmbient = Color(0xFFDDE8FF);
const _goldenAmbient = Color(0xFFFFC9A0);
const _twilightAmbient = Color(0xFFB08AD8);
const _nightAmbient = Color(0xFF6A80C0);
const _nightAmbientIntensity = 0.25;
const _nightGlowIntensity = 0.12;
const _nightGlowPolar = 30.0;
const _moonlight = Color(0xFFB4C6FF);

/// The position of a body in the sky, as an observer on the ground sees it.
class SkyPosition {
  const SkyPosition({required this.azimuth, required this.elevation});

  /// Compass direction of the body, in degrees clockwise from north.
  final double azimuth;

  /// Angle of the body above the horizon, in degrees. Negative below it.
  final double elevation;

  /// The polar angle of a style light at this position: 0° is overhead and
  /// 90° is the horizon. A style light cannot go below the horizon.
  double get polar => (90 - elevation).clamp(0, 90).toDouble();

  /// Length of the shadow of an object, as a multiple of the object height.
  /// Null when the body is at or below the horizon.
  double? get shadowRatio =>
      elevation <= 0 ? null : 1 / math.tan(elevation * _toRadians);
}

/// The moon position and the lit fraction of its disc.
class MoonPosition extends SkyPosition {
  const MoonPosition({
    required super.azimuth,
    required super.elevation,
    required this.illumination,
  });

  /// Lit fraction of the disc, from 0 (new moon) to 1 (full moon).
  final double illumination;
}

/// Times of solar events on one day, as UTC instants. A value is null when
/// the event does not occur, for example sunrise during the polar night.
class SolarDay {
  const SolarDay({this.sunrise, this.sunset, required this.solarNoon});

  final DateTime? sunrise;
  final DateTime? sunset;

  /// The instant of the highest sun elevation.
  final DateTime solarNoon;
}

const _toRadians = math.pi / 180;
const _toDegrees = 180 / math.pi;

/// Sun elevation at sunrise and sunset. It includes atmospheric refraction
/// and the radius of the solar disc.
const _horizonElevation = -0.833;

/// Days since the J2000.0 epoch (2000-01-01 12:00 UTC).
double _daysSinceJ2000(DateTime time) =>
    time.toUtc().millisecondsSinceEpoch / Duration.millisecondsPerDay - 10957.5;

double _normalize(double degrees) => (degrees % 360 + 360) % 360;

/// Mean obliquity of the ecliptic, in degrees.
double _obliquity(double n) => 23.439 - 0.0000004 * n;

/// Converts ecliptic coordinates to a position in the local sky.
SkyPosition _toSky(
  double n,
  double eclipticLongitude,
  double eclipticLatitude,
  double latitude,
  double longitude,
) {
  final epsilon = _obliquity(n) * _toRadians;
  final lambda = eclipticLongitude * _toRadians;
  final beta = eclipticLatitude * _toRadians;

  final rightAscension = math.atan2(
    math.sin(lambda) * math.cos(epsilon) - math.tan(beta) * math.sin(epsilon),
    math.cos(lambda),
  );
  final declination = math.asin(
    math.sin(beta) * math.cos(epsilon) +
        math.cos(beta) * math.sin(epsilon) * math.sin(lambda),
  );

  final siderealTime = _normalize(280.46061837 + 360.98564736629 * n);
  final hourAngle = (siderealTime + longitude) * _toRadians - rightAscension;
  final phi = latitude * _toRadians;

  final elevation = math.asin(
    math.sin(phi) * math.sin(declination) +
        math.cos(phi) * math.cos(declination) * math.cos(hourAngle),
  );
  final azimuth = math.atan2(
    -math.sin(hourAngle) * math.cos(declination),
    math.sin(declination) * math.cos(phi) -
        math.cos(declination) * math.sin(phi) * math.cos(hourAngle),
  );

  return SkyPosition(
    azimuth: _normalize(azimuth * _toDegrees),
    elevation: elevation * _toDegrees,
  );
}

/// Ecliptic longitude of the sun, in degrees.
double _sunLongitude(double n) {
  final meanLongitude = 280.460 + 0.9856474 * n;
  final meanAnomaly = (357.528 + 0.9856003 * n) * _toRadians;
  return _normalize(
    meanLongitude +
        1.915 * math.sin(meanAnomaly) +
        0.020 * math.sin(2 * meanAnomaly),
  );
}

/// Sun position at [time] for an observer at [latitude], [longitude].
///
/// Uses the low-precision almanac formulas. The error is less than 0.1°
/// for the years 1950 to 2050.
SkyPosition sunPosition(DateTime time, double latitude, double longitude) {
  final n = _daysSinceJ2000(time);
  return _toSky(n, _sunLongitude(n), 0, latitude, longitude);
}

/// Moon position at [time] for an observer at [latitude], [longitude].
///
/// Uses the main periodic terms only. The error is approximately 1°, which
/// is sufficient for the direction of moonlight.
MoonPosition moonPosition(DateTime time, double latitude, double longitude) {
  final n = _daysSinceJ2000(time);
  final meanLongitude = 218.316 + 13.176396 * n;
  final meanAnomaly = (134.963 + 13.064993 * n) * _toRadians;
  final argumentOfLatitude = (93.272 + 13.229350 * n) * _toRadians;

  final longitudeOfMoon = _normalize(
    meanLongitude + 6.289 * math.sin(meanAnomaly),
  );
  final latitudeOfMoon = 5.128 * math.sin(argumentOfLatitude);

  final sky = _toSky(n, longitudeOfMoon, latitudeOfMoon, latitude, longitude);

  // The elongation is the angle between the sun and the moon, as seen from
  // the Earth. It sets the lit fraction of the disc.
  final elongation = math.acos(
    math.cos(latitudeOfMoon * _toRadians) *
        math.cos((longitudeOfMoon - _sunLongitude(n)) * _toRadians),
  );

  return MoonPosition(
    azimuth: sky.azimuth,
    elevation: sky.elevation,
    illumination: (1 - math.cos(elongation)) / 2,
  );
}

/// Sunrise, sunset and solar noon for the UTC day that starts at [dayStart].
///
/// Samples the sun each minute, so the times are accurate to one minute.
SolarDay solarDay(DateTime dayStart, double latitude, double longitude) {
  DateTime? sunrise;
  DateTime? sunset;
  var solarNoon = dayStart;
  var highest = -90.0;
  var previous = sunPosition(dayStart, latitude, longitude).elevation;

  for (var minute = 1; minute <= Duration.minutesPerDay; minute++) {
    final time = dayStart.add(Duration(minutes: minute));
    final elevation = sunPosition(time, latitude, longitude).elevation;
    if (previous < _horizonElevation && elevation >= _horizonElevation) {
      sunrise ??= time;
    } else if (previous >= _horizonElevation && elevation < _horizonElevation) {
      sunset ??= time;
    }
    if (elevation > highest) {
      highest = elevation;
      solarNoon = time;
    }
    previous = elevation;
  }

  return SolarDay(sunrise: sunrise, sunset: sunset, solarNoon: solarNoon);
}
