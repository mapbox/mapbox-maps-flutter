import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'page.dart';

class SnapshotPage extends ExamplePage {
  SnapshotPage() : super(const Icon(Icons.map), 'Snapshot');

  @override
  Widget build(BuildContext context) {
    return const SnapshotPageBody();
  }
}

class SnapshotPageBody extends StatefulWidget {
  const SnapshotPageBody();

  @override
  State<StatefulWidget> createState() => SnapshotPageBodyState();
}

class OnSnapshotStyleListenerImpl implements OnSnapshotStyleListener {
  @override
  void onDidFailLoadingStyle(String message) {
    debugPrint('onDidFailLoadingStyle:' + message);
  }

  @override
  void onDidFinishLoadingStyle() {
    debugPrint('onDidFinishLoadingStyle');
  }

  @override
  void onDidFullyLoadStyle() {
    debugPrint('onDidFullyLoadStyle');
  }

  @override
  void onStyleImageMissing(String imageId) {
    debugPrint('onStyleImageMissing:' + imageId);
  }
}

class SnapshotPageBodyState extends State<SnapshotPageBody> {
  SnapshotPageBodyState();

  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  Uint8List? imageData;
  SnapShotter? snapShotter;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _create() {
    return TextButton(
        child: Text('create a snapshot'),
        onPressed: () async {
          snapShotter = await mapboxMap?.snapshotter.create(
            MapSnapshotOptions(
              size: Size(width: 400, height: 400),
              pixelRatio: MediaQuery.of(context).devicePixelRatio,
            ),
            SnapshotOverlayOptions(showAttributes: false),
          );
          final currentState = await mapboxMap?.getCameraState();
          if (currentState != null) {
            snapShotter?.setCamera(CameraOptions(
              center: currentState.center,
              zoom: currentState.zoom,
              padding: currentState.padding,
              pitch: currentState.pitch,
            ));
          }
          final style = await mapboxMap?.style.getStyleURI();
          if (style != null) {
            snapShotter?.setStyleUri(style);
          }
          snapShotter?.setSnapshotStyleListener(OnSnapshotStyleListenerImpl());
          snapShotter?.start().then((value) {
            setState(() {
              imageData = value?.data;
            });
          });
        });
  }

  Widget snapshot() {
    return TextButton(
      child: Text('take a snapshot'),
      onPressed: () async {
        final image = await mapboxMap?.snapshotter.snapshot();
        setState(() {
          imageData = image?.data;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(key: ValueKey("mapWidget"), onMapCreated: _onMapCreated);

    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.addAll(
      <Widget>[_create(), snapshot()],
    );

    final colmn = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 400,
              child: mapWidget),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: ListView(
                  children: listViewChildren,
                ),
              ),
              Positioned.fill(
                child: imageData == null ? SizedBox() : Image.memory(imageData!),
              ),
            ],
          ),
        )
      ],
    );

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(child: Icon(Icons.swap_horiz), heroTag: null, onPressed: () {}),
            SizedBox(height: 10),
            FloatingActionButton(
                child: Icon(Icons.clear),
                heroTag: null,
                onPressed: () {
                  snapShotter?.destroy();
                  snapShotter = null;
                  setState(() {
                    imageData = null;
                  });
                }),
          ],
        ),
      ),
      body: colmn,
    );
  }
}
