import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class SimpleMapPage extends StatelessWidget {
  const SimpleMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Map View'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: MapWidget(),
    );
  }
}
