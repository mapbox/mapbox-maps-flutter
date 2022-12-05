import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'main.dart';
import 'page.dart';

class GesturesPage extends ExamplePage {
  GesturesPage() : super(const Icon(Icons.map), 'Gestures');

  @override
  Widget build(BuildContext context) {
    return const GesturesPageBody();
  }
}

class GesturesPageBody extends StatefulWidget {
  const GesturesPageBody();

  @override
  State<StatefulWidget> createState() => GesturesPageBodyState();
}

class GesturesPageBodyState extends State<GesturesPageBody> {
  GesturesPageBodyState();

  final colors = [Colors.amber, Colors.black, Colors.blue];

  MapboxMap? mapboxMap;

  _onTap(ScreenCoordinate coordinate) {
    print("OnTap ${coordinate.x} - ${coordinate.y}");
  }

  _onLongTap(ScreenCoordinate coordinate) {
    print("OnLongTap ${coordinate.x} - ${coordinate.y}");
  }

  _onMove(ScreenCoordinate coordinate) {
    print("OnMove ${coordinate.x} - ${coordinate.y}");
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
      resourceOptions: ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
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
