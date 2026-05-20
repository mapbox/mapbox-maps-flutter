import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'main.dart' show isMobile;

class LocationExample extends StatefulWidget {
  const LocationExample({super.key});

  @override
  State<StatefulWidget> createState() => LocationExampleState();
}

class LocationExampleState extends State<LocationExample> {
  MapboxMap? mapboxMap;
  final _viewportController = ViewportController();
  bool _enabled = false;
  bool _pulsing = false;
  bool _accuracy = false;
  bool _bearing = false;

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  @override
  void dispose() {
    _viewportController.dispose();
    mapboxMap?.dispose();
    super.dispose();
  }

  Future<void> _toggleLocation() async {
    final next = !_enabled;

    if (next) {
      await Geolocator.requestPermission();
    }

    await mapboxMap?.location.updateSettings(
      LocationComponentSettings(enabled: next),
    );
    _viewportController.moveTo(
      next ? FollowPuckViewportState() : const IdleViewportState(),
      transition: const FlyViewportTransition()
    );
    setState(() => _enabled = next);
  }

  void _setPulsing(bool value) {
    setState(() => _pulsing = value);
    mapboxMap?.location.updateSettings(
      LocationComponentSettings(pulsingEnabled: value),
    );
  }

  void _setAccuracy(bool value) {
    setState(() => _accuracy = value);
    mapboxMap?.location.updateSettings(
      LocationComponentSettings(showAccuracyRing: value),
    );
  }

  void _setBearing(bool value) {
    setState(() => _bearing = value);
    mapboxMap?.location.updateSettings(
      LocationComponentSettings(puckBearingEnabled: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        key: const ValueKey('mapWidget'),
        onMapCreated: _onMapCreated,
        viewportController: _viewportController,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleLocation,
        label: Icon(_enabled ? Icons.location_disabled : Icons.my_location),
      ),
      bottomNavigationBar: Card(
        margin: EdgeInsets.zero,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Pulsing'),
                value: isMobile ? _pulsing : true,
                onChanged: isMobile ? (_enabled ? _setPulsing : null) : null,
              ),
              SwitchListTile(
                title: const Text('Accuracy ring'),
                value: _accuracy,
                onChanged: _enabled ? _setAccuracy : null,
              ),
              SwitchListTile(
                title: const Text('Bearing'),
                value: _bearing,
                onChanged: _enabled ? _setBearing : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
