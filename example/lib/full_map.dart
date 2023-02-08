import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'main.dart';
import 'page.dart';

class FullMapPage extends ExamplePage {
  FullMapPage() : super(const Icon(Icons.map), 'Full screen map');

  @override
  Widget build(BuildContext context) {
    return const FullMap();
  }
}

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMap? mapboxMap;
  var isLight = true;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.subscribe(_eventObserver, [
      MapEvents.STYLE_LOADED,
      MapEvents.MAP_LOADED,
      MapEvents.MAP_IDLE,
    ]);
  }

  _eventObserver(Event event) {
    print("Receive event, type: ${event.type}, data: ${event.data}");
  }

  _onStyleLoadedCallback(StyleLoadedEventData data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :), begin: ${data.begin}"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

  _onCameraChangeListener(CameraChangedEventData data) {
    print("CameraChangedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapIdleListener(MapIdleEventData data) {
    print("MapIdleEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapLoadedListener(MapLoadedEventData data) {
    print("MapLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onMapLoadingErrorListener(MapLoadingErrorEventData data) {
    print("MapLoadingErrorEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onRenderFrameStartedListener(RenderFrameStartedEventData data) {
    print(
        "RenderFrameStartedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onRenderFrameFinishedListener(RenderFrameFinishedEventData data) {
    print(
        "RenderFrameFinishedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceAddedListener(SourceAddedEventData data) {
    print("SourceAddedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceDataLoadedListener(SourceDataLoadedEventData data) {
    print("SourceDataLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onSourceRemovedListener(SourceRemovedEventData data) {
    print("SourceRemovedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleDataLoadedListener(StyleDataLoadedEventData data) {
    print("StyleDataLoadedEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleImageMissingListener(StyleImageMissingEventData data) {
    print("StyleImageMissingEventData: begin: ${data.begin}, end: ${data.end}");
  }

  _onStyleImageUnusedListener(StyleImageUnusedEventData data) {
    print("StyleImageUnusedEventData: begin: ${data.begin}, end: ${data.end}");
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
                      mapboxMap?.loadStyleURI(MapboxStyles.LIGHT);
                    } else {
                      mapboxMap?.loadStyleURI(MapboxStyles.DARK);
                    }
                  }),
              SizedBox(height: 10),
            ],
          ),
        ),
        body: MapWidget(
          key: ValueKey("mapWidget"),
          resourceOptions: ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
          cameraOptions: CameraOptions(
              center: Point(
                  coordinates: Position(
                6.0033416748046875,
                43.70908256335716,
              )).toJson(),
              zoom: 3.0),
          styleUri: MapboxStyles.LIGHT,
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
        ));
  }
}
