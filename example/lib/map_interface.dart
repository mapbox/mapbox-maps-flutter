import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'main.dart';
import 'page.dart';

class MapInterfacePage extends ExamplePage {
  MapInterfacePage() : super(const Icon(Icons.map), 'MapInterface');

  @override
  Widget build(BuildContext context) {
    return const MapInterfacePageBody();
  }
}

class MapInterfacePageBody extends StatefulWidget {
  const MapInterfacePageBody();

  @override
  State<StatefulWidget> createState() => MapInterfacePageBodyState();
}

class MapInterfacePageBodyState extends State<MapInterfacePageBody> {
  MapInterfacePageBodyState();

  MapboxMap? mapboxMap;

  var gestureInProgress = true;
  var userAnimationInProgress = true;
  var showTileBorders = true;

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

  Widget _setDebugOptions() {
    return TextButton(
        child: Text('setDebugOptions'),
        onPressed: () {
          mapboxMap?.setDebug(
              [MapDebugOptions(data: MapDebugOptionsData.TILE_BORDERS)],
              showTileBorders);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("showTileBorders : $showTileBorders"),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 2),
          ));
          showTileBorders = !showTileBorders;
        });
  }

  Widget _getDebugOptions() {
    return TextButton(
      child: Text('getDebugOptions'),
      onPressed: () {
        mapboxMap?.getDebug().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("getDebugOptions: ${value.first}"),
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
                      "Size: ${value.size?.width}-${value.size?.height},constrainMode: ${value.constrainMode},orientation: ${value.orientation}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _getResourceOptions() {
    return TextButton(
      child: Text('getResourceOptions'),
      onPressed: () {
        mapboxMap?.getResourceOptions().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "baseURL: ${value.baseURL}, accessToken: ${value.accessToken}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
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
        var screenBox = ScreenBox(
            min: ScreenCoordinate(x: 0.0, y: 0.0),
            max: ScreenCoordinate(x: 150.0, y: 510.0));
        var renderedQueryGeometry = RenderedQueryGeometry(
            value: json.encode(screenBox.encode()), type: Type.SCREEN_BOX);
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
    final MapWidget mapWidget = MapWidget(
        key: ValueKey("mapWidget"),
        resourceOptions: ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
        onMapCreated: _onMapCreated);

    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.addAll(
      <Widget>[
        _queryRenderedFeatures(),
        _querySourceFeatures(),
        _getSize(),
        _getMapOptions(),
        _getResourceOptions(),
        _setDebugOptions(),
        _getDebugOptions(),
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
