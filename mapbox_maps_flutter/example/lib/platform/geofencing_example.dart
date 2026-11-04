import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart' show Geolocator, LocationPermission;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/turf.dart' as turf;

import '../scene_scaffold.dart';

const _sourceId = 'geofences';
const _radius = 100.0;

/// Tap the map to monitor a circle around the tap. Move the simulator's
/// location into it to get entry, dwell, and exit events.
class GeofencingExample extends StatefulWidget {
  const GeofencingExample({super.key});

  @override
  State<GeofencingExample> createState() => _GeofencingExampleState();
}

class _GeofencingExampleState extends State<GeofencingExample> {
  final _service = GeofencingService.instance;
  final _viewportController = ViewportController();
  final _subscriptions = <StreamSubscription<Object>>[];
  MapboxMap? _mapboxMap;

  /// Circles drawn on the map, keyed by feature id.
  final _circles = <String, turf.Feature<turf.Polygon>>{};

  /// Latest event per feature id: `entry`, `dwell`, or `exit`.
  final _states = <String, String>{};
  final _log = <String>[];

  @override
  void initState() {
    super.initState();
    _subscriptions.addAll([
      _service.entryEvents.listen((e) => _onEvent('entry', e)),
      _service.dwellEvents.listen((e) => _onEvent('dwell', e)),
      _service.exitEvents.listen((e) => _onEvent('exit', e)),
      _service.errors.listen(_onError),
    ]);
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _viewportController.dispose();
    super.dispose();
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
    mapboxMap.addInteraction(TapInteraction.onMap(_onMapTapped));

    // Android asks for background location in a second request.
    var permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
    }
    if (permission != LocationPermission.always) {
      _addLog(
        'Location permission: ${permission.name}. Allow it all the time '
        'to get events in the background.',
      );
    }
    // Events are shown as notifications by main().
    final notifications = FlutterLocalNotificationsPlugin();
    await notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true);
    await mapboxMap.location.updateSettings(
      LocationComponentSettings(enabled: true),
    );
    _viewportController.moveTo(
      const FollowPuckViewportState(zoom: 15),
      transition: const FlyViewportTransition(),
    );
    // Features are stored on disk, so start clean.
    await _service.clearFeatures();
  }

  Future<void> _onStyleLoaded(StyleLoadedEventData _) async {
    final map = _mapboxMap;
    if (map == null) return;
    await map.addSource(GeoJsonSource(id: _sourceId, data: _geoJson()));
    await map.addLayer(
      FillLayer(
        id: _sourceId,
        sourceId: _sourceId,
        fillOpacity: 0.4,
        fillColorExpression: [
          'match',
          ['get', 'state'],
          'entry',
          'orange',
          'dwell',
          'red',
          'gray',
        ],
      ),
    );
  }

  Future<void> _onMapTapped(MapContentGestureContext context) async {
    final id = 'geofence-${_circles.length + 1}';
    try {
      await _service.addFeature(
        GeofenceFeature.circle(
          id: id,
          center: context.point,
          radius: _radius,
          dwellTime: const Duration(minutes: 1),
        ),
      );
    } on GeofencingError catch (error) {
      _onError(error);
      return;
    }
    _circles[id] = turf.circle(context.point, _radius / 1000);
    _addLog('Added $id');
    await _redraw();
  }

  void _onEvent(String type, GeofencingEvent event) {
    final id = '${event.feature.id}';
    _states[id] = type;
    _addLog(
      '${TimeOfDay.fromDateTime(event.timestamp).format(context)} '
      '$type $id',
    );
    _redraw();
  }

  void _onError(Object error) => _addLog('$error');

  void _addLog(String line) {
    if (!mounted) return;
    setState(() {
      _log.insert(0, line);
      if (_log.length > 5) _log.removeLast();
    });
  }

  Future<void> _clear() async {
    await _service.clearFeatures();
    _circles.clear();
    _states.clear();
    _addLog('Cleared');
    await _redraw();
  }

  String _geoJson() => json.encode(
    turf.FeatureCollection(
      features: [
        for (final MapEntry(:key, :value) in _circles.entries)
          turf.Feature(
            id: key,
            geometry: value.geometry,
            properties: {'state': _states[key]},
          ),
      ],
    ).toJson(),
  );

  Future<void> _redraw() async {
    final source = await _mapboxMap?.getSource(_sourceId);
    await (source as GeoJsonSource?)?.updateGeoJSON(_geoJson());
  }

  @override
  Widget build(BuildContext context) {
    return MapScaffold(
      controlsTitle: 'Geofencing',
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: MapWidget(
        key: const ValueKey('mapWidget'),
        viewportController: _viewportController,
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoaded,
      ),
      controlsBuilder: () => [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Tap the map to add a 100 m geofence. Move the simulator location '
            'into it: Xcode Debug > Simulate Location, or the emulator '
            'Location panel.',
            style: TextStyle(fontSize: 12, color: MapboxGlass.labelFaint),
          ),
        ),
        ControlAction(
          label: 'Clear geofences',
          icon: Icons.delete_outline,
          onPressed: _circles.isEmpty ? null : _clear,
        ),
        ControlRow(
          label: 'Events',
          child: Text(
            _log.isEmpty ? 'None yet' : _log.join('\n'),
            style: const TextStyle(fontSize: 12, color: MapboxGlass.label),
          ),
        ),
      ],
    );
  }
}
