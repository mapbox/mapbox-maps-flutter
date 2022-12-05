import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/helpers.dart';

import 'main.dart';
import 'page.dart';

class AnimationPage extends ExamplePage {
  AnimationPage() : super(const Icon(Icons.map), 'High level animation');

  @override
  Widget build(BuildContext context) {
    return const AnimationPageBody();
  }
}

class AnimationPageBody extends StatefulWidget {
  const AnimationPageBody();

  @override
  State<StatefulWidget> createState() => AnimationPageBodyState();
}

class AnimationPageBodyState extends State<AnimationPageBody> {
  AnimationPageBodyState();

  MapboxMap? mapboxMap;

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

  Widget _easeTo() {
    return TextButton(
      child: Text('easeTo'),
      onPressed: () {
        mapboxMap?.easeTo(
            CameraOptions(
                center: Point(
                    coordinates: Position(
                  -0.11968,
                  51.50325,
                )).toJson(),
                zoom: 15,
                bearing: 0,
                pitch: 3),
            MapAnimationOptions(duration: 2000, startDelay: 0));
      },
    );
  }

  Widget _flyTo() {
    return TextButton(
      child: Text('flyTo'),
      onPressed: () {
        mapboxMap?.flyTo(
            CameraOptions(
                anchor: ScreenCoordinate(x: 0, y: 0),
                zoom: 17,
                bearing: 180,
                pitch: 30),
            MapAnimationOptions(duration: 2000, startDelay: 0));
      },
    );
  }

  Widget _moveBy() {
    return TextButton(
      child: Text('moveBy'),
      onPressed: () {
        mapboxMap?.moveBy(ScreenCoordinate(x: 500.0, y: 500.0),
            MapAnimationOptions(duration: 2000, startDelay: 0));
      },
    );
  }

  Widget _rotateBy() {
    return TextButton(
      child: Text('rotateBy'),
      onPressed: () {
        mapboxMap?.rotateBy(
            ScreenCoordinate(x: 0, y: 0),
            ScreenCoordinate(x: 500.0, y: 500.0),
            MapAnimationOptions(duration: 2000, startDelay: 0));
      },
    );
  }

  Widget _scaleBy() {
    return TextButton(
      child: Text('scaleBy'),
      onPressed: () {
        mapboxMap?.scaleBy(15.0, ScreenCoordinate(x: 10.0, y: 10.0),
            MapAnimationOptions(duration: 2000, startDelay: 0));
      },
    );
  }

  Widget _pitchBy() {
    return TextButton(
      child: Text('pitchBy'),
      onPressed: () {
        mapboxMap?.pitchBy(
            70.0, MapAnimationOptions(duration: 2000, startDelay: 0));
      },
    );
  }

  Widget _cancelCameraAnimation() {
    return TextButton(
      child: Text('cancelCameraAnimation'),
      onPressed: () {
        mapboxMap?.cancelCameraAnimation();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
        key: ValueKey("mapWidget"),
        resourceOptions: ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
        onMapCreated: _onMapCreated);

    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.addAll(
      <Widget>[
        _cancelCameraAnimation(),
        _easeTo(),
        _flyTo(),
        _moveBy(),
        _rotateBy(),
        _scaleBy(),
        _pitchBy(),
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
