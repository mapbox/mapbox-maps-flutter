import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'example.dart';

class GesturesExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'Gestures';

  @override
  State<StatefulWidget> createState() => GesturesExampleState();
}

class GesturesExampleState extends State<GesturesExample> {
  GesturesExampleState();

  final colors = [Colors.amber, Colors.black, Colors.blue];

  MapboxMap? mapboxMap;

  _onTap(MapContentGestureContext context) {
    print("OnTap coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}" +
        " point: {x: ${context.touchPosition.x}, y: ${context.touchPosition.y}}" +
        " state: ${context.gestureState}");
  }

  _onLongTap(MapContentGestureContext context) {
    print("OnLongTap coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}" +
        " point: {x: ${context.touchPosition.x}, y: ${context.touchPosition.y}}" +
        " state: ${context.gestureState}");
  }

  _onMove(MapContentGestureContext context) {
    print("OnMove coordinate: {${context.point.coordinates.lng}, ${context.point.coordinates.lat}}" +
        " point: {x: ${context.touchPosition.x}, y: ${context.touchPosition.y}}" +
        " state: ${context.gestureState}");
  }

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _getGestureSettings() {
    return TextButton(
      child: Text('get gesture settings'),
      onPressed: () {
        mapboxMap?.gestures.getSettings().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("""
                  Gesture settings : 
                    doubleTapToZoomInEnabled : ${value.doubleTapToZoomInEnabled}, 
                    doubleTouchToZoomOutEnabled : ${value.doubleTouchToZoomOutEnabled}
                    focalPoint : ${value.focalPoint}
                    increasePinchToZoomThresholdWhenRotating : ${value.increasePinchToZoomThresholdWhenRotating}
                    increaseRotateThresholdWhenPinchingToZoom : ${value.increaseRotateThresholdWhenPinchingToZoom}
                    pinchPanEnabled : ${value.pinchPanEnabled}
                    pinchToZoomDecelerationEnabled :  ${value.pinchToZoomDecelerationEnabled},
                    quickZoomEnabled :  ${value.quickZoomEnabled}
                    rotateEnabled : ${value.rotateEnabled}
                    """
                      .trim()),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _disableRotate() {
    return TextButton(
      child: Text('disable rotate'),
      onPressed: () {
        mapboxMap?.gestures
            .updateSettings(GesturesSettings(rotateEnabled: false));
      },
    );
  }

  Widget _enableRotate() {
    return TextButton(
      child: Text('enable rotate'),
      onPressed: () {
        mapboxMap?.gestures
            .updateSettings(GesturesSettings(rotateEnabled: true));
      },
    );
  }

  Widget _disableQuickZoom() {
    return TextButton(
      child: Text('disable quick zoom'),
      onPressed: () {
        mapboxMap?.gestures
            .updateSettings(GesturesSettings(quickZoomEnabled: false));
      },
    );
  }

  Widget _enableQuickZoom() {
    return TextButton(
      child: Text('enable quick zoom'),
      onPressed: () {
        mapboxMap?.gestures
            .updateSettings(GesturesSettings(quickZoomEnabled: true));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
      onTapListener: _onTap,
      onLongTapListener: _onLongTap,
      onScrollListener: _onMove,
    );

    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.addAll(
      <Widget>[
        _getGestureSettings(),
        _disableRotate(),
        _enableRotate(),
        _disableQuickZoom(),
        _enableQuickZoom(),
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 400,
              child: mapWidget),
        ),
        Expanded(
          child: ListView(
            children: listViewChildren,
          ),
        )
      ],
    );
  }
}
