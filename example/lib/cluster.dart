import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'main.dart';
import 'page.dart';

class StyleClustersPage extends ExamplePage {
  StyleClustersPage() : super(const Icon(Icons.map), 'StyleClusters');

  @override
  Widget build(BuildContext context) {
    return const StyleClustersPageBody();
  }
}

class StyleClustersPageBody extends StatefulWidget {
  const StyleClustersPageBody();

  @override
  State<StatefulWidget> createState() => StyleClustersPageBodyState();
}

class StyleClustersPageBodyState extends State<StyleClustersPageBody> {
  StyleClustersPageBodyState();

  MapboxMap? mapboxMap;

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
    mapboxMap?.style.styleSourceExists("earthquakes").then((value) async {
      if (!value) {
        var source =
            await rootBundle.loadString('assets/cluster/cluster_source.json');
        mapboxMap?.style.addStyleSource("earthquakes", source);
      }
    });

    mapboxMap?.style.styleLayerExists("clusters").then((value) async {
      if (!value) {
        // Use step expressions (https://docs.mapbox.com/mapbox-gl-js/style-spec/#expressions-step)
        // with three steps to implement three types of circles:
        //   * Blue, 20px circles when point count is less than 100
        //   * Yellow, 30px circles when point count is between 100 and 750
        //   * Pink, 40px circles when point count is greater than or equal to 750
        var layer =
            await rootBundle.loadString('assets/cluster/cluster_layer.json');
        mapboxMap?.style.addStyleLayer(layer, null);

        var clusterCountLayer = await rootBundle
            .loadString('assets/cluster/cluster_count_layer.json');
        mapboxMap?.style.addStyleLayer(clusterCountLayer, null);

        var unclusteredLayer = await rootBundle
            .loadString('assets/cluster/unclustered_point_layer.json');
        mapboxMap?.style.addStyleLayer(unclusteredLayer, null);
      }
    });
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
            ?.queryRenderedFeatures(renderedQueryGeometry,
                RenderedQueryOptions(layerIds: ['clusters'], filter: null))
            .then((value) =>
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('queryRenderedFeatures size: ${value.length}'),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  var feature = {
    "id": 1249,
    "properties": {
      "point_count_abbreviated": "10",
      "cluster_id": 1249,
      "cluster": true,
      "point_count": 10
    },
    "geometry": {
      "type": "Point",
      "coordinates": [-29.794921875, 59.220934076150456]
    },
    "type": "Feature"
  };

  Widget _getGeoJsonClusterLeaves() {
    return TextButton(
      child: Text('getGeoJsonClusterLeaves'),
      onPressed: () {
        mapboxMap
            ?.getGeoJsonClusterLeaves('earthquakes', feature, null, null)
            .then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Value: ${value.value}, feature collection size: ${value.featureCollection?.length}'),
                      backgroundColor: Theme.of(context).primaryColor,
                      duration: Duration(seconds: 2),
                    )));
      },
    );
  }

  Widget _getGeoJsonClusterChildren() {
    return TextButton(
      child: Text('getGeoJsonClusterChildren'),
      onPressed: () {
        mapboxMap?.getGeoJsonClusterChildren('earthquakes', feature).then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Value: ${value.value}, feature collection size: ${value.featureCollection?.length}'),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _getGeoJsonClusterExpansionZoom() {
    return TextButton(
      child: Text('getGeoJsonClusterExpansionZoom'),
      onPressed: () {
        mapboxMap?.getGeoJsonClusterExpansionZoom('earthquakes', feature).then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Value: ${value.value}, feature collection size: ${value.featureCollection?.length}'),
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
        _getGeoJsonClusterLeaves(),
        _getGeoJsonClusterChildren(),
        _getGeoJsonClusterExpansionZoom()
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
