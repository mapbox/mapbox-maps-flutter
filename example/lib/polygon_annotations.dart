import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/utils.dart';
import 'package:turf/helpers.dart';

import 'main.dart';
import 'page.dart';

class PolygonAnnotationPage extends ExamplePage {
  PolygonAnnotationPage() : super(const Icon(Icons.map), 'Polygon Annotations');

  @override
  Widget build(BuildContext context) {
    return const PolygonAnnotationPageBody();
  }
}

class PolygonAnnotationPageBody extends StatefulWidget {
  const PolygonAnnotationPageBody();

  @override
  State<StatefulWidget> createState() => PolygonAnnotationPageBodyState();
}

class AnnotationClickListener extends OnPolygonAnnotationClickListener {
  @override
  void onPolygonAnnotationClick(PolygonAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.id}");
  }
}

class PolygonAnnotationPageBodyState extends State<PolygonAnnotationPageBody> {
  PolygonAnnotationPageBodyState();

  MapboxMap? mapboxMap;
  PolygonAnnotation? polygonAnnotation;
  PolygonAnnotationManager? polygonAnnotationManager;
  int styleIndex = 1;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.annotations.createPolygonAnnotationManager().then((value) {
      polygonAnnotationManager = value;
      createOneAnnotation();
      var options = <PolygonAnnotationOptions>[];
      for (var i = 0; i < 2; i++) {
        options.add(PolygonAnnotationOptions(
            geometry:
                Polygon(coordinates: createRandomPositionsList()).toJson(),
            fillColor: createRandomColor()));
      }
      polygonAnnotationManager?.createMulti(options);
      polygonAnnotationManager
          ?.addOnPolygonAnnotationClickListener(AnnotationClickListener());
    });
  }

  void createOneAnnotation() {
    polygonAnnotationManager
        ?.create(PolygonAnnotationOptions(
            geometry: Polygon(coordinates: [
              [
                Position(-3.363937, -10.733102),
                Position(1.754703, -19.716317),
                Position(-15.747196, -21.085074),
                Position(-3.363937, -10.733102)
              ]
            ]).toJson(),
            fillColor: Colors.red.value,
            fillOutlineColor: Colors.purple.value))
        .then((value) => polygonAnnotation = value);
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
      child: Text('update a polygon annotation'),
      onPressed: () {
        if (polygonAnnotation != null) {
          var polygon = Polygon.fromJson((polygonAnnotation!.geometry)!.cast());
          var newPolygon = Polygon(
              coordinates: polygon.coordinates
                  .map((e) =>
                      e.map((e) => Position(e.lng + 1.0, e.lat + 1.0)).toList())
                  .toList());
          polygonAnnotation?.geometry = newPolygon.toJson();
          polygonAnnotationManager?.update(polygonAnnotation!);
        }
      },
    );
  }

  Widget _create() {
    return TextButton(
      child: Text('create a polygon annotation'),
      onPressed: () {
        createOneAnnotation();
      },
    );
  }

  Widget _delete() {
    return TextButton(
      child: Text('delete a polygon annotation'),
      onPressed: () {
        if (polygonAnnotation != null) {
          polygonAnnotationManager?.delete(polygonAnnotation!);
        }
      },
    );
  }

  Widget _deleteAll() {
    return TextButton(
      child: Text('delete all polygon annotations'),
      onPressed: () {
        polygonAnnotationManager?.deleteAll();
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
                    if (polygonAnnotationManager != null) {
                      mapboxMap?.annotations
                          .removeAnnotationManager(polygonAnnotationManager!);
                      polygonAnnotationManager = null;
                    }
                  }),
            ],
          ),
        ),
        body: colmn);
  }
}
