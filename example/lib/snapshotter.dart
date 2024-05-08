import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'page.dart';

class SnapshotterPage extends ExamplePage {
  SnapshotterPage()
      : super(const Icon(Icons.camera_alt_outlined),
            'Create a static map snapshot');

  @override
  Widget build(BuildContext context) {
    return const SnapshotterPageBody();
  }
}

class SnapshotterPageBody extends StatefulWidget {
  const SnapshotterPageBody();

  @override
  State<StatefulWidget> createState() => SnapshotterPageBodyState();
}

class SnapshotterPageBodyState extends State<SnapshotterPageBody> {
  SnapshotterPageBodyState();

  GlobalKey _snapshotKey = GlobalKey();
  MapboxMap? mapboxMap;
  Image? snapshotImage;
  Snapshotter? _snapshotter;
  bool snapshotting = false;

  @override
  void dispose() {
    _snapshotter?.dispose();
    super.dispose();
  }

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;

    _snapshotter = await Snapshotter.create(
      options: MapSnapshotOptions(
          size: Size(width: 400, height: 400),
          pixelRatio: MediaQuery.of(context).devicePixelRatio),
    );
    await _snapshotter?.style.setStyleURI(MapboxStyles.OUTDOORS);
  }

  _onMapIdle(MapIdleEventData data) async {
    if (snapshotting) {
      return;
    }
    snapshotting = true;

    RenderBox snapshotBox =
        _snapshotKey.currentContext!.findRenderObject() as RenderBox;
    if (snapshotBox.hasSize) {
      _snapshotter?.setSize(
          Size(width: snapshotBox.size.width, height: snapshotBox.size.height));
    }

    final cameraState = await mapboxMap!.getCameraState();
    _snapshotter?.setCamera(cameraState.toCameraOptions());

    final snapshot = await _snapshotter?.start();

    if (snapshot != null) {
      setState(() {
        snapshotImage = Image.memory(snapshot);
      });
    }
    snapshotting = false;
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
      onMapIdleListener: _onMapIdle,
    );
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: mapWidget),
          SizedBox(
            height: 12,
            child: ColoredBox(
              color: Colors.amber,
            ),
          ),
          Expanded(
              key: _snapshotKey,
              child: snapshotImage ?? ColoredBox(color: Colors.grey)),
        ],
      ),
    );
  }
}
