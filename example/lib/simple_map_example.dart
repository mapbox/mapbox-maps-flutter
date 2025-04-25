import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';
import 'package:mapbox_maps_flutter_support/map_registry.dart';
import 'package:mapbox_maps_flutter_support/camera_options.dart' as native;
import 'package:mapbox_maps_flutter_support/map.dart' as native;
import 'package:mapbox_flutter_foundation/context.dart' as foundation;

class SimpleMapExample extends StatefulWidget implements Example {
  const SimpleMapExample({super.key});

  @override
  final Widget leading = const Icon(Icons.map_outlined);
  @override
  final String title = 'Display a simple map';
  @override
  final String subtitle =
      'Create and display a map that uses the default Mapbox Standard style.';

  @override
  State<StatefulWidget> createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMapExample> {
  late MapRegistry _mapRegistry;
  native.Map? _nativeMap;

  _SimpleMapState() {
    foundation.Context.init('/Users/romanlaitarenko/Developer/mapbox-maps-flutter-internal/build/Debug-iphonesimulator/MapboxMapsFlutter.framework/MapboxMapsFlutter');
    _mapRegistry = MapRegistry();
  }

  void _onStyleLoaded(StyleLoadedEventData event) {
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MapWidget(
            styleUri: MapboxStyles.STANDARD,
            onStyleLoadedListener: _onStyleLoaded,
          ),
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              print("fooo: Retrieveing the map");

              _nativeMap = _mapRegistry.retrieve("123");
              print("fooo: Map retrieved: $_nativeMap");
              if (_nativeMap == null) {
                print("fooo: Map not found");
                return;
              }
              _nativeMap?.setCamera(native.CameraOptions(
                center: Position(-117.918976, 33.812092),
                zoom: 15.0,
              ));
            },
            child: const Text('Call FFI setCamera'),
          ),
        ),
      ],
    );
  }
}
