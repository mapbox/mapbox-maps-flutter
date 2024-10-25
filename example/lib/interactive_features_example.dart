
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class InteractiveFeaturesExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'Interactive Features';
  @override
  final String? subtitle = null;

  @override
  State<StatefulWidget> createState() => InteractiveFeaturesState();
}

class InteractiveFeaturesState extends State<InteractiveFeaturesExample> {
  InteractiveFeaturesState();

  MapboxMap? mapboxMap;
  var isLight = true;
  var feature = Feature(
      id: "addedFeature",
      geometry:
          Point(coordinates: Position(24.94180921290157, 60.171227338006844)),
      properties: {"test": "data"});

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.style;
  }

  _onTap(context) async {
    print("tap");

    // QRF
    var clicked = await mapboxMap?.pixelForCoordinate(context.point);
    var renderedQueryGeometry =
        RenderedQueryGeometry.fromScreenCoordinate(clicked!);
    var target = FeaturesetQueryTarget(
        featureset: FeaturesetDescriptor(
            featuresetId: "buildings", importId: "basemap"));
    var targets = [target];
    var query = await mapboxMap?.queryRenderedFeaturesForTargets(
        renderedQueryGeometry, targets);
    var feature = query?.first?.queriedFeature;
    print("feature");
    print(feature?.feature);

    Map<String, Object?> data = {
      "highlight": true,
    };

    var geometry = (Point(coordinates: Position(1, 2))).toJson();

    var featureSetFeature = FeaturesetFeature(
        id: FeaturesetFeatureId(id: "1225951980"),
        featureset: FeaturesetDescriptor(
            featuresetId: "buildings", importId: "basemap"),
        geometry: geometry,
        properties: {},
        state: data);

    // Set FeatureState
    await mapboxMap?.setFeatureStateForFeaturesetFeature(
        featureSetFeature, data);

    await Future.delayed(Duration(seconds: 2));

    var featureState =
        await mapboxMap?.getFeatureStateForFeaturesetFeature(featureSetFeature);
    print(featureState);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                  child: Icon(Icons.swap_horiz),
                  heroTag: null,
                  onPressed: () {
                    setState(
                      () => isLight = !isLight,
                    );
                    if (isLight) {
                      mapboxMap?.loadStyleURI(MapboxStyles.LIGHT);
                    } else {
                      mapboxMap?.loadStyleURI(MapboxStyles.DARK);
                    }
                  }),
              SizedBox(height: 10),
            ],
          ),
        ),
        body: MapWidget(
          key: ValueKey("mapWidget"),
          cameraOptions: CameraOptions(
              center: Point(
                  coordinates: Position(24.94180921290157, 60.171227338006844)),
              zoom: 15.0,
              pitch: 30),
          styleUri: MapboxStyles.STANDARD_EXPERIMENTAL,
          textureView: true,
          onMapCreated: _onMapCreated,
          onTapListener: _onTap,
        ));
  }
}
