import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'example.dart';

class CustomHeaderExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.network_check);
  @override
  final String title = 'Custom Header Example';
  @override
  final String? subtitle = null;

  @override
  State<StatefulWidget> createState() => CustomHeaderExampleState();
}

class CustomHeaderExampleState extends State<CustomHeaderExample> {
  CustomHeaderExampleState();

  MapboxMap? mapboxMap;
  var mapProject = StyleProjectionName.globe;
  var locale = 'en';

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.setCustomHeaders({'Authorization': 'Bearer your_access_token'});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mapboxMap?.setCustomHeaders({});
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
      onResourceRequestListener: (request) {
        return null;
      },
    );

    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.addAll(
      <Widget>[],
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
      ],
    );
  }
}
