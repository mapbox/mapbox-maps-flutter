import 'dart:developer';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// A full screen map that switches the basemap light preset.
///
/// The example also subscribes to every map event and logs it, which is a
/// useful starting point when you debug style or tile loading.
class FullMapExample extends StatefulWidget {
  const FullMapExample({super.key});

  @override
  State<FullMapExample> createState() => _FullMapExampleState();
}

class _FullMapExampleState extends State<FullMapExample> {
  MapboxMap? _mapboxMap;
  var _isDay = true;

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    mapboxMap.setStyleImportConfigProperty('basemap', 'theme', 'monochrome');

    mapboxMap.addInteraction(
      TapInteraction.onMap((context) {
        log('map tap at ${context.touchPosition}, lngLat: ${context.point}');
      }),
    );

    // LongTapInteraction has no web implementation.
    if (!kIsWeb) {
      mapboxMap.addInteraction(
        LongTapInteraction.onMap((context) {
          log('map long tap at ${context.touchPosition}');
        }),
      );
    }
  }

  void _toggleLightPreset() {
    setState(() => _isDay = !_isDay);
    _mapboxMap?.setStyleImportConfigProperty(
      'basemap',
      'lightPreset',
      _isDay ? 'day' : 'night',
    );
  }

  void _onStyleLoaded(StyleLoadedEventData data) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Style loaded in ${data.timeInterval.durationMs} ms'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleLightPreset,
        tooltip: _isDay ? 'Switch to night' : 'Switch to day',
        child: Icon(_isDay ? Icons.dark_mode : Icons.light_mode),
      ),
      body: MapWidget(
        key: const ValueKey('mapWidget'),
        styleUri: MapboxStyles.STANDARD,
        viewport: CameraViewportState(
          center: Point(
            coordinates: Position(6.0033416748046875, 43.70908256335716),
          ),
          zoom: 3.0,
        ),
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoaded,
        onCameraChangeListener: (data) => log(
          'camera: ${data.cameraState.center}, '
          'zoom ${data.cameraState.zoom}',
        ),
        onMapIdleListener: (data) => log('map idle'),
        onMapLoadedListener: (data) =>
            log('map loaded in ${data.timeInterval.durationMs} ms'),
        onMapLoadErrorListener: (data) =>
            log('map load error: ${data.message}'),
        onRenderFrameStartedListener: (data) => log('render frame started'),
        onRenderFrameFinishedListener: (data) => log('render frame finished'),
        onSourceAddedListener: (data) => log('source added: ${data.id}'),
        onSourceDataLoadedListener: (data) => log('source data loaded'),
        onSourceRemovedListener: (data) => log('source removed: ${data.id}'),
        onStyleDataLoadedListener: (data) => log('style data loaded'),
        onStyleImageMissingListener: (data) =>
            log('style image missing: ${data.id}'),
        onStyleImageUnusedListener: (data) =>
            log('style image unused: ${data.id}'),
      ),
    );
  }
}

/// Elapsed milliseconds an event took, from its begin and end timestamps.
extension on EventTimeInterval {
  int get durationMs => end.difference(begin).inMilliseconds;
}
