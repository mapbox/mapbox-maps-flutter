import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/animated_route.dart';
import 'package:mapbox_maps_example/animation.dart';
import 'package:mapbox_maps_example/camera.dart';
import 'package:mapbox_maps_example/circle_annotations.dart';
import 'package:mapbox_maps_example/cluster.dart';
import 'package:mapbox_maps_example/ornaments.dart';
import 'package:mapbox_maps_example/geojson_line.dart';
import 'package:mapbox_maps_example/image_source.dart';
import 'package:mapbox_maps_example/map_interface.dart';
import 'package:mapbox_maps_example/polygon_annotations.dart';
import 'package:mapbox_maps_example/polyline_annotations.dart';
import 'package:mapbox_maps_example/tile_json.dart';
import 'package:mapbox_maps_example/vector_tile_source.dart';

import 'full_map.dart';
import 'location.dart';
import 'page.dart';
import 'point_annotations.dart';
import 'projection.dart';
import 'style.dart';
import 'gestures.dart';

final List<ExamplePage> _allPages = <ExamplePage>[
  FullMapPage(),
  StylePage(),
  CameraPage(),
  ProjectionPage(),
  MapInterfacePage(),
  StyleClustersPage(),
  AnimationPage(),
  PointAnnotationPage(),
  CircleAnnotationPage(),
  PolylineAnnotationPage(),
  PolygonAnnotationPage(),
  VectorTileSourcePage(),
  DrawGeoJsonLinePage(),
  ImageSourcePage(),
  TileJsonPage(),
  LocationPage(),
  GesturesPage(),
  OrnamentsPage(),
  AnimatedRoutePage(),
];

class MapsDemo extends StatelessWidget {
  // FIXME: You need to pass in your access token via the command line argument
  // --dart-define=ACCESS_TOKEN=ADD_YOUR_TOKEN_HERE
  // It is also possible to pass it in while running the app via an IDE by
  // passing the same args there.
  //
  // Alternatively you can replace `String.fromEnvironment("ACCESS_TOKEN")`
  // in the following line with your access token directly.
  static const String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");

  void _pushPage(BuildContext context, ExamplePage page) async {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MapboxMaps examples')),
      body: ACCESS_TOKEN.isEmpty || ACCESS_TOKEN.contains("YOUR_TOKEN")
          ? buildAccessTokenWarning()
          : ListView.separated(
              itemCount: _allPages.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 1),
              itemBuilder: (_, int index) => ListTile(
                leading: _allPages[index].leading,
                title: Text(_allPages[index].title),
                onTap: () => _pushPage(context, _allPages[index]),
              ),
            ),
    );
  }

  Widget buildAccessTokenWarning() {
    return Container(
      color: Colors.red[900],
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Please pass in your access token with",
            "--dart-define=ACCESS_TOKEN=ADD_YOUR_TOKEN_HERE",
            "passed into flutter run or add it to args in vscode's launch.json",
          ]
              .map((text) => Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MapsDemo()));
}
