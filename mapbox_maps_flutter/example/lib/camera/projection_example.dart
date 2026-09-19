import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

/// Converts a tapped point between every coordinate space the map uses.
///
/// Tap the map: a marker drops where you tapped and the HUD shows that one
/// location as longitude/latitude, as screen pixels, as Web Mercator
/// coordinates and as projected meters — the same place expressed four ways.
/// The scale row shows how many meters one pixel covers, which is why the
/// numbers change as you zoom.
///
/// [MapboxMap.projection] is backed only by the native maps, so the example
/// app lists this example on Android and iOS only.
class ProjectionExample extends StatefulWidget {
  const ProjectionExample({super.key});

  @override
  State<ProjectionExample> createState() => _ProjectionExampleState();
}

class _ProjectionExampleState extends State<ProjectionExample> {
  static const _markerSourceId = 'projection-point';
  static const _markerLayerId = 'projection-point-layer';

  MapboxMap? _mapboxMap;

  /// The tapped location, in each space the projection API exposes.
  Point? _point;
  ScreenCoordinate? _touch;
  MercatorCoordinate? _mercator;
  ProjectedMeters? _meters;
  double? _metersPerPixel;
  double _zoom = 11;

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
    mapboxMap.addInteraction(TapInteraction.onMap(_onTap));
    await mapboxMap.addSource(
      GeoJsonSource(id: _markerSourceId, data: _emptyCollection),
    );
    await mapboxMap.addLayer(
      CircleLayer(
        id: _markerLayerId,
        sourceId: _markerSourceId,
        slot: 'top',
        circleRadius: 7,
        circleColor: MapboxColors.blue50.toARGB32(),
        circleStrokeWidth: 2.5,
        circleStrokeColor: Colors.white.toARGB32(),
      ),
    );
  }

  /// Recomputes every projection of [context]'s location.
  ///
  /// Reads the zoom first: `project` and `getMetersPerPixelAtLatitude` are both
  /// zoom-dependent, so passing the live camera zoom keeps the pixel values
  /// consistent with what is on screen.
  Future<void> _onTap(MapContentGestureContext context) async {
    final map = _mapboxMap;
    if (map == null) return;

    final point = context.point;
    final camera = await map.getCameraState();
    final zoom = camera.zoom;

    final mercator = await map.projection.project(point, zoom);
    final meters = await map.projection.projectedMetersForCoordinate(point);
    final metersPerPixel = await map.projection.getMetersPerPixelAtLatitude(
      point.coordinates.lat.toDouble(),
      zoom,
    );

    await map.setStyleSourceProperty(
      _markerSourceId,
      'data',
      _encodePoint(point),
    );

    if (!mounted) return;
    setState(() {
      _point = point;
      _touch = context.touchPosition;
      _mercator = mercator;
      _meters = meters;
      _metersPerPixel = metersPerPixel;
      _zoom = zoom;
    });
  }

  /// Round-trips the tapped point back through the inverse conversions, to
  /// show that `unproject` and `coordinateForProjectedMeters` return the
  /// coordinate the forward calls started from.
  Future<void> _verifyRoundTrip() async {
    final map = _mapboxMap;
    final mercator = _mercator;
    final meters = _meters;
    if (map == null || mercator == null || meters == null) {
      _snack('Tap the map first.');
      return;
    }
    final fromMercator = await map.projection.unproject(mercator, _zoom);
    final fromMeters = await map.projection.coordinateForProjectedMeters(
      meters,
    );
    _snack(
      'unproject → ${_latLng(fromMercator)}\n'
      'coordinateForProjectedMeters → ${_latLng(fromMeters)}',
    );
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 4)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final point = _point;
    return MapScaffold(
      controlsTitle: 'Projection',
      controlsSheetSize: ControlsSheetSize.small,
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      map: Stack(
        fit: StackFit.expand,
        children: [
          MapWidget(
            key: const ValueKey('mapWidget'),
            styleUri: MapboxStyles.STANDARD,
            viewport: CameraViewportState(
              center: Point(coordinates: Position(-122.4194, 37.7749)),
              zoom: 11,
            ),
            onMapCreated: _onMapCreated,
          ),
          MapHud(
            title: point == null ? 'Tap the map' : 'One point, four spaces',
            rows: [
              MapHudRow(
                'lng, lat',
                point == null ? '—' : _latLng(point),
                emphasized: true,
              ),
              MapHudRow('screen x, y', _touch == null ? '—' : _screen(_touch!)),
              MapHudRow(
                'mercator x, y',
                _mercator == null ? '—' : _mercatorText(_mercator!),
              ),
              MapHudRow(
                'easting, northing',
                _meters == null ? '—' : _metersText(_meters!),
              ),
              MapHudRow(
                'meters / pixel',
                _metersPerPixel == null
                    ? '—'
                    : _metersPerPixel!.toStringAsFixed(2),
              ),
              MapHudRow('zoom', _zoom.toStringAsFixed(2)),
            ],
          ),
        ],
      ),
      controlsBuilder: () => [
        ControlAction(
          label: 'Verify round trip',
          icon: Icons.swap_horiz,
          onPressed: _verifyRoundTrip,
        ),
        const SizedBox(height: 4),
        const Text(
          'Tap anywhere to project that location into screen pixels, Web '
          'Mercator and projected meters. Zoom in and tap again: the pixel '
          'and meters-per-pixel values change, the coordinate does not.',
          style: TextStyle(
            fontSize: 11,
            height: 1.35,
            color: MapboxGlass.labelFaint,
          ),
        ),
      ],
    );
  }
}

const _emptyCollection = '{"type":"FeatureCollection","features":[]}';

String _encodePoint(Point point) => json.encode({
  'type': 'Feature',
  'geometry': {
    'type': 'Point',
    'coordinates': [point.coordinates.lng, point.coordinates.lat],
  },
  'properties': <String, Object?>{},
});

String _latLng(Point point) =>
    '${point.coordinates.lng.toStringAsFixed(4)}, '
    '${point.coordinates.lat.toStringAsFixed(4)}';

String _screen(ScreenCoordinate coordinate) =>
    '${coordinate.x.toStringAsFixed(0)}, ${coordinate.y.toStringAsFixed(0)}';

String _mercatorText(MercatorCoordinate coordinate) =>
    '${coordinate.x.toStringAsFixed(5)}, ${coordinate.y.toStringAsFixed(5)}';

String _metersText(ProjectedMeters meters) =>
    '${_compact(meters.easting)}, ${_compact(meters.northing)}';

/// Projected meters reach eight digits, which would overflow the HUD row.
String _compact(double value) {
  final millions = value / 1000000;
  return '${millions.toStringAsFixed(2)}M';
}
