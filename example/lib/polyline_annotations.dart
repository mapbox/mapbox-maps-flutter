import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/utils.dart';
import 'package:turf/helpers.dart';

import 'main.dart';
import 'page.dart';

class PolylineAnnotationPage extends ExamplePage {
  PolylineAnnotationPage()
      : super(const Icon(Icons.map), 'Polyline Annotations');

  @override
  Widget build(BuildContext context) {
    return const PolylineAnnotationPageBody();
  }
}

class AnnotationClickListener extends OnPolylineAnnotationClickListener {
  @override
  void onPolylineAnnotationClick(PolylineAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.id}");
  }
}

class PolylineAnnotationPageBody extends StatefulWidget {
  const PolylineAnnotationPageBody();

  @override
  State<StatefulWidget> createState() => PolylineAnnotationPageBodyState();
}

class PolylineAnnotationPageBodyState
    extends State<PolylineAnnotationPageBody> {
  PolylineAnnotationPageBodyState();

  MapboxMap? mapboxMap;
  PolylineAnnotation? polylineAnnotation;
  PolylineAnnotationManager? polylineAnnotationManager;
  int styleIndex = 1;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.annotations.createPolylineAnnotationManager().then((value) {
      polylineAnnotationManager = value;
      createOneAnnotation();
      final positions = <List<Position>>[];
      for (int i = 0; i < 99; i++) {
        positions.add(createRandomPositionList());
      }

      polylineAnnotationManager?.createMulti(positions
          .map((e) => PolylineAnnotationOptions(
              geometry: LineString(coordinates: e).toJson(),
              lineColor: createRandomColor()))
          .toList());
      polylineAnnotationManager
          ?.addOnPolylineAnnotationClickListener(AnnotationClickListener());
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _update() {
    return TextButton(
      child: Text('update a polyline annotation'),
      onPressed: () {
        if (polylineAnnotation != null) {
          var lineString =
              LineString.fromJson((polylineAnnotation!.geometry)!.cast());
          var newlineString = LineString(
              coordinates: lineString.coordinates
                  .map((e) => Position(e.lng + 1.0, e.lat + 1.0))
                  .toList());
          polylineAnnotation?.geometry = newlineString.toJson();
          polylineAnnotationManager?.update(polylineAnnotation!);
        }
      },
    );
  }

  Widget _create() {
    return TextButton(
      child: Text('create a polyline annotation'),
      onPressed: () {
        createOneAnnotation();
      },
    );
  }

  void createOneAnnotation() {
    polylineAnnotationManager
        ?.create(PolylineAnnotationOptions(
            geometry: LineString(coordinates: [
              Position(
                1.0,
                2.0,
              ),
              Position(
                10.0,
                20.0,
              )
            ]).toJson(),
            lineColor: Colors.red.value,
            lineWidth: 2))
        .then((value) => polylineAnnotation = value);
  }

  Widget _delete() {
    return TextButton(
      child: Text('delete a polyline annotation'),
      onPressed: () {
        if (polylineAnnotation != null) {
          polylineAnnotationManager?.delete(polylineAnnotation!);
        }
      },
    );
  }

  Widget _deleteAll() {
    return TextButton(
      child: Text('delete all polyline annotations'),
      onPressed: () {
        polylineAnnotationManager?.deleteAll();
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
      <Widget>[_create(), _update(), _delete(), _deleteAll()],
    );

    final colmn = Column(
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

    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                  child: Icon(Icons.swap_horiz),
                  heroTag: null,
                  onPressed: () {
                    mapboxMap?.style.setStyleURI(annotationStyles[
                        ++styleIndex % annotationStyles.length]);
                  }),
              SizedBox(height: 10),
              FloatingActionButton(
                  child: Icon(Icons.clear),
                  heroTag: null,
                  onPressed: () {
                    if (polylineAnnotationManager != null) {
                      mapboxMap?.annotations
                          .removeAnnotationManager(polylineAnnotationManager!);
                      polylineAnnotationManager = null;
                    }
                  }),
            ],
          ),
        ),
        body: colmn);
  }
}
