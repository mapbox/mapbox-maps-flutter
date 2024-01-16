import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_example/page.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class RouteLinePage extends ExamplePage {
  RouteLinePage() : super(const Icon(Icons.route), 'Route line');

  @override
  Widget build(BuildContext context) {
    return const RouteLinePageBody();
  }
}

class RouteLinePageBody extends StatefulWidget {
  const RouteLinePageBody();

  @override
  State<StatefulWidget> createState() => RouteLinePageBodyState();
}

enum RouteLinePageBodyStateFeaturePriority { lines, markers }

extension Next on RouteLinePageBodyStateFeaturePriority {
  RouteLinePageBodyStateFeaturePriority next() {
    switch (this) {
      case RouteLinePageBodyStateFeaturePriority.lines:
        return RouteLinePageBodyStateFeaturePriority.markers;
      case RouteLinePageBodyStateFeaturePriority.markers:
        return RouteLinePageBodyStateFeaturePriority.lines;
    }
  }
}

class RouteLinePageBodyState extends State<RouteLinePageBody>
    implements
        OnPointAnnotationClickListener,
        OnPolylineAnnotationClickListener {
  late MapboxMap _mapboxMap;
  late List<List<Position>> _positions;
  List<BaseAnnotationManager> _annotationManagers = [];
  RouteLinePageBodyStateFeaturePriority _priority =
      RouteLinePageBodyStateFeaturePriority.lines;

  void _reset() {
    for (var manager in _annotationManagers) {
      _mapboxMap.annotations.removeAnnotationManager(manager);
    }

    switch (_priority) {
      case RouteLinePageBodyStateFeaturePriority.lines:
        _setupMarkers();
        _setupRouteLines();
        break;
      case RouteLinePageBodyStateFeaturePriority.markers:
        _setupRouteLines();
        _setupMarkers();
        break;
    }
  }

  void _onStyleLoaded() {
    _mapboxMap.style
        .setProjection(StyleProjection(name: StyleProjectionName.mercator));
    _generatePositions();
    _reset();
  }

  _generatePositions() {
    final positions = <List<Position>>[];
    for (int i = 0; i < 10; i++) {
      positions.add(createRandomPositionList());
    }
    _positions = positions;
  }

  Position createRandomPosition() {
    var random = Random();
    return Position(random.nextDouble() * -360.0 + 180.0,
        random.nextDouble() * -180.0 + 90.0);
  }

  List<Position> createRandomPositionList() {
    var random = Random();
    final positions = <Position>[];
    for (int i = 0; i < random.nextInt(6) + 4; i++) {
      positions.add(createRandomPosition());
    }

    return positions;
  }

  _setupRouteLines() async {
    final manager =
        await _mapboxMap.annotations.createPolylineAnnotationManager();
    await manager.createMulti(_positions
        .map((e) => PolylineAnnotationOptions(
            geometry: LineString(coordinates: e).toJson(),
            lineColor: Colors.red.value,
            lineWidth: 10))
        .toList());
    manager.addOnPolylineAnnotationClickListener(this);
  }

  _setupMarkers() async {
    final manager = await _mapboxMap.annotations.createPointAnnotationManager();
    final ByteData bytes =
        await rootBundle.load('assets/symbols/2.0x/custom-icon.png');
    final Uint8List list = bytes.buffer.asUint8List();
    await manager.createMulti(_positions
        .expand((element) => element)
        .map((e) => PointAnnotationOptions(
            geometry: Point(coordinates: e).toJson(), image: list))
        .toList());
    manager.addOnPointAnnotationClickListener(this);
  }

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    print("onPointAnnotationClick, id: ${annotation.id}");
  }

  @override
  void onPolylineAnnotationClick(PolylineAnnotation annotation) {
    print("onPolylineAnnotationClick, id: ${annotation.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        MapWidget(
          key: ValueKey("mapWidget"),
          styleUri: MapboxStyles.MAPBOX_STREETS,
          onMapCreated: (controller) => _mapboxMap = controller,
          onStyleLoadedListener: (_) => _onStyleLoaded(),
        ),
        CupertinoSlidingSegmentedControl(
          backgroundColor: CupertinoColors.secondarySystemBackground,
          children: HashMap.fromEntries(RouteLinePageBodyStateFeaturePriority
              .values
              .map((e) => MapEntry(e, Text(e.name)))),
          groupValue: _priority,
          onValueChanged: (value) {
            setState(() {
              _priority = _priority.next();
              _reset();
            });
          },
        )
      ],
    );
  }
}
