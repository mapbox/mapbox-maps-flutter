import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter_v3/mapbox_maps_flutter_v3.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const String ACCESS_TOKEN = String.fromEnvironment(
    "MAPBOX_ACCESS_TOKEN",
  );

  @override
  void initState() {
    super.initState();
    MapboxOptions.setAccessToken(ACCESS_TOKEN);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example app')),
        body: Center(child: MapWidget()),
      ),
    );
  }
}
