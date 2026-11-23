// ignore_for_file: experimental_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// Shows built-in Standard style indoor data: floors of a supported venue
/// (here, Paris Orly airport). Floor switching is done through the built-in
/// indoor selector ornament; `mapboxMap.indoor` is only used to observe
/// floor changes and toast them.
class IndoorExample extends StatefulWidget {
  const IndoorExample({super.key});

  @override
  State<StatefulWidget> createState() => IndoorExampleState();
}

class IndoorExampleState extends State<IndoorExample> {
  StreamSubscription<IndoorState>? _subscription;
  String? _selectedFloorId;
  MapboxMap? _mapboxMap;
  bool _showIndoorEnabled = false;

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _enableShowIndoor(mapboxMap);
    _subscription = mapboxMap.indoor.indoorUpdates.listen(_onIndoorUpdate);
  }

  // The Standard style's "basemap" import may still be loading when
  // onMapCreated fires, so the very first write can silently not take (web)
  // or throw because the import doesn't exist yet (Android). Retry on every
  // subsequent onStyleDataLoadedListener callback until
  // getStyleImportConfigProperty confirms it took.
  Future<void> _enableShowIndoor(MapboxMap mapboxMap) async {
    if (_showIndoorEnabled) return;
    try {
      await mapboxMap.setStyleImportConfigProperty(
        "basemap",
        "showIndoor",
        true,
      );
      final applied = await mapboxMap.getStyleImportConfigProperty(
        "basemap",
        "showIndoor",
      );
      _showIndoorEnabled = applied.value == true;
    } catch (_) {
      // Import not merged into the style yet; retried on the next
      // onStyleDataLoadedListener callback.
    }
  }

  void _onIndoorUpdate(IndoorState state) {
    if (state.selectedFloorId == _selectedFloorId) return;
    _selectedFloorId = state.selectedFloorId;
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(_floorLabel(state)),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  String _floorLabel(IndoorState state) {
    final id = state.selectedFloorId;
    if (id == null) return 'No floor selected';
    for (final floor in state.floors) {
      if (floor.id == id) return 'Floor: ${floor.name}';
    }
    return 'Floor: $id';
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      key: const ValueKey("mapWidget"),
      styleUri: MapboxStyles.STANDARD,
      viewport: CameraViewportState(
        center: Point(coordinates: Position(2.36020, 48.72861)),
        zoom: 17,
      ),
      onMapCreated: _onMapCreated,
      onStyleDataLoadedListener: (_) {
        final mapboxMap = _mapboxMap;
        if (mapboxMap != null) _enableShowIndoor(mapboxMap);
      },
    );
  }
}
