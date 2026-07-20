import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'example.dart';

const _carModelUri = 'asset://assets/sportcar.glb';

const _colorSwatches = [
  Colors.amber,
  Colors.deepPurple,
  Colors.cyan,
  Colors.redAccent,
];

enum _PuckStyle {
  defaultPuck('Default 2D'),
  customIcon('Custom 2D'),
  car('Custom 3D');

  const _PuckStyle(this.label);
  final String label;
}

class LocationExample extends StatefulWidget implements Example {
  const LocationExample({super.key});

  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'Location Component';
  @override
  final String? subtitle = null;

  @override
  State<StatefulWidget> createState() => LocationExampleState();
}

class LocationExampleState extends State<LocationExample> {
  MapboxMap? mapboxMap;
  ViewportState? _viewport;

  /// The single source of truth for every control below. Every mutation
  /// goes through [_apply], which re-reads the merged settings from the
  /// platform side right after writing, so the UI always reflects what's
  /// actually active - not just what was last requested.
  LocationComponentSettings? _settings;

  Uint8List? _customIcon;

  bool get _enabled => _settings?.enabled ?? false;
  bool get _pulsingEnabled => _settings?.pulsingEnabled ?? false;
  bool get _accuracyRingEnabled => _settings?.showAccuracyRing ?? false;
  bool get _bearingEnabled => _settings?.puckBearingEnabled ?? false;

  double get _modelScale {
    final scale = _settings?.locationPuck?.locationPuck3D?.modelScale;
    if (scale == null || scale.isEmpty) return 8.0;
    return scale.first ?? 8.0;
  }

  /// Tracked explicitly rather than read back from the platform: the map
  /// always starts on the default puck, and every other value is assigned
  /// by [_selectPuckStyle] itself, since it already knows which style it's
  /// requesting.
  _PuckStyle _puckStyle = _PuckStyle.defaultPuck;

  bool get _is3DPuckActive => _puckStyle == _PuckStyle.car;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/symbols/custom-icon.png').then((bytes) {
      _customIcon = bytes.buffer.asUint8List();
    });
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.location.getSettings().then((settings) {
      if (!mounted) return;
      setState(() => _settings = settings);
    });
  }

  /// Applies a partial [LocationComponentSettings] update, then re-reads the
  /// full settings back from the platform so [_settings] stays in sync with
  /// what's actually configured. Pass [style] when the caller already knows
  /// which puck style this update selects, so [_puckStyle] can be assigned
  /// directly.
  Future<void> _apply(LocationComponentSettings settings,
      {_PuckStyle? style}) async {
    final location = mapboxMap?.location;
    if (location == null) return;
    await location.updateSettings(settings);
    final updated = await location.getSettings();
    if (!mounted) return;
    setState(() {
      _settings = updated;
      if (style != null) _puckStyle = style;
    });
  }

  Future<void> _toggleLocation() async {
    final next = !_enabled;
    if (next) {
      await Geolocator.requestPermission();
    }
    await _apply(LocationComponentSettings(enabled: next));
    if (!mounted) return;
    setStateWithViewportAnimation(() {
      _viewport =
          next ? const FollowPuckViewportState() : const IdleViewportState();
    });
  }

  Future<void> _selectPuckStyle(_PuckStyle style) {
    switch (style) {
      case _PuckStyle.defaultPuck:
        return _apply(
          LocationComponentSettings(
            locationPuck: LocationPuck(locationPuck2D: DefaultLocationPuck2D()),
          ),
          style: style,
        );
      case _PuckStyle.customIcon:
        return _apply(
          LocationComponentSettings(
            locationPuck: LocationPuck(
              locationPuck2D: DefaultLocationPuck2D(topImage: _customIcon),
            ),
          ),
          style: style,
        );
      case _PuckStyle.car:
        return _apply(
          LocationComponentSettings(
            locationPuck: LocationPuck(
              locationPuck3D: LocationPuck3D(
                modelUri: _carModelUri,
                modelScale: [_modelScale, _modelScale, _modelScale],
              ),
            ),
          ),
          style: style,
        );
    }
  }

  Future<void> _setModelScale(double scale) {
    // A partial 3D update: modelUri is intentionally left out, so the
    // currently active model is kept and only its scale changes.
    return _apply(LocationComponentSettings(
      locationPuck: LocationPuck(
        locationPuck3D: LocationPuck3D(modelScale: [scale, scale, scale]),
      ),
    ));
  }

  Future<void> _setPulsing(bool value) =>
      _apply(LocationComponentSettings(pulsingEnabled: value));

  Future<void> _setAccuracyRing(bool value) =>
      _apply(LocationComponentSettings(showAccuracyRing: value));

  Future<void> _setBearing(bool value) =>
      _apply(LocationComponentSettings(puckBearingEnabled: value));

  Future<void> _setPulsingColor(Color color) =>
      _apply(LocationComponentSettings(pulsingColor: color.value));

  Future<void> _setAccuracyRingColor(Color color) =>
      _apply(LocationComponentSettings(accuracyRingColor: color.value));

  Widget _colorSwatchRow({
    required int? selectedColor,
    required ValueChanged<Color> onSelect,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          for (final color in _colorSwatches)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => onSelect(color),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: color,
                  child: selectedColor == color.value
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        key: const ValueKey('mapWidget'),
        onMapCreated: _onMapCreated,
        viewport: _viewport,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleLocation,
        icon: Icon(_enabled ? Icons.location_disabled : Icons.my_location),
        label: Text(_enabled ? 'Hide puck' : 'Show puck'),
      ),
      bottomNavigationBar: Card(
        margin: EdgeInsets.zero,
        elevation: 8,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedButton<_PuckStyle>(
                      segments: [
                        for (final style in _PuckStyle.values)
                          ButtonSegment(
                            value: style,
                            label: Text(style.label,
                                style: const TextStyle(fontSize: 12)),
                          ),
                      ],
                      selected: {
                        _puckStyle
                      },
                      onSelectionChanged: (selection) =>
                          _selectPuckStyle(selection.first)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.photo_size_select_small, size: 20),
                          Expanded(
                            child: Slider(
                              min: 1,
                              max: 20,
                              value: _modelScale.clamp(1.0, 20.0).toDouble(),
                              label: _modelScale.toStringAsFixed(1),
                              onChanged:
                                  _is3DPuckActive ? _setModelScale : null,
                            ),
                          ),
                        ],
                      ),
                      if (!_is3DPuckActive)
                        const Padding(
                          padding: EdgeInsets.only(left: 40),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '3D puck only',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SwitchListTile(
                  title: const Text('Pulsing'),
                  subtitle: _is3DPuckActive ? const Text('2D puck only') : null,
                  value: _pulsingEnabled,
                  onChanged: !_is3DPuckActive ? _setPulsing : null,
                ),
                if (_pulsingEnabled && !_is3DPuckActive)
                  _colorSwatchRow(
                    selectedColor: _settings?.pulsingColor,
                    onSelect: _setPulsingColor,
                  ),
                SwitchListTile(
                  title: const Text('Accuracy ring'),
                  subtitle: _is3DPuckActive ? const Text('2D puck only') : null,
                  value: _accuracyRingEnabled,
                  onChanged: !_is3DPuckActive ? _setAccuracyRing : null,
                ),
                if (_accuracyRingEnabled && !_is3DPuckActive)
                  _colorSwatchRow(
                    selectedColor: _settings?.accuracyRingColor,
                    onSelect: _setAccuracyRingColor,
                  ),
                SwitchListTile(
                  title: const Text('Bearing'),
                  value: _bearingEnabled,
                  onChanged: _setBearing,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
