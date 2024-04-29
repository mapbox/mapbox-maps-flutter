import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'page.dart';

class OrnamentsPage extends ExamplePage {
  OrnamentsPage() : super(const Icon(Icons.map), 'Ornaments');

  @override
  Widget build(BuildContext context) {
    return const OrnamentsPageBody();
  }
}

class OrnamentsPageBody extends StatefulWidget {
  const OrnamentsPageBody();

  @override
  State<StatefulWidget> createState() => OrnamentsPageBodyState();
}

class OrnamentsPageBodyState extends State<OrnamentsPageBody> {
  OrnamentsPageBodyState();

  final colors = [Colors.amber, Colors.black, Colors.blue];

  MapboxMap? mapboxMap;
  bool showOrnaments = true;
  OrnamentPosition compassPosition = OrnamentPosition.TOP_RIGHT;
  bool showScaleBar = true;
  OrnamentPosition scaleBarPosition = OrnamentPosition.TOP_LEFT;
  OrnamentPosition logoPosition = OrnamentPosition.BOTTOM_LEFT;
  OrnamentPosition attributionPosition = OrnamentPosition.BOTTOM_RIGHT;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;

    mapboxMap.setCamera(CameraOptions(
      center: Point(
          coordinates: Position(
        -0.11968,
        51.50325,
      )),
      padding: null,
      anchor: null,
      zoom: 12,
      bearing: 40,
      pitch: null,
    ));

    _updateOrnamentSettings();
  }

  void _updateOrnamentSettings() {
    mapboxMap?.compass.updateSettings(CompassSettings(
      position: compassPosition,
      enabled: showOrnaments,
      marginBottom: 10,
      marginLeft: 10,
      marginTop: 10,
      marginRight: 10,
    ));

    mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(
      position: scaleBarPosition,
      enabled: showScaleBar,
      marginBottom: 20,
      marginLeft: 10,
      marginTop: 10,
      marginRight: 20,
    ));

    mapboxMap?.logo.updateSettings(LogoSettings(
      position: logoPosition,
      marginBottom: 10,
      marginLeft: 10,
      marginTop: 30,
      marginRight: 30,
    ));

    mapboxMap?.attribution.updateSettings(AttributionSettings(
      position: attributionPosition,
      marginBottom: 10,
      marginLeft: 40,
      marginTop: 40,
      marginRight: 0,
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _getCompassSettings() {
    return TextButton(
      child: Text('get compass settings'),
      onPressed: () {
        mapboxMap?.compass.getSettings().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("""
                  Ornaments settings : 
                    clickable : ${value.clickable}, 
                    enabled : ${value.enabled}
                    marginBottom : ${value.marginBottom}
                    marginLeft : ${value.marginLeft}
                    marginRight : ${value.marginRight}
                    marginTop : ${value.marginTop}
                    opacity : ${value.opacity},
                    position :  ${value.position}
                    rotation : ${value.rotation}
                    """
                      .trim()),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  _toggleOrnaments() {
    return TextButton(
      child: Text('toggle compass'),
      onPressed: () {
        if (showOrnaments) {
          showOrnaments = false;
        } else {
          showOrnaments = true;
        }
        _updateOrnamentSettings();
      },
    );
  }

  Widget _moveOrnaments() {
    return TextButton(
      child: Text('move compass'),
      onPressed: () {
        switch (compassPosition) {
          case OrnamentPosition.BOTTOM_LEFT:
            compassPosition = OrnamentPosition.TOP_LEFT;
            break;
          case OrnamentPosition.TOP_LEFT:
            compassPosition = OrnamentPosition.TOP_RIGHT;
            break;
          case OrnamentPosition.TOP_RIGHT:
            compassPosition = OrnamentPosition.BOTTOM_RIGHT;
            break;
          case OrnamentPosition.BOTTOM_RIGHT:
            compassPosition = OrnamentPosition.BOTTOM_LEFT;
            break;
        }
        _updateOrnamentSettings();
      },
    );
  }

  _toggleScaleBar() {
    return TextButton(
      child: Text('toggle scale bar'),
      onPressed: () {
        if (showScaleBar) {
          showScaleBar = false;
        } else {
          showScaleBar = true;
        }
        _updateOrnamentSettings();
      },
    );
  }

  _moveScaleBar() {
    return TextButton(
      child: Text('move scale bar'),
      onPressed: () {
        switch (scaleBarPosition) {
          case OrnamentPosition.BOTTOM_LEFT:
            scaleBarPosition = OrnamentPosition.TOP_LEFT;
            break;
          case OrnamentPosition.TOP_LEFT:
            scaleBarPosition = OrnamentPosition.TOP_RIGHT;
            break;
          case OrnamentPosition.TOP_RIGHT:
            scaleBarPosition = OrnamentPosition.BOTTOM_RIGHT;
            break;
          case OrnamentPosition.BOTTOM_RIGHT:
            scaleBarPosition = OrnamentPosition.BOTTOM_LEFT;
            break;
        }
        _updateOrnamentSettings();
      },
    );
  }

  _moveAttribution() {
    return TextButton(
      child: Text('move attribution'),
      onPressed: () {
        switch (attributionPosition) {
          case OrnamentPosition.BOTTOM_LEFT:
            attributionPosition = OrnamentPosition.TOP_LEFT;
            break;
          case OrnamentPosition.TOP_LEFT:
            attributionPosition = OrnamentPosition.TOP_RIGHT;
            break;
          case OrnamentPosition.TOP_RIGHT:
            attributionPosition = OrnamentPosition.BOTTOM_RIGHT;
            break;
          case OrnamentPosition.BOTTOM_RIGHT:
            attributionPosition = OrnamentPosition.BOTTOM_LEFT;
            break;
        }
        _updateOrnamentSettings();
      },
    );
  }

  _moveLogo() {
    return TextButton(
      child: Text('move logo'),
      onPressed: () {
        switch (logoPosition) {
          case OrnamentPosition.BOTTOM_LEFT:
            logoPosition = OrnamentPosition.TOP_LEFT;
            break;
          case OrnamentPosition.TOP_LEFT:
            logoPosition = OrnamentPosition.TOP_RIGHT;
            break;
          case OrnamentPosition.TOP_RIGHT:
            logoPosition = OrnamentPosition.BOTTOM_RIGHT;
            break;
          case OrnamentPosition.BOTTOM_RIGHT:
            logoPosition = OrnamentPosition.BOTTOM_LEFT;
            break;
        }
        _updateOrnamentSettings();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
    );

    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.addAll(
      <Widget>[
        _getCompassSettings(),
        _toggleOrnaments(),
        _moveOrnaments(),
        _toggleScaleBar(),
        _moveScaleBar(),
        _moveAttribution(),
        _moveLogo(),
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
