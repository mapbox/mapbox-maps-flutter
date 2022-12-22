import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'main.dart';
import 'page.dart';

class StylePage extends ExamplePage {
  StylePage() : super(const Icon(Icons.map), 'Style interface');

  @override
  Widget build(BuildContext context) {
    return const StylePageBody();
  }
}

class StylePageBody extends StatefulWidget {
  const StylePageBody();

  @override
  State<StatefulWidget> createState() => StylePageBodyState();
}

class StylePageBodyState extends State<StylePageBody> {
  StylePageBodyState();

  MapboxMap? mapboxMap;
  var mapProject = 'globe';
  var locale = 'en';

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  void _onStyleLoaded(StyleLoadedEventData styleLoadedEventData) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("onStyleLoaded"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
    _addLayerAndSource();
  }

  // Style string can a reference to a local or remote resources.
  List<String> _styleStrings = [
    MapboxStyles.MAPBOX_STREETS,
    MapboxStyles.SATELLITE,
  ];
  int styleIndex = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _addLayerAndSource() async {
    mapboxMap?.style.styleSourceExists("source").then((value) async {
      if (!value) {
        var source = await rootBundle.loadString('assets/source.json');
        mapboxMap?.style.addStyleSource("source", source);
      }
    });
    mapboxMap?.style.styleLayerExists("custom").then((value) async {
      if (!value) {
        var layer = await rootBundle.loadString('assets/layer.json');
        mapboxMap?.style.addStyleLayer(layer, null);
      }
    });
    mapboxMap?.style.styleSourceExists("point_source").then((value) async {
      if (!value) {
        final ByteData bytes =
            await rootBundle.load('assets/symbols/custom-icon.png');
        final Uint8List list = bytes.buffer.asUint8List();
        mapboxMap?.style.addStyleImage("icon", 1.0,
            MbxImage(width: 40, height: 40, data: list), true, [], [], null);
        var geometry = {
          "type": "Point",
          "coordinates": [24.9384, 60.1699]
        };
        var data = {"type": "Feature", "geometry": geometry};
        var source = {"type": "geojson", "data": data};
        mapboxMap?.style.addStyleSource("point_source", json.encode(source));
      }
    });
    mapboxMap?.style.styleLayerExists("point_layer").then((value) async {
      if (!value) {
        var layer = {
          "id": "point_layer",
          "type": "symbol",
          "source": "point_source"
        };
        mapboxMap?.style.addStyleLayer(json.encode(layer), null);
        var properties = {
          "icon-image": "icon",
          "icon-opacity": 1.0,
          "icon-size": 1.0,
          "icon-color": "blue"
        };
        mapboxMap?.style
            .setStyleLayerProperties("point_layer", json.encode(properties));
      }
    });
  }

