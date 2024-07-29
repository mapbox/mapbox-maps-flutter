import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'page.dart';

class DebugOptionsPage extends ExamplePage {
  DebugOptionsPage()
      : super(const Icon(Icons.construction), 'Map debug options');

  @override
  Widget build(BuildContext context) {
    return const DebugOptionsPageBody();
  }
}

class DebugOptionsPageBody extends StatefulWidget {
  const DebugOptionsPageBody();

  @override
  State createState() => DebugOptionsPageBodyState();
}

class DebugOptionsPageBodyState extends State<DebugOptionsPageBody> {
  DebugOptionsPageBodyState();

  MapboxMap? mapboxMap;
  List<MapWidgetDebugOptions> enabledOptions = [];

  _onMapCreated(MapboxMap mapboxMap) async {
    enabledOptions = await mapboxMap.getDebugOptions();
    this.mapboxMap = mapboxMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        key: const ValueKey<String>('mapWidget'),
        onMapCreated: _onMapCreated,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.construction),
        onPressed: () async {
          if (mapboxMap == null) {
            return;
          }
          showModalBottomSheet(
            context: context,
            useSafeArea: true,
            showDragHandle: true,
            builder: (context) {
              return DebugOptionsList(mapboxMap!);
            },
          );
        },
      ),
    );
  }
}

class DebugOptionsList extends StatefulWidget {
  final MapboxMap mapController;
  const DebugOptionsList(this.mapController);

  @override
  State createState() => DebugOptionsListState();
}

class DebugOptionsListState extends State<DebugOptionsList> {
  List<MapWidgetDebugOptions> enabledOptions = [];

  @override
  void initState() {
    super.initState();
    widget.mapController.getDebugOptions().then((value) {
      setState(() {
        enabledOptions = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Debug options",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        Expanded(
          child: ListView(
            children: this
                .allOptions
                .map(
                  (e) => SwitchListTile(
                    title: Text(e.description),
                    value: enabledOptions.contains(e),
                    onChanged: (value) {
                      if (value) {
                        enabledOptions.add(e);
                      } else {
                        enabledOptions.remove(e);
                      }
                      setState(() {
                        widget.mapController.setDebugOptions(enabledOptions);
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

extension on DebugOptionsListState {
  List<MapWidgetDebugOptions> get allOptions {
    final values = [
      MapWidgetDebugOptions.tileBorders,
      MapWidgetDebugOptions.parseStatus,
      MapWidgetDebugOptions.timestamps,
      MapWidgetDebugOptions.collision,
      MapWidgetDebugOptions.overdraw,
      MapWidgetDebugOptions.stencilClip,
      MapWidgetDebugOptions.depthBuffer,
      MapWidgetDebugOptions.modelBounds,
    ];
    if (Platform.isAndroid) {
      values.addAll({
        MapWidgetDebugOptions.terrainWireframe,
        MapWidgetDebugOptions.layers2DWireframe,
        MapWidgetDebugOptions.layers3DWireframe,
      });
    }
    values.addAll({
      MapWidgetDebugOptions.light,
      MapWidgetDebugOptions.camera,
      MapWidgetDebugOptions.padding,
    });
    return values;
  }
}

extension on MapWidgetDebugOptions {
  String get description {
    switch (this) {
      case MapWidgetDebugOptions.tileBorders:
        return 'Tile borders';
      case MapWidgetDebugOptions.parseStatus:
        return 'Parse status';
      case MapWidgetDebugOptions.timestamps:
        return 'Timestamps';
      case MapWidgetDebugOptions.collision:
        return 'Collision';
      case MapWidgetDebugOptions.overdraw:
        return 'Overdraw';
      case MapWidgetDebugOptions.stencilClip:
        return 'Stencil clip';
      case MapWidgetDebugOptions.depthBuffer:
        return 'Depth buffer';
      case MapWidgetDebugOptions.modelBounds:
        return 'Model bounds';
      case MapWidgetDebugOptions.terrainWireframe:
        return 'Terrain wireframe';
      case MapWidgetDebugOptions.layers2DWireframe:
        return '2D layers wireframe';
      case MapWidgetDebugOptions.layers3DWireframe:
        return '3D layers wireframe';
      case MapWidgetDebugOptions.light:
        return 'Light';
      case MapWidgetDebugOptions.camera:
        return 'Camera';
      case MapWidgetDebugOptions.padding:
        return 'Padding';
      default:
        return 'Unknown';
    }
  }
}
