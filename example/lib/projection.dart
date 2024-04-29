import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'page.dart';

class ProjectionPage extends ExamplePage {
  ProjectionPage() : super(const Icon(Icons.map), 'Projection interface');

  @override
  Widget build(BuildContext context) {
    return const ProjectionPageBody();
  }
}

class ProjectionPageBody extends StatefulWidget {
  const ProjectionPageBody();

  @override
  State<StatefulWidget> createState() => ProjectionPageBodyState();
}

class ProjectionPageBodyState extends State<ProjectionPageBody> {
  ProjectionPageBodyState();

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

  Widget _getMetersPerPixelAtLatitude() {
    return TextButton(
      child: Text('getMetersPerPixelAtLatitude'),
      onPressed: () {
        mapboxMap?.projection.getMetersPerPixelAtLatitude(1.0, 16).then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("MetersPerPixel: $value"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _projectedMetersForCoordinate() {
    return TextButton(
      child: Text('projectedMetersForCoordinate'),
      onPressed: () {
        mapboxMap?.projection
            .projectedMetersForCoordinate(Point(
                coordinates: Position(
              1.0,
              60,
            )))
            .then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "projectedMeters.easting: ${value.easting}, northing: ${value.northing}"),
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: Duration(seconds: 2),
                    )));
      },
    );
  }

  Widget _coordinateForProjectedMeters() {
    return TextButton(
      child: Text('coordinateForProjectedMeters'),
      onPressed: () {
        mapboxMap?.projection
            .coordinateForProjectedMeters(
                ProjectedMeters(northing: 1.0, easting: 1.0))
            .then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("coordinates: ${value.coordinates}"),
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: Duration(seconds: 2),
                    )));
      },
    );
  }

  Widget _unproject() {
    return TextButton(
      child: Text('unproject'),
      onPressed: () {
        mapboxMap?.projection
            .unproject(MercatorCoordinate(x: 1.0, y: 1.0), 16)
            .then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("coordinates: ${value.coordinates}"),
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: Duration(seconds: 2),
                    )));
      },
    );
  }

  Widget _project() {
    return TextButton(
      child: Text('project'),
      onPressed: () {
        mapboxMap?.projection
            .project(
                Point(
                    coordinates: Position(
                  1.0,
                  60,
                )),
                16)
            .then((value) =>
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text("mercatorCoordinate.x: ${value.x}, y: ${value.y}"),
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
        _getMetersPerPixelAtLatitude(),
        _projectedMetersForCoordinate(),
        _coordinateForProjectedMeters(),
        _unproject(),
        _project()
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
