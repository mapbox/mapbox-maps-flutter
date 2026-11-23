import 'dart:developer';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

/// Which controls panel the scene picker shows.
enum _Tab { settings, events }

class GesturesExample extends StatefulWidget {
  const GesturesExample({super.key});

  @override
  State<GesturesExample> createState() => _GesturesExampleState();
}

class _GesturesExampleState extends State<GesturesExample> {
  MapboxMap? _mapboxMap;

  final _cancelables = <Cancelable>[];

  final Map<int, bool> _toggleValues = {};

  static const _maxLogEntries = 200;
  final List<String> _eventLog = [];

  /// The most recent gesture. The HUD shows these while the user touches the
  /// map, which a panel on a phone cannot do.
  String? _lastGesture;
  String? _lastState;
  Point? _lastPoint;
  ScreenCoordinate? _lastTouch;
  int _gestureCount = 0;
  var _tab = _Tab.settings;

  late final List<_GestureToggle> _toggles = [
    _GestureToggle(
      label: 'Rotate',
      read: (s) => s.rotateEnabled,
      apply: (v) => GesturesSettings(rotateEnabled: v),
    ),
    _GestureToggle(
      label: 'Pinch to zoom',
      read: (s) => s.pinchToZoomEnabled,
      apply: (v) => GesturesSettings(pinchToZoomEnabled: v),
    ),
    _GestureToggle(
      label: 'Scroll',
      read: (s) => s.scrollEnabled,
      apply: (v) => GesturesSettings(scrollEnabled: v),
    ),
    _GestureToggle(
      label: 'Pitch',
      read: (s) => s.pitchEnabled,
      apply: (v) => GesturesSettings(pitchEnabled: v),
    ),
    _GestureToggle(
      label: 'Double-tap to zoom in',
      read: (s) => s.doubleTapToZoomInEnabled,
      apply: (v) => GesturesSettings(doubleTapToZoomInEnabled: v),
    ),
    _GestureToggle(
      label: 'Quick zoom',
      read: (s) => s.quickZoomEnabled,
      apply: (v) => GesturesSettings(quickZoomEnabled: v),
    ),
    if (!kIsWeb) ...[
      _GestureToggle(
        label: 'Double-touch to zoom out',
        read: (s) => s.doubleTouchToZoomOutEnabled,
        apply: (v) => GesturesSettings(doubleTouchToZoomOutEnabled: v),
      ),
      _GestureToggle(
        label: 'Pinch pan',
        read: (s) => s.pinchPanEnabled,
        apply: (v) => GesturesSettings(pinchPanEnabled: v),
      ),
    ],
    if ((!kIsWeb && defaultTargetPlatform == TargetPlatform.android)) ...[
      _GestureToggle(
        label: 'Pinch-zoom deceleration',
        read: (s) => s.pinchToZoomDecelerationEnabled,
        apply: (v) => GesturesSettings(pinchToZoomDecelerationEnabled: v),
      ),
      _GestureToggle(
        label: 'Inc. pinch-zoom threshold when rotating',
        read: (s) => s.increasePinchToZoomThresholdWhenRotating,
        apply: (v) =>
            GesturesSettings(increasePinchToZoomThresholdWhenRotating: v),
      ),
      _GestureToggle(
        label: 'Inc. rotate threshold when pinching to zoom',
        read: (s) => s.increaseRotateThresholdWhenPinchingToZoom,
        apply: (v) =>
            GesturesSettings(increaseRotateThresholdWhenPinchingToZoom: v),
      ),
    ],
    if (kIsWeb) ...[
      _GestureToggle(
        label: 'Scroll zoom',
        read: (s) => s.scrollZoomEnabled,
        apply: (v) => GesturesSettings(scrollZoomEnabled: v),
      ),
      _GestureToggle(
        label: 'Box zoom',
        read: (s) => s.boxZoomEnabled,
        apply: (v) => GesturesSettings(boxZoomEnabled: v),
      ),
      _GestureToggle(
        label: 'Pitch with rotate',
        read: (s) => s.pitchWithRotateEnabled,
        apply: (v) => GesturesSettings(pitchWithRotateEnabled: v),
      ),
    ],
  ];

  /// Taps go to the debug console rather than the in-app log, which the
  /// gesture streams below own.
  void _logTap(String label, MapContentGestureContext context) {
    log(
      "$label coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}"
      " point: {x: ${context.touchPosition.x}, y: ${context.touchPosition.y}}"
      " state: ${context.gestureState}",
    );
  }

  void _onKeyboard(MapKeyboardGestureContext context) {
    final camera = context.cameraState;
    _appendLog(
      'Keyboard: state=${context.gestureState.name} '
      'zoom=${camera.zoom.toStringAsFixed(2)} '
      'bearing=${camera.bearing.toStringAsFixed(1)} '
      'pitch=${camera.pitch.toStringAsFixed(1)}',
    );
  }

  void _logGesture(String label, MapContentGestureContext context) {
    if (mounted) {
      setState(() {
        _lastGesture = label;
        _lastState = context.gestureState.name;
        _lastPoint = context.point;
        _lastTouch = context.touchPosition;
        _gestureCount++;
      });
    }
    _appendLog(
      '$label: state=${context.gestureState.name} '
      'lng=${context.point.coordinates.lng.toStringAsFixed(5)} '
      'lat=${context.point.coordinates.lat.toStringAsFixed(5)} '
      'point=(${context.touchPosition.x.toStringAsFixed(0)}, '
      '${context.touchPosition.y.toStringAsFixed(0)})',
    );
  }

