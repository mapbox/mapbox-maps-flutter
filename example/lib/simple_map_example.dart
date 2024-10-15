import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class SimpleMapExample extends StatefulWidget implements Example {
  const SimpleMapExample({super.key});

  @override
  final Widget leading = const Icon(Icons.map_outlined);
  @override
  final String title = 'Display a simple map';
  @override
  final String subtitle =
      'Create and display a map that uses the default Mapbox Standard style.';

  @override
  State<StatefulWidget> createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMapExample> {
  _SimpleMapState();

  late ViewportManager _viewportManager;
  late ViewportState _overviewViewportState;
  late ViewportState _followPuckViewportState;
  late ViewportTransition _immediateTransition;
  late ViewportTransition _defaultTransition;
  bool _isFollowing = false;

  _onMapCreated(MapboxMap mapboxMap) {
    _viewportManager = mapboxMap.viewport;
  }

  void _onStyleLoaded(StyleLoadedEventData styleLoadedEventData) async {
    _overviewViewportState = await _viewportManager.makeOverviewViewportState(
        options: OverviewViewportStateOptions(
      geometry: Polygon.fromPoints(points: [
        [
          Point(
              coordinates: Position.named(
                  lat: 60.26117083900044, lng: 24.7457836509098)),
          Point(
              coordinates:
                  Position.named(lat: 60.1615202856936, lng: 24.7457836509098)),
          Point(
              coordinates: Position.named(
                  lat: 60.1615202856936, lng: 25.111325674190937)),
          Point(
              coordinates: Position.named(
                  lat: 60.26117083900044, lng: 25.111325674190937)),
          Point(
              coordinates: Position.named(
                  lat: 60.26117083900044, lng: 24.7457836509098)),
        ]
      ]),
    ));
    _followPuckViewportState =
        await _viewportManager.makeFollowPuckViewportState(
      options: FollowPuckViewportStateOptions(
          bearing: FollowPuckViewportStateBearingCourse()),
    );
    _immediateTransition = await _viewportManager.makeImmediateViewportTransition();
    _defaultTransition = await _viewportManager.makeDefaultViewportTransition();
    await _syncViewport();
  }

  Future<void> _syncViewport() async {
    final state =
        _isFollowing ? _followPuckViewportState : _overviewViewportState;
    final transition = _isFollowing ? _defaultTransition : _immediateTransition;
    await _viewportManager.transition(state, transition: transition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            _isFollowing = !_isFollowing;
          });
          await _syncViewport();
        },
        child: _isFollowing
            ? const Icon(Icons.my_location)
            : const Icon(Icons.zoom_out_map),
      ),
      body: MapWidget(
        key: ValueKey("mapWidget"),
        cameraOptions: CameraOptions(
            center: Point(
                coordinates: Position.named(lat: 60.167488, lng: 24.942747)),
            zoom: 11,
            bearing: 12,
            pitch: 60),
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoaded,
      ),
    );
  }
}
