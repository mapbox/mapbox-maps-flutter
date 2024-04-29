import 'package:flutter/material.dart' hide Visibility;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/utils.dart';
import 'page.dart';

class CircleAnnotationPage extends ExamplePage {
  CircleAnnotationPage() : super(const Icon(Icons.map), 'Circle Annotations');

  @override
  Widget build(BuildContext context) {
    return const CircleAnnotationPageBody();
  }
}

class CircleAnnotationPageBody extends StatefulWidget {
  const CircleAnnotationPageBody();

  @override
  State<StatefulWidget> createState() => CircleAnnotationPageBodyState();
}

class AnnotationClickListener extends OnCircleAnnotationClickListener {
  @override
  void onCircleAnnotationClick(CircleAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.id}");
  }
}

class CircleAnnotationPageBodyState extends State<CircleAnnotationPageBody> {
  CircleAnnotationPageBodyState();

  MapboxMap? mapboxMap;
  CircleAnnotation? circleAnnotation;
  CircleAnnotationManager? circleAnnotationManager;
  int styleIndex = 1;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.setCamera(CameraOptions(
        center: Point(coordinates: Position(0, 0)), zoom: 1, pitch: 0));
    mapboxMap.annotations.createCircleAnnotationManager().then((value) {
      circleAnnotationManager = value;
      createOneAnnotation();

      var options = <CircleAnnotationOptions>[];
      for (var i = 0; i < 2000; i++) {
        options.add(CircleAnnotationOptions(
            geometry: createRandomPoint().toJson(),
            circleColor: createRandomColor(),
            circleRadius: 8.0));
      }
      circleAnnotationManager?.createMulti(options);
      circleAnnotationManager
          ?.addOnCircleAnnotationClickListener(AnnotationClickListener());
    });
  }

  void createOneAnnotation() {
    circleAnnotationManager?.create(CircleAnnotationOptions(
      geometry: Point(
          coordinates: Position(
        0.381457,
        6.687337,
      )).toJson(),
      circleColor: Colors.yellow.value,
      circleRadius: 12.0,
    ));
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
      child: Text('update a circle annotation'),
      onPressed: () {
        if (circleAnnotation != null) {
          var point = Point.fromJson((circleAnnotation!.geometry)!.cast());
          var newPoint = Point(
              coordinates: Position(
                  point.coordinates.lng + 1.0, point.coordinates.lat + 1.0));
          circleAnnotation?.geometry = newPoint.toJson();
          circleAnnotationManager?.update(circleAnnotation!);
        }
      },
    );
  }

  Widget _create() {
    return TextButton(
      child: Text('create a circle annotation'),
      onPressed: () async {
        createOneAnnotation();
      },
    );
  }

  Widget _delete() {
    return TextButton(
        child: Text('delete a circle annotation'),
        onPressed: () async {
          if (circleAnnotation != null) {
            circleAnnotationManager?.delete(circleAnnotation!);
          }
        });
  }

  Widget _deleteAll() {
    return TextButton(
      child: Text('delete all circle annotations'),
      onPressed: () {
        circleAnnotationManager?.deleteAll();
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
                    if (circleAnnotationManager != null) {
                      mapboxMap?.annotations
                          .removeAnnotationManager(circleAnnotationManager!);
                      circleAnnotationManager = null;
                    }
                  }),
            ],
          ),
        ),
        body: colmn);
  }
}