  void _appendLog(String entry) {
    if (!mounted) return;
    setState(() {
      _eventLog.add(entry);
      if (_eventLog.length > _maxLogEntries) {
        _eventLog.removeRange(0, _eventLog.length - _maxLogEntries);
      }
    });
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;

    mapboxMap.addInteraction(
      TapInteraction.onMap((context) => _logTap('OnTap', context)),
    );
    if (!kIsWeb) {
      mapboxMap.addInteraction(
        LongTapInteraction.onMap((context) => _logTap('OnLongTap', context)),
      );
    }
    final gestures = mapboxMap.gestures;
    _cancelables.addAll([
      gestures.pan.gestureEvents
          .listen((c) => _logGesture('Pan', c))
          .asCancelable(),
      gestures.zoom.gestureEvents
          .listen((c) => _logGesture('Zoom', c))
          .asCancelable(),
      gestures.rotate.gestureEvents
          .listen((c) => _logGesture('Rotate', c))
          .asCancelable(),
      gestures.pitch.gestureEvents
          .listen((c) => _logGesture('Pitch', c))
          .asCancelable(),
      gestures.keyboard.gestureEvents.listen(_onKeyboard).asCancelable(),
    ]);

    final settings = await mapboxMap.gestures.getSettings();
    if (!mounted) return;
    setState(() {
      for (var i = 0; i < _toggles.length; i++) {
        final value = _toggles[i].read(settings);
        if (value != null) _toggleValues[i] = value;
      }
    });
  }

  @override
  void dispose() {
    for (final cancelable in _cancelables) {
      cancelable.cancel();
    }
    super.dispose();
  }

  Widget _settingsPanel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < _toggles.length; i++)
          ControlSwitch(
            label: _toggles[i].label,
            value: _toggleValues[i] ?? false,
            // A missing value means the platform did not report this
            // setting, which leaves the switch disabled.
            onChanged: _toggleValues[i] == null
                ? null
                : (value) async {
                    setState(() => _toggleValues[i] = value);
                    await _mapboxMap?.gestures.updateSettings(
                      _toggles[i].apply(value),
                    );
                  },
          ),
      ],
    );
  }

  Widget _eventLogPanel() {
    if (_eventLog.isEmpty) {
      return const Text(
        'No gesture events yet — pan, zoom, rotate or pitch the map.',
        style: TextStyle(
          fontSize: 11,
          height: 1.4,
          color: MapboxGlass.labelFaint,
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Newest first, so the latest event is always in view.
        for (final entry in _eventLog.reversed.take(40))
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              entry,
              style: const TextStyle(
                fontSize: 11,
                color: MapboxGlass.labelMuted,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // The log scene gets the pinned strip on a narrow viewport, where a sheet
    // would cover the map the events come from. A wide viewport keeps it in
    // the side panel.
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final showsLogStrip = _tab == _Tab.events && !isWide;
    final point = _lastPoint;
    final touch = _lastTouch;

    return SceneScaffold(
      log: showsLogStrip ? _eventLog : null,
      logTitle: 'Gesture events',
      scenes: const [
        Scene(
          id: 'settings',
          title: 'Gesture settings',
          subtitle: 'Enable and disable each gesture',
          icon: Icons.tune,
        ),
        Scene(
          id: 'events',
          title: 'Gesture events',
          subtitle: 'Live log of what the map reports',
          icon: Icons.list_alt,
        ),
      ],
      selectedSceneId: _tab.name,
      onSceneSelected: (id) => setState(
        () => _tab = _Tab.values.firstWhere((tab) => tab.name == id),
      ),
      controlsTitle: _tab == _Tab.settings ? 'Gestures' : 'Gesture events',
      controlsSheetSize: ControlsSheetSize.large,
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey('mapWidget'),
            onMapCreated: _onMapCreated,
          ),
          MapHud(
            title: _lastGesture == null ? 'Touch the map' : 'Latest gesture',
            rows: [
              MapHudRow('gesture', _lastGesture ?? '—', emphasized: true),
              MapHudRow('state', _lastState ?? '—'),
              MapHudRow(
                'lng, lat',
                point == null
                    ? '—'
                    : '${point.coordinates.lng.toStringAsFixed(4)}, '
                          '${point.coordinates.lat.toStringAsFixed(4)}',
              ),
              MapHudRow(
                'screen x, y',
                touch == null
                    ? '—'
                    : '${touch.x.toStringAsFixed(0)}, '
                          '${touch.y.toStringAsFixed(0)}',
              ),
              MapHudRow('events', '$_gestureCount'),
            ],
          ),
        ],
      ),
      controlsBuilder: () => [
        if (_tab == _Tab.settings)
          _settingsPanel()
        else if (!showsLogStrip)
          _eventLogPanel(),
      ],
    );
  }
}

class _GestureToggle {
  const _GestureToggle({
    required this.label,
    required this.read,
    required this.apply,
  });

  final String label;
  final bool? Function(GesturesSettings settings) read;
  final GesturesSettings Function(bool value) apply;
}
