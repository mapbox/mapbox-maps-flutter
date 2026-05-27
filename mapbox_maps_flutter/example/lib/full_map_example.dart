import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'platform.dart';

class FullMapExample extends StatefulWidget {
  const FullMapExample({super.key});

  @override
  State createState() => FullMapExampleState();
}

class FullMapExampleState extends State<FullMapExample> {
  MapboxMap? mapboxMap;
  var isLight = true;

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.style.setStyleImportConfigProperty(
      "basemap",
      "theme",
      "monochrome",
    );

    mapboxMap.addInteraction(
      TapInteraction.onMap((context) {
        log(
          "on map tap at point: ${context.touchPosition}, lngLat: ${context.point}",
        );
      }),
    );

    if (isMobile) {
      mapboxMap.addInteraction(
        LongTapInteraction.onMap((context) {
          log(
            "on map long tap at point: ${context.touchPosition}, lngLat: ${context.point}",
          );
        }),
      );
    }
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Style loaded :), time: ${data.timeInterval}"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 1),
      ),
    );
  }

  _onCameraChangeListener(CameraChangedEventData data) {
    log("CameraChangedEventData: ${data.debugInfo}");
  }

  _onResourceRequestListener(ResourceEventData data) {
    log("ResourceEventData: time: ${data.timeInterval}");
  }

  _onMapIdleListener(MapIdleEventData data) {
    log("MapIdleEventData: timestamp: ${data.timestamp}");
  }

  _onMapLoadedListener(MapLoadedEventData data) {
    log("MapLoadedEventData: time: ${data.timeInterval}");
  }

  _onMapLoadingErrorListener(MapLoadingErrorEventData data) {
    log("MapLoadingErrorEventData: timestamp: ${data.timestamp}");
  }

  _onRenderFrameStartedListener(RenderFrameStartedEventData data) {
    log("RenderFrameStartedEventData: timestamp: ${data.timestamp}");
  }

  _onRenderFrameFinishedListener(RenderFrameFinishedEventData data) {
    log("RenderFrameFinishedEventData: time: ${data.timeInterval}");
  }

  _onSourceAddedListener(SourceAddedEventData data) {
    log("SourceAddedEventData: timestamp: ${data.timestamp}");
  }

  _onSourceDataLoadedListener(SourceDataLoadedEventData data) {
    log("SourceDataLoadedEventData: time: ${data.timeInterval}");
  }

  _onSourceRemovedListener(SourceRemovedEventData data) {
    log("SourceRemovedEventData: timestamp: ${data.timestamp}");
  }

  _onStyleDataLoadedListener(StyleDataLoadedEventData data) {
    log("StyleDataLoadedEventData: time: ${data.timeInterval}");
  }

  _onStyleImageMissingListener(StyleImageMissingEventData data) {
    log("StyleImageMissingEventData: timestamp: ${data.timestamp}");
  }

  _onStyleImageUnusedListener(StyleImageUnusedEventData data) {
    log("StyleImageUnusedEventData: timestamp: ${data.timestamp}");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.swap_horiz),
              heroTag: null,
              onPressed: () {
                setState(() => isLight = !isLight);
                if (isLight) {
                  mapboxMap?.style.setStyleImportConfigProperty(
                    "basemap",
                    "lightPreset",
                    "day",
                  );
                } else {
                  mapboxMap?.style.setStyleImportConfigProperty(
                    "basemap",
                    "lightPreset",
                    "night",
                  );
                }
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      body: MapWidget(
        key: ValueKey("mapWidget"),
        viewport: CameraViewportState(
          center: Point(
            coordinates: Position(6.0033416748046875, 43.70908256335716),
          ),
          zoom: 3.0,
        ),
        styleUri: MapboxStyles.STANDARD,
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoadedCallback,
        onCameraChangeListener: _onCameraChangeListener,
        onMapIdleListener: _onMapIdleListener,
        onMapLoadedListener: _onMapLoadedListener,
        onMapLoadErrorListener: _onMapLoadingErrorListener,
        onRenderFrameStartedListener: _onRenderFrameStartedListener,
        onRenderFrameFinishedListener: _onRenderFrameFinishedListener,
        onSourceAddedListener: _onSourceAddedListener,
        onSourceDataLoadedListener: _onSourceDataLoadedListener,
        onSourceRemovedListener: _onSourceRemovedListener,
        onStyleDataLoadedListener: _onStyleDataLoadedListener,
        onStyleImageMissingListener: _onStyleImageMissingListener,
        onStyleImageUnusedListener: _onStyleImageUnusedListener,
        onResourceRequestListener: _onResourceRequestListener,
      ),
    );
  }
}

extension on CameraChangedEventData {
  String get debugInfo {
    return "timestamp ${DateTime.fromMicrosecondsSinceEpoch(timestamp)}, camera: ${cameraState.debugInfo}";
  }
}

extension on CameraState {
  String get debugInfo {
    return "lat: ${this.center.coordinates.lat}, lng: ${this.center.coordinates.lng}, zoom: ${zoom}, bearing: ${bearing}, pitch: ${pitch}";
  }
}
