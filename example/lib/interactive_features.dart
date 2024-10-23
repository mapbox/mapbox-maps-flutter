import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'page.dart';

class InteractiveFeaturesPage extends ExamplePage {
  InteractiveFeaturesPage()
      : super(const Icon(Icons.map), 'Interactive features map');

  @override
  Widget build(BuildContext context) {
    return const InteractiveFeatures();
  }
}

class InteractiveFeatures extends StatefulWidget {
  const InteractiveFeatures();

  @override
  State createState() => InteractiveFeaturesState();
}

class InteractiveFeaturesState extends State<InteractiveFeatures> {
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

  _onStyleLoadedCallback(StyleLoadedEventData data) {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text("Style loaded :), time: ${data.timeInterval}"),
    //   backgroundColor: Theme.of(context).primaryColor,
    //   duration: Duration(seconds: 1),
    // ));
    print("styleLoaded");
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

    // Get FeatureState
    // var typedFeatures = Feature.fromQueriedFeature(feature!);

    Map<String, Object?> data = {
      "highlight": true,
    };

    String jsonString = jsonEncode(data);

    var geometry = {
      "type": "Point",
      "coordinates": [1, 2]
    };

    Feature featured =
        Feature(id: "id", geometry: Point(coordinates: Position(1, 2)));

    var featureSetFeature = FeaturesetFeature(
        id: FeaturesetFeatureId(id: "1225951980"),
        featureset: FeaturesetDescriptor(
            featuresetId: "buildings", importId: "basemap"),
        geoJSONFeature: featured,
        state: data);

    // Set FeatureState
    await mapboxMap?.setFeatureStateForFeaturesetFeature(
        featureSetFeature, data);

    await Future.delayed(Duration(seconds: 2));

    var featuerState =
        await mapboxMap?.getFeatureStateForFeaturesetFeature(featureSetFeature);
    print("yello");
    print(featuerState);
  }

  _onLongClick(context) async {
    var styleJson = await rootBundle.loadString('assets/featuresetsStyle.json');
    mapboxMap?.style.setStyleJSON(styleJson);
    print("longclick");

    var clicked = await mapboxMap?.pixelForCoordinate(context.point);

    var filter = '["=",["get", "type"],"A"]';
    var featuresetFilterQuery =
        await mapboxMap?.queryRenderedFeaturesForFeatureset(
            geometry: RenderedQueryGeometry.fromScreenCoordinate(clicked!),
            featureset:
                FeaturesetDescriptor(featuresetId: "poi", importId: "nested"),
            filter: filter);

    print(featuresetFilterQuery?[0].geoJSONFeature.properties?["name"]);
    print(featuresetFilterQuery?[0].geoJSONFeature.properties?["class"]);

    var renderedQueryGeometry =
        RenderedQueryGeometry.fromScreenCoordinate(clicked!);

    var target = FeaturesetQueryTarget(
        featureset: FeaturesetDescriptor(
            featuresetId: "buildings", importId: "basemap"));
    var targets = [target];

    var query = await mapboxMap?.queryRenderedFeaturesForTargets(
        renderedQueryGeometry, targets);
    print(query?.first?.queriedFeature.feature);
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
          styleUri:
              "",
          textureView: true,
          onMapCreated: _onMapCreated,
          onStyleLoadedListener: _onStyleLoadedCallback,
          onLongTapListener: _onLongClick,
          onTapListener: _onTap,
        ));
  }
}
