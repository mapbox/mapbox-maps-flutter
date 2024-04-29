import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'page.dart';

class CameraPage extends ExamplePage {
  CameraPage() : super(const Icon(Icons.map), 'CameraManager interface');

  @override
  Widget build(BuildContext context) {
    return const CameraPageBody();
  }
}

class CameraPageBody extends StatefulWidget {
  const CameraPageBody();

  @override
  State<StatefulWidget> createState() => CameraPageBodyState();
}

class CameraPageBodyState extends State<CameraPageBody> {
  CameraPageBodyState();

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

  Widget _cameraForCoordinateBounds() {
    return TextButton(
      child: Text('cameraForCoordinateBounds'),
      onPressed: () {
        mapboxMap
            ?.cameraForCoordinateBounds(
                CoordinateBounds(
                    southwest: Point(
                        coordinates: Position(
                      1.0,
                      2.0,
                    )),
                    northeast: Point(
                        coordinates: Position(
                      3.0,
                      4.0,
                    )),
                    infiniteBounds: true),
                MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
                10,
                20,
                null,
                null)
            .then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Camera zoom: ${value.zoom}, pitch: ${value.pitch}, bearing: ${value.bearing},padding: ${value.padding},center: ${value.center}"),
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: Duration(seconds: 2),
                    )));
      },
    );
  }

  Widget _cameraForCoordinatesCameraOptions() {
    return TextButton(
      child: Text('cameraForCoordinatesCameraOptions'),
      onPressed: () {
        mapboxMap?.cameraForCoordinatesCameraOptions(
            [
              Point(
                  coordinates: Position(
                1.0,
                2.0,
              )),
              Point(
                  coordinates: Position(
                3.0,
                4.0,
              ))
            ],
            CameraOptions(
                center: Point(
                    coordinates: Position(
                  1.0,
                  2.0,
                )),
                padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
                anchor: ScreenCoordinate(x: 1, y: 1),
                zoom: 10,
                bearing: 20,
                pitch: 30),
            ScreenBox(
                min: ScreenCoordinate(x: 0, y: 0),
                max: ScreenCoordinate(x: 100, y: 100))).then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Camera zoom: ${value.zoom}, pitch: ${value.pitch}, bearing: ${value.bearing},padding: ${value.padding},center: ${value.center}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _cameraForGeometry() {
    return TextButton(
      child: Text('cameraForGeometry'),
      onPressed: () {
        mapboxMap
            ?.cameraForGeometry(
                Point(
                    coordinates: Position(
                  1.0,
                  2.0,
                )).toJson(),
                MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
                10,
                20)
            .then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Camera zoom: ${value.zoom}, pitch: ${value.pitch}, bearing: ${value.bearing},padding: ${value.padding},center: ${value.center}"),
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: Duration(seconds: 2),
                    )));
      },
    );
  }

  Widget _coordinateBoundsForCamera() {
    return TextButton(
      child: Text('coordinateBoundsForCamera'),
      onPressed: () {
        mapboxMap
            ?.coordinateBoundsForCamera(CameraOptions(
                center: Point(
                    coordinates: Position(
                  1.0,
                  2.0,
                )),
                padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
                anchor: ScreenCoordinate(x: 1, y: 1),
                zoom: 10,
                bearing: 20,
                pitch: 30))
            .then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "coordinateBounds  northeast: ${value.northeast}, southwest: ${value.southwest}, infiniteBounds: ${value.infiniteBounds}"),
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: Duration(seconds: 2),
                    )));
      },
    );
  }

  Widget _coordinateBoundsForCameraUnwrapped() {
    return TextButton(
      child: Text('coordinateBoundsForCameraUnwrapped'),
      onPressed: () {
        mapboxMap
            ?.coordinateBoundsForCameraUnwrapped(CameraOptions(
                center: Point(
                    coordinates: Position(
                  1.0,
                  2.0,
                )),
                padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
                anchor: ScreenCoordinate(x: 1, y: 1),
                zoom: 10,
                bearing: 20,
                pitch: 30))
            .then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("coordinateBounds: ${value.encode()}"),
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: Duration(seconds: 2),
                    )));
      },
    );
  }

  Widget _coordinateBoundsZoomForCamera() {
    return TextButton(
      child: Text('coordinateBoundsZoomForCamera'),
      onPressed: () {
        mapboxMap
            ?.coordinateBoundsZoomForCamera(CameraOptions(
                center: Point(
                    coordinates: Position(
                  1.0,
                  2.0,
                )),
                padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
                anchor: ScreenCoordinate(x: 1, y: 1),
                zoom: 10,
                bearing: 20,
                pitch: 30))
            .then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("coordinateBounds: ${value.encode()}"),
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: Duration(seconds: 2),
                    )));
      },
    );
  }

  Widget _coordinateBoundsZoomForCameraUnwrapped() {
    return TextButton(
      child: Text('coordinateBoundsZoomForCameraUnwrapped'),
      onPressed: () {
        mapboxMap
            ?.coordinateBoundsZoomForCameraUnwrapped(CameraOptions(
                center: Point(
                    coordinates: Position(
                  1.0,
                  2.0,
                )),
                padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
                anchor: ScreenCoordinate(x: 1, y: 1),
                zoom: 10,
                bearing: 20,
                pitch: 30))
            .then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("coordinateBounds: ${value.encode()}"),
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: Duration(seconds: 2),
                    )));
      },
    );
  }

  Widget _pixelForCoordinate() {
    return TextButton(
      child: Text('pixelForCoordinate'),
      onPressed: () {
        mapboxMap
            ?.pixelForCoordinate(Point(
                coordinates: Position(
              1.0,
              2.0,
            )))
            .then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("ScreenCoordinate x: ${value.x}, y: ${value.y}"),
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: Duration(seconds: 2),
                    )));
      },
    );
  }

  Widget _pixelsForCoordinates() {
    return TextButton(
      child: Text('pixelsForCoordinates'),
      onPressed: () {
        mapboxMap?.pixelsForCoordinates([
          Point(
              coordinates: Position(
            1.0,
            2.0,
          )),
          Point(
              coordinates: Position(
            2.0,
            3.0,
          ))
        ]).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "ScreenCoordinate x: ${value.first?.x}, y: ${value.first?.y}"),
              backgroundColor: Theme.of(context).primaryColor,
              duration: Duration(seconds: 2),
            )));
      },
    );
  }

  Widget _coordinateForPixel() {
    return TextButton(
      child: Text('coordinateForPixel'),
      onPressed: () {
        mapboxMap
            ?.coordinateForPixel(ScreenCoordinate(x: 100, y: 100))
            .then((point) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Point latitude: ${point.coordinates.lat}, longitude: ${point.coordinates.lng}"),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 2),
          ));
        });
      },
    );
  }

  Widget _coordinatesForPixels() {
    return TextButton(
      child: Text('coordinatesForPixels'),
      onPressed: () {
        mapboxMap?.coordinatesForPixels([
          ScreenCoordinate(x: 100, y: 100),
          ScreenCoordinate(x: 200, y: 300)
        ]).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Points ${value.first}"),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 2),
          ));
        });
      },
    );
  }

  Widget _setCamera() {
    return TextButton(
      child: Text('setCamera'),
      onPressed: () {
        mapboxMap?.setCamera(CameraOptions(
            center: Point(
                coordinates: Position(
              0.381457,
              6.687337,
            )),
            padding: MbxEdgeInsets(top: 1, left: 2, bottom: 3, right: 4),
            anchor: ScreenCoordinate(x: 1, y: 1),
            zoom: 3,
            bearing: 20,
            pitch: 30));
      },
    );
  }

  Widget _getCameraState() {
    return TextButton(
      child: Text('getCameraState'),
      onPressed: () {
        mapboxMap?.getCameraState().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Camera state zoom: ${value.zoom}, pitch: ${value.pitch}, bearing: ${value.bearing},padding: ${value.padding},center: ${value.center}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _setBounds() {
    return TextButton(
      child: Text('setBounds'),
      onPressed: () {
        mapboxMap?.setBounds(CameraBoundsOptions(
            bounds: CoordinateBounds(
                southwest: Point(
                    coordinates: Position(
                  1.0,
                  2.0,
                )),
                northeast: Point(
                    coordinates: Position(
                  3.0,
                  4.0,
                )),
                infiniteBounds: true),
            maxZoom: 10,
            minZoom: 0,
            maxPitch: 10,
            minPitch: 0));
      },
    );
  }

  Widget _getBounds() {
    return TextButton(
      child: Text('getBounds'),
      onPressed: () {
        mapboxMap?.getBounds().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Bounds minZoom: ${value.minZoom}, maxZoom: ${value.maxZoom}, minPitch: ${value.minPitch},maxPitch: ${value.maxPitch},northeast: ${value.bounds.northeast}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget =
        MapWidget(key: ValueKey("mapWidget"), onMapCreated: _onMapCreated);

    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.addAll(
      <Widget>[
        _cameraForCoordinateBounds(),
        _cameraForCoordinatesCameraOptions(),
        _cameraForGeometry(),
        _coordinateBoundsForCamera(),
        _coordinateBoundsForCameraUnwrapped(),
        _coordinateBoundsZoomForCamera(),
        _coordinateBoundsZoomForCameraUnwrapped(),
        _pixelForCoordinate(),
        _pixelsForCoordinates(),
        _coordinateForPixel(),
        _coordinatesForPixels(),
        _setCamera(),
        _getCameraState(),
        _setBounds(),
        _getBounds(),
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
