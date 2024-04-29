import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/utils.dart';

import 'page.dart';

class PointAnnotationPage extends ExamplePage {
  PointAnnotationPage() : super(const Icon(Icons.map), 'Point Annotations');

  @override
  Widget build(BuildContext context) {
    return const PointAnnotationPageBody();
  }
}

class PointAnnotationPageBody extends StatefulWidget {
  const PointAnnotationPageBody();

  @override
  State<StatefulWidget> createState() => PointAnnotationPageBodyState();
}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.id}");
  }
}

class PointAnnotationPageBodyState extends State<PointAnnotationPageBody> {
  PointAnnotationPageBodyState();

  MapboxMap? mapboxMap;
  PointAnnotation? pointAnnotation;
  PointAnnotationManager? pointAnnotationManager;
  int styleIndex = 1;
  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.setCamera(CameraOptions(
        center: Point(coordinates: Position(0, 0)), zoom: 1, pitch: 0));
    mapboxMap.annotations.createPointAnnotationManager().then((value) async {
      pointAnnotationManager = value;
      final ByteData bytes =
          await rootBundle.load('assets/symbols/custom-icon.png');
      final Uint8List list = bytes.buffer.asUint8List();
      createOneAnnotation(list);
      var options = <PointAnnotationOptions>[];
      for (var i = 0; i < 5; i++) {
        options.add(PointAnnotationOptions(
            geometry: createRandomPoint().toJson(), image: list));
      }
      pointAnnotationManager?.createMulti(options);

      var carOptions = <PointAnnotationOptions>[];
      for (var i = 0; i < 20; i++) {
        carOptions.add(PointAnnotationOptions(
            geometry: createRandomPoint().toJson(), iconImage: "car-15"));
      }
      pointAnnotationManager?.createMulti(carOptions);
      pointAnnotationManager
          ?.addOnPointAnnotationClickListener(AnnotationClickListener());
    });
  }

  void createOneAnnotation(Uint8List list) {
    pointAnnotationManager
        ?.create(PointAnnotationOptions(
            geometry: Point(
                coordinates: Position(
              0.381457,
              6.687337,
            )).toJson(),
            textField: "custom-icon",
            textOffset: [0.0, -2.0],
            textColor: Colors.red.value,
            iconSize: 1.3,
            iconOffset: [0.0, -5.0],
            symbolSortKey: 10,
            image: list))
        .then((value) => pointAnnotation = value);
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
      child: Text('update a point annotation'),
      onPressed: () {
        if (pointAnnotation != null) {
          var point = Point.fromJson((pointAnnotation!.geometry)!.cast());
          var newPoint = Point(
              coordinates: Position(
                  point.coordinates.lng + 1.0, point.coordinates.lat + 1.0));
          pointAnnotation?.geometry = newPoint.toJson();
          pointAnnotationManager?.update(pointAnnotation!);
        }
      },
    );
  }

  Widget _create() {
    return TextButton(
        child: Text('create a point annotation'),
        onPressed: () async {
          final ByteData bytes =
              await rootBundle.load('assets/symbols/custom-icon.png');
          final Uint8List list = bytes.buffer.asUint8List();
          createOneAnnotation(list);
        });
  }

  Widget _delete() {
    return TextButton(
      child: Text('delete a point annotation'),
      onPressed: () {
        if (pointAnnotation != null) {
          pointAnnotationManager?.delete(pointAnnotation!);
        }
      },
    );
  }

  Widget _deleteAll() {
    return TextButton(
      child: Text('delete all point annotations'),
      onPressed: () {
        pointAnnotationManager?.deleteAll();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget =
        MapWidget(key: ValueKey("mapWidget"), onMapCreated: _onMapCreated);

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
                    if (pointAnnotationManager != null) {
                      mapboxMap?.annotations
                          .removeAnnotationManager(pointAnnotationManager!);
                      pointAnnotationManager = null;
                    }
                  }),
            ],
          ),
        ),
        body: colmn);
  }
}
