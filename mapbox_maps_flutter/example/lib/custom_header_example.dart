import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class CustomHeaderExample extends StatefulWidget {
  const CustomHeaderExample({super.key});

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
    // Attach headers only to the host that needs them. Scoping to a host keeps
    // the headers from being sent to the other (including third-party) hosts
    // the map fetches styles, sources, sprites, glyphs or tiles from.
    mapboxMap.httpService.setCustomHeadersForHost(
      'tiles.example.com',
      {'X-Custom-Header': 'value'},
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mapboxMap?.httpService.clearCustomHeaders();
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

    listViewChildren.addAll(<Widget>[]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 400,
            child: mapWidget,
          ),
        ),
      ],
    );
  }
}
