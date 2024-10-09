import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'example.dart';

class MapInterfaceExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'MapInterface';

  @override
  State<StatefulWidget> createState() => MapInterfaceExampleState();
}

class MapInterfaceExampleState extends State<MapInterfaceExample> {
  MapInterfaceExampleState();

  MapboxMap? mapboxMap;

  var gestureInProgress = true;
  var userAnimationInProgress = true;
  var showTileBorders = false;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    _addLayerAndSource();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addLayerAndSource() async {
    mapboxMap?.style.styleSourceExists("source").then((value) async {
      if (!value) {
        var source = await rootBundle.loadString('assets/source.json');
        mapboxMap?.style.addStyleSource("source", source);
      }
    });
    // mapboxMap?.style.styleLayerExists("custom").then((value) async {
    //   if (!value) {
    //     var layer = await rootBundle.loadString('assets/layer.json');
    //     mapboxMap?.style.addStyleLayer(layer, null);
    //   }
    // });
    mapboxMap?.style.styleLayerExists("points").then((value) async {
      if (!value) {
        var layer = await rootBundle.loadString('assets/point_layer.json');
        mapboxMap?.style.addStyleLayer(layer, null);
      }
    });
  }

  Widget _getSize() {
    return TextButton(
      child: Text('getSize'),
      onPressed: () {
        mapboxMap?.getSize().then((value) =>
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("width: ${value.width},height: ${value.height}"),
              backgroundColor: Theme.of(context).primaryColor,
              duration: Duration(seconds: 2),
            )));
      },
    );
  }

  Widget _triggerRepaint() {
    return TextButton(
      child: Text('triggerRepaint'),
      onPressed: () {
        mapboxMap?.triggerRepaint();
      },
    );
  }

  Widget _setFeatureState() {
    return TextButton(
      child: Text('setFeatureState'),
      onPressed: () {
        mapboxMap?.setFeatureState(
            'source', 'custom', 'point', json.encode({'choose': true}));
      },
    );
  }

  Widget _getFeatureState() {
    return TextButton(
      child: Text('getFeatureState'),
      onPressed: () {
        mapboxMap?.getFeatureState('source', 'custom', 'point').then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("FeatureState: ${value}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _setGestureInProgress() {
    return TextButton(
        child: Text('setGestureInProgress'),
        onPressed: () {
          mapboxMap?.setGestureInProgress(gestureInProgress);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("SetGestureInProgress : $gestureInProgress"),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 2),
          ));
          gestureInProgress = !gestureInProgress;
        });
  }

  Widget _getGestureInProgress() {
    return TextButton(
      child: Text('getGestureInProgress'),
      onPressed: () {
        mapboxMap?.isGestureInProgress().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("isGestureInProgress: ${value}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _setUserAnimationInProgress() {
    return TextButton(
        child: Text('setUserAnimationInProgress'),
        onPressed: () {
          mapboxMap?.setUserAnimationInProgress(userAnimationInProgress);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("SetGestureInProgress : $userAnimationInProgress"),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 2),
          ));
          userAnimationInProgress = !userAnimationInProgress;
        });
  }

  Widget _getUserAnimationInProgress() {
    return TextButton(
      child: Text('getUserAnimationInProgress'),
      onPressed: () {
        mapboxMap?.isUserAnimationInProgress().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("isUserAnimationInProgress: ${value}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _setPrefetchZoomDelta() {
    return TextButton(
        child: Text('setPrefetchZoomDelta'),
        onPressed: () {
          mapboxMap?.setPrefetchZoomDelta(10);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("setPrefetchZoomDelta to 10"),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 2),
          ));
        });
  }

  Widget _getPrefetchZoomDelta() {
    return TextButton(
      child: Text('getPrefetchZoomDelta'),
      onPressed: () {
        mapboxMap?.getPrefetchZoomDelta().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("getPrefetchZoomDelta: ${value}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _getMapOptions() {
    return TextButton(
      child: Text('getMapOptions'),
      onPressed: () {
        mapboxMap?.getMapOptions().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Size: ${value.size?.width}-${value.size?.height}, constrainMode: ${value.constrainMode}, orientation: ${value.orientation}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _getResourceOptions() {
    return TextButton(
      child: Text('getResourceOptions'),
      onPressed: () async {
        String baseUrl = await MapboxMapsOptions.getBaseUrl();
        String accessToken = await MapboxOptions.getAccessToken();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("baseURL: ${baseUrl}, accessToken: ${accessToken}"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        ));
      },
    );
  }

  Widget _reduceMemoryUse() {
    return TextButton(
      child: Text('reduceMemoryUse'),
      onPressed: () {
        mapboxMap?.reduceMemoryUse().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("reduceMemoryUse"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _queryRenderedFeatures() {
    return TextButton(
      child: Text('queryRenderedFeatures'),
      onPressed: () {
        final screenBox = ScreenBox(
            min: ScreenCoordinate(x: 0.0, y: 0.0),
            max: ScreenCoordinate(x: 150.0, y: 510.0));
        final renderedQueryGeometry =
            RenderedQueryGeometry.fromScreenBox(screenBox);
        mapboxMap
            ?.queryRenderedFeatures(
                renderedQueryGeometry,
                RenderedQueryOptions(
                    layerIds: ['custom', 'points'], filter: null))
            .then((value) =>
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("queryRenderedFeatures size: ${value.length}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _querySourceFeatures() {
    return TextButton(
      child: Text('querySourceFeatures'),
      onPressed: () {
        mapboxMap
            ?.querySourceFeatures('source', SourceQueryOptions(filter: ''))
            .then((value) =>
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("queryRenderedFeatures size: ${value.length}"),
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
        _queryRenderedFeatures(),
        _querySourceFeatures(),
        _getSize(),
        _getMapOptions(),
        _getResourceOptions(),
        _reduceMemoryUse(),
        _getGestureInProgress(),
        _setGestureInProgress(),
        _getUserAnimationInProgress(),
        _setUserAnimationInProgress(),
        _getPrefetchZoomDelta(),
        _setPrefetchZoomDelta(),
        _triggerRepaint(),
        _setFeatureState(),
        _getFeatureState()
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