  Widget _getStyleURI() {
    return TextButton(
      child: Text('getStyleURI'),
      onPressed: () {
        mapboxMap?.style.getStyleURI().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Style URI: $value"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 1),
                )));
      },
    );
  }

  Widget _setStyleURI() {
    return TextButton(
      child: Text('setStyleURI'),
      onPressed: () {
        mapboxMap?.style
            .setStyleURI(_styleStrings[styleIndex++ % _styleStrings.length]);
      },
    );
  }

  Widget _setStyleJSON() {
    return TextButton(
      child: Text('setStyleJSON'),
      onPressed: () async {
        var styleJson = await rootBundle.loadString('assets/style.json');
        mapboxMap?.style.setStyleJSON(styleJson);
      },
    );
  }

  Widget _getStyleJSON() {
    return TextButton(
      child: Text('getStyleJSON'),
      onPressed: () {
        mapboxMap?.style.getStyleJSON().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Style JSON: $value"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 1),
                )));
      },
    );
  }

  Widget _getStyleTransition() {
    return TextButton(
      child: Text('getStyleTransition'),
      onPressed: () {
        mapboxMap?.style.getStyleTransition().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Style getStyleTransition, delay: ${value.delay}, duration: ${value.duration}, enablePlacementTransitions: ${value.enablePlacementTransitions}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 1),
                )));
      },
    );
  }

  Widget _setStyleTransition() {
    return TextButton(
      child: Text('setStyleTransition'),
      onPressed: () {
        mapboxMap?.style.setStyleTransition(TransitionOptions(
            delay: 100, duration: 200, enablePlacementTransitions: false));
      },
    );
  }

  Widget _addStyleLayerAndSource() {
    return TextButton(
        child: Text('addStyleLayerAndSource'), onPressed: _addLayerAndSource);
  }

  Widget _addPersistentStyleLayer() {
    return TextButton(
      child: Text('addPersistentStyleLayerAndSource'),
      onPressed: () async {
        mapboxMap?.style.styleSourceExists("source").then((value) async {
          if (!value) {
            var source = await rootBundle.loadString('assets/source.json');
            mapboxMap?.style.addStyleSource("source", source);
          }
        });
        mapboxMap?.style.styleLayerExists("custom").then((value) async {
          if (!value) {
            var layer = await rootBundle.loadString('assets/layer.json');
            mapboxMap?.style.addPersistentStyleLayer(layer, null);
          }
        });
      },
    );
  }

  Widget _isStyleLayerPersistent() {
    return TextButton(
      child: Text('isStyleLayerPersistent'),
      onPressed: () {
        mapboxMap?.style.isStyleLayerPersistent("custom").then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Style isStyleLayerPersistent, $value"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 1),
                )));
      },
    );
  }

  Widget _removeLayerAndSource() {
    return TextButton(
      child: Text('removeLayerAndSource'),
      onPressed: () {
        mapboxMap?.style.removeStyleLayer("custom");
        mapboxMap?.style.removeStyleSource("source");
        mapboxMap?.style.removeStyleLayer("point_layer");
        mapboxMap?.style.removeStyleSource("point_source");
      },
    );
  }

  Widget _moveLayer() {
    return TextButton(
      child: Text('moveLayer'),
      onPressed: () {
        mapboxMap?.style
            .moveStyleLayer("custom", LayerPosition(below: "pitch-outline"));
      },
    );
  }

  Widget _getStyleLayers() {
    return TextButton(
      child: Text('getStyleLayers'),
      onPressed: () {
        mapboxMap?.style
            .getStyleLayers()
            .then((value) => value.forEach((element) {
                  print(element?.id);
                }));
      },
    );
  }

  Widget _getStyleSources() {
    return TextButton(
      child: Text('getStyleSources'),
      onPressed: () {
        mapboxMap?.style.getStyleSources().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("${value.map((e) => e?.id)}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 3),
                )));
      },
    );
  }

  Widget _getStyleLayerProperty() {
    return TextButton(
      child: Text('getStyleLayerProperty'),
      onPressed: () {
        mapboxMap?.style.getStyleLayerProperty("custom", "circle-radius").then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("value: ${value.value}, kind: ${value.kind}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 1),
                )));
      },
    );
  }

  Widget _setStyleLayerProperty() {
    return TextButton(
      child: Text('setStyleLayerProperty'),
      onPressed: () {
        mapboxMap?.style.setStyleLayerProperty("custom", "circle-radius", 5.0);
        mapboxMap?.style.setStyleLayerProperty("custom", "circle-color", "red");
      },
    );
  }

  Widget _getStyleLayerProperties() {
    return TextButton(
      child: Text('getStyleLayerProperties'),
      onPressed: () {
        mapboxMap?.style.getStyleLayerProperties("custom").then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("value: $value"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 3),
                )));
      },
    );
  }

  Widget _setStyleLayerProperties() {
    return TextButton(
      child: Text('setStyleLayerProperties'),
      onPressed: () {
        var properties = {"circle-radius": 10.0, "circle-color": "blue"};
        mapboxMap?.style
            .setStyleLayerProperties("custom", json.encode(properties));
      },
    );
  }

  Widget _getStyleSourceProperty() {
    return TextButton(
      child: Text('getStyleSourceProperty'),
      onPressed: () {
        mapboxMap?.style.getStyleSourceProperty("source", "type").then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("value: ${value.value}, kind: ${value.kind}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 3),
                )));
      },
    );
  }

  Widget _getStyleSourceProperties() {
    return TextButton(
      child: Text('getStyleSourceProperties'),
      onPressed: () {
        mapboxMap?.style.getStyleSourceProperties("source").then((value) {
          var properties = (json.decode(value) as Map<String, dynamic>);
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("$properties"),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 3),
          ));
        });
      },
    );
  }

  Widget _setStyleLightProperty() {
    return TextButton(
      child: Text('setStyleLightProperty'),
      onPressed: () {
        mapboxMap?.style.setStyleLightProperty('color', 'white');
        mapboxMap?.style.setStyleLightProperty('intensity', 0.4);
      },
    );
  }

  Widget _getStyleLightProperty() {
    return TextButton(
      child: Text('getStyleLightProperty'),
      onPressed: () {
        mapboxMap?.style.getStyleLightProperty("intensity").then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("value: ${value.value}, kind: ${value.kind}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 3),
                )));
      },
    );
  }

  Widget _getDefaultCamera() {
    return TextButton(
      child: Text('getDefaultCamera'),
      onPressed: () {
        mapboxMap?.style.getStyleDefaultCamera().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("center: ${value.center}"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 3),
                )));
      },
    );
  }

  Widget _isStyleLoaded() {
    return TextButton(
      child: Text('isStyleLoaded'),
      onPressed: () {
        mapboxMap?.style.isStyleLoaded().then((value) {
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("$value"),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 1),
          ));
        });
      },
    );
  }

  Widget _hasImageIcon() {
    return TextButton(
      child: Text('hasImageIcon'),
      onPressed: () {
        mapboxMap?.style.getStyleImage("icon").then((value) {
          return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "icon width: ${value?.width}, icon height: ${value?.height}"),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 1),
          ));
        });
      },
    );
  }

  Widget _getProjection() {
    return TextButton(
      child: Text('getProjection'),
      onPressed: () {
        mapboxMap?.style.getProjection().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("getProjection: $value"),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  Widget _setProjection() {
    return TextButton(
      child: Text('setProjection'),
      onPressed: () {
        mapboxMap?.style.setProjection(mapProject);
        if (mapProject == 'globe') {
          mapProject = 'mercator';
        } else {
          mapProject = 'globe';
        }
      },
    );
  }

  Widget _changeLocale() {
    return TextButton(
      child: Text('changeLocale'),
      onPressed: () {
        if (locale == 'en') {
          locale = 'de';
        } else {
          locale = 'en';
        }
        mapboxMap?.style.localizeLabels(locale, null);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
        key: ValueKey("mapWidget"),
        resourceOptions: ResourceOptions(accessToken: MapsDemo.ACCESS_TOKEN),
        onMapCreated: _onMapCreated,
        onStyleLoadedListener: _onStyleLoaded);

    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.addAll(
      <Widget>[
        _getStyleURI(),
        _setStyleURI(),
        _getStyleJSON(),
        _setStyleJSON(),
        _getStyleTransition(),
        _setStyleTransition(),
        _addStyleLayerAndSource(),
        _addPersistentStyleLayer(),
        _isStyleLayerPersistent(),
        _removeLayerAndSource(),
        _moveLayer(),
        _getStyleLayers(),
        _getStyleSources(),
        _getStyleLayerProperty(),
        _setStyleLayerProperty(),
        _getStyleLayerProperties(),
        _setStyleLayerProperties(),
        _getStyleSourceProperty(),
        _getStyleSourceProperties(),
        _setStyleLightProperty(),
        _getStyleLightProperty(),
        _getDefaultCamera(),
        _hasImageIcon(),
        _isStyleLoaded(),
        _getProjection(),
        _setProjection(),
        _changeLocale(),
      ],
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 400,
              child: mapWidget),
        ),
        Expanded(
          child: ListView(
            children: listViewChildren,
          ),
        )
      ],
    );
  }
}
