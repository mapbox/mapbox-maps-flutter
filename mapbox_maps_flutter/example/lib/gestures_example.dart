import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'platform.dart' show isAndroid, isMobile;

class GesturesExample extends StatefulWidget {
  const GesturesExample({super.key});

  @override
  State<StatefulWidget> createState() => GesturesExampleState();
}

class GesturesExampleState extends State<GesturesExample> {
  GesturesExampleState();

  final colors = [Colors.amber, Colors.black, Colors.blue];

  MapboxMap? mapboxMap;

  final _cancelables = <Cancelable>[];

  final Map<int, bool> _toggleValues = {};

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
    if (isMobile) ...[
      _GestureToggle(
        label: 'Double-touch to zoom out',
        read: (s) => s.doubleTouchToZoomOutEnabled,
        apply: (v) => GesturesSettings(doubleTouchToZoomOutEnabled: v),
      ),
      _GestureToggle(
        label: 'Quick zoom',
        read: (s) => s.quickZoomEnabled,
        apply: (v) => GesturesSettings(quickZoomEnabled: v),
      ),
      _GestureToggle(
        label: 'Pinch pan',
        read: (s) => s.pinchPanEnabled,
        apply: (v) => GesturesSettings(pinchPanEnabled: v),
      ),
    ],
    if (isAndroid) ...[
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
  ];

  void _onTap(MapContentGestureContext context) {
    log(
      "OnTap coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}"
      " point: {x: ${context.touchPosition.x}, y: ${context.touchPosition.y}}"
      " state: ${context.gestureState}",
    );
  }

  void _onLongTap(MapContentGestureContext context) {
    log(
      "OnLongTap coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}"
      " point: {x: ${context.touchPosition.x}, y: ${context.touchPosition.y}}"
      " state: ${context.gestureState}",
    );
  }

  void _onMove(MapContentGestureContext context) {
    log(
      "OnMove coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}"
      " point: {x: ${context.touchPosition.x}, y: ${context.touchPosition.y}}"
          " state: ${context.gestureState}",
    );
  }

  void _onZoom(MapContentGestureContext context) {
    log(
      "OnZoom coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}"
      " point: {x: ${context.touchPosition.x}, y: ${context.touchPosition.y}}"
          " state: ${context.gestureState}",
    );
  }

  void _onRotate(MapContentGestureContext context) {
    log(
      "OnRotate coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}"
      " point: {x: ${context.touchPosition.x}, y: ${context.touchPosition.y}}"
          " state: ${context.gestureState}",
    );
  }

  void _onPitch(MapContentGestureContext context) {
    log(
      "OnPitch coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}"
      " point: {x: ${context.touchPosition.x}, y: ${context.touchPosition.y}}"
          " state: ${context.gestureState}",
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;

    mapboxMap.addInteraction(TapInteraction.onMap(_onTap));
    if (isMobile) {
      mapboxMap.addInteraction(LongTapInteraction.onMap(_onLongTap));
    }
    _cancelables.addAll([
      mapboxMap.gestures.pan.gestureEvents.listen(_onMove).asCancelable(),
      mapboxMap.gestures.zoom.gestureEvents.listen(_onZoom).asCancelable(),
      mapboxMap.gestures.rotate.gestureEvents.listen(_onRotate).asCancelable(),
      mapboxMap.gestures.pitch.gestureEvents.listen(_onPitch).asCancelable(),
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
    for (final c in _cancelables) {
      c.cancel();
    }
    _cancelables.clear();
    super.dispose();
  }

  Widget _settingsPanel() {
    return Card(
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              'Gestures',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(height: 0),
          for (var i = 0; i < _toggles.length; i++)
            SwitchListTile(
              dense: true,
              title: Text(_toggles[i].label),
              value: _toggleValues[i] ?? false,
              onChanged: !_toggleValues.containsKey(i)
                  ? null
                  : (value) async {
                      setState(() => _toggleValues[i] = value);
                      await mapboxMap?.gestures.updateSettings(
                        _toggles[i].apply(value),
                      );
                    },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 400,
            child: mapWidget,
          ),
        ),
        Expanded(child: SingleChildScrollView(child: _settingsPanel())),
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
