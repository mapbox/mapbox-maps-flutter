import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class FullMapExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'Full screen map';
  @override
  final String? subtitle = null;

  @override
  State createState() => FullMapExampleState();
}

class FullMapExampleState extends State<FullMapExample> {
  MapboxMap? mapboxMap;
  var isLight = true;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.style.setStyleImportConfigProperty("basemap", "theme", "monochrome");
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :), time: ${data.timeInterval}"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  _onCameraChangeListener(CameraChangedEventData data) {
    print("CameraChangedEventData: ${data.debugInfo}");
  }

  _onResourceRequestListener(ResourceEventData data) {
    print("ResourceEventData: time: ${data.timeInterval}");
  }

  _onMapIdleListener(MapIdleEventData data) {
    print("MapIdleEventData: timestamp: ${data.timestamp}");
  }

  _onMapLoadedListener(MapLoadedEventData data) {
    print("MapLoadedEventData: time: ${data.timeInterval}");
  }

  _onMapLoadingErrorListener(MapLoadingErrorEventData data) {
    print("MapLoadingErrorEventData: timestamp: ${data.timestamp}");
  }

  _onRenderFrameStartedListener(RenderFrameStartedEventData data) {
    print("RenderFrameStartedEventData: timestamp: ${data.timestamp}");
  }

  _onRenderFrameFinishedListener(RenderFrameFinishedEventData data) {
    print("RenderFrameFinishedEventData: time: ${data.timeInterval}");
  }

  _onSourceAddedListener(SourceAddedEventData data) {
    print("SourceAddedEventData: timestamp: ${data.timestamp}");
  }

  _onSourceDataLoadedListener(SourceDataLoadedEventData data) {
    print("SourceDataLoadedEventData: time: ${data.timeInterval}");
  }

  _onSourceRemovedListener(SourceRemovedEventData data) {
    print("SourceRemovedEventData: timestamp: ${data.timestamp}");
  }

  _onStyleDataLoadedListener(StyleDataLoadedEventData data) {
    print("StyleDataLoadedEventData: time: ${data.timeInterval}");
  }

  _onStyleImageMissingListener(StyleImageMissingEventData data) {
    print("StyleImageMissingEventData: timestamp: ${data.timestamp}");
  }

  _onStyleImageUnusedListener(StyleImageUnusedEventData data) {
    print("StyleImageUnusedEventData: timestamp: ${data.timestamp}");
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
                    setState(
                      () => isLight = !isLight,
                    );
                    if (isLight) {
                      mapboxMap?.style.setStyleImportConfigProperty("basemap", "lightPreset", "day");
                    } else {
                      mapboxMap?.style.setStyleImportConfigProperty("basemap", "lightPreset", "night");
                    }
                  }),
              SizedBox(height: 10),
            ],
          ),
        ),
        body: MapWidget(
          key: ValueKey("mapWidget"),
          cameraOptions: CameraOptions(
              center: Point(
                  coordinates: Position(
                6.0033416748046875,
                43.70908256335716,
              )),
              zoom: 3.0),
          styleUri: MapboxStyles.STANDARD,
          textureView: true,
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
          onLongTapListener: (coordinate) {},
        ));
  }
}

extension on CameraChangedEventData {
  String get debugInfo {
    return "timestamp ${DateTime.fromMicrosecondsSinceEpoch(timestamp)}, camera: ${cameraState.debugInfo}";
  }
}

extension on CameraState {
  String get debugInfo {
    return "lat: ${center.coordinates.lat}, lng: ${center.coordinates.lng}, zoom: ${zoom}, bearing: ${bearing}, pitch: ${pitch}";
  }
}
