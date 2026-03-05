import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _mapboxMapsFlutterWebPlugin = MapboxMapsFlutterWeb();

  @override
  void initState() {
    super.initState();
    _mapboxMapsFlutterWebPlugin.setAccessToken(
      const String.fromEnvironment('ACCESS_TOKEN'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Mapbox Maps Web Example')),
        body: _mapboxMapsFlutterWebPlugin.buildView(),
      ),
    );
  }
}
