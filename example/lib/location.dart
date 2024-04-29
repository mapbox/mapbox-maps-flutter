import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'page.dart';

class LocationPage extends ExamplePage {
  LocationPage() : super(const Icon(Icons.map), 'Location Component');

  @override
  Widget build(BuildContext context) {
    return const LocationPageBody();
  }
}

class LocationPageBody extends StatefulWidget {
  const LocationPageBody();

  @override
  State<StatefulWidget> createState() => LocationPageBodyState();
}

class LocationPageBodyState extends State<LocationPageBody> {
  LocationPageBodyState();

  final colors = [Colors.amber, Colors.black, Colors.blue];

  MapboxMap? mapboxMap;
  int _accuracyColor = 0;
  int _pulsingColor = 0;
  int _accuracyBorderColor = 0;
  double _puckScale = 10.0;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _show() {
    return TextButton(
      child: Text('show location'),
      onPressed: () {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(enabled: true));
      },
    );
  }

  Widget _hide() {
    return TextButton(
      child: Text('hide location'),
      onPressed: () {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(enabled: false));
      },
    );
  }

  Widget _showBearing() {
    return TextButton(
      child: Text('show location bearing'),
      onPressed: () {
        mapboxMap?.location.updateSettings(
            LocationComponentSettings(puckBearingEnabled: true));
      },
    );
  }

  Widget _hideBearing() {
    return TextButton(
      child: Text('hide location bearing'),
      onPressed: () {
        mapboxMap?.location.updateSettings(
            LocationComponentSettings(puckBearingEnabled: false));
      },
    );
  }

  Widget _showPulsing() {
    return TextButton(
      child: Text('show pulsing'),
      onPressed: () {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(pulsingEnabled: true));
      },
    );
  }

  Widget _hidePulsing() {
    return TextButton(
      child: Text('hide pulsing'),
      onPressed: () {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(pulsingEnabled: false));
      },
    );
  }

  Widget _showAccuracy() {
    return TextButton(
      child: Text('show accuracy'),
      onPressed: () {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(showAccuracyRing: true));
      },
    );
  }

  Widget _hideAccuracy() {
    return TextButton(
      child: Text('hide accuracy'),
      onPressed: () {
        mapboxMap?.location
            .updateSettings(LocationComponentSettings(showAccuracyRing: false));
      },
    );
  }

  Widget _switchAccuracyBorderColor() {
    return TextButton(
      child: Text('switch accuracy border color'),
      onPressed: () {
        _accuracyBorderColor++;
        _accuracyBorderColor %= colors.length;
        mapboxMap?.location.updateSettings(LocationComponentSettings(
            accuracyRingBorderColor: colors[_accuracyBorderColor].value));
      },
    );
  }

  Widget _switchAccuracyColor() {
    return TextButton(
      child: Text('switch accuracy color'),
      onPressed: () {
        _pulsingColor++;
        _pulsingColor %= colors.length;
        mapboxMap?.location.updateSettings(LocationComponentSettings(
            accuracyRingColor: colors[_pulsingColor].value));
      },
    );
  }

  Widget _switchPulsingColor() {
    return TextButton(
      child: Text('switch pulsing color'),
      onPressed: () {
        _accuracyColor++;
        _accuracyColor %= colors.length;
        mapboxMap?.location.updateSettings(LocationComponentSettings(
            pulsingColor: colors[_accuracyColor].value));
      },
    );
  }

  Widget _switchLocationPuck2D() {
    return TextButton(
      child: Text('switch to 2d puck'),
      onPressed: () async {
        final ByteData bytes =
            await rootBundle.load('assets/symbols/custom-icon.png');
        final Uint8List list = bytes.buffer.asUint8List();

        mapboxMap?.location.updateSettings(LocationComponentSettings(
            enabled: true,
            puckBearingEnabled: true,
            locationPuck: LocationPuck(
                locationPuck2D: DefaultLocationPuck2D(
                    topImage: list, shadowImage: Uint8List.fromList([])))));
      },
    );
  }

  Widget _switchLocationPuck3D() {
    return TextButton(
      child: Text('switch to 3d puck'),
      onPressed: () {
        mapboxMap?.location.updateSettings(LocationComponentSettings(
            locationPuck: LocationPuck(
                locationPuck3D: LocationPuck3D(
                    modelUri:
                        "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",
                    modelScale: [_puckScale, _puckScale, _puckScale]))));
      },
    );
  }

  Widget _switchPuckScale() {
    return TextButton(
      child: Text('scale 3d puck'),
      onPressed: () {
        _puckScale /= 2;
        if (_puckScale < 1) {
          _puckScale = 10.0;
        }
        print("Scale : $_puckScale");
        mapboxMap?.location.updateSettings(LocationComponentSettings(
            locationPuck: LocationPuck(
                locationPuck3D: LocationPuck3D(
                    modelUri:
                        "https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf",
                    modelScale: [_puckScale, _puckScale, _puckScale]))));
      },
    );
  }

  Widget _getPermission() {
    return TextButton(
      child: Text('get location permission'),
      onPressed: () async {
        var status = await Permission.locationWhenInUse.request();
        print("Location granted : $status");
      },
    );
  }

  Widget _getSettings() {
    return TextButton(
      child: Text('get settings'),
      onPressed: () {
        mapboxMap?.location.getSettings().then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("""
                  Location settings : 
                    enabled : ${value.enabled}, 
                    puckBearingEnabled : ${value.puckBearingEnabled}
                    puckBearing : ${value.puckBearing}
                    pulsing : ${value.pulsingEnabled}
                    pulsing radius : ${value.pulsingMaxRadius}
                    pulsing color : ${value.pulsingColor}
                    accuracy :  ${value.showAccuracyRing},
                    accuracy color :  ${value.accuracyRingColor}
                    accuracyRingBorderColor : ${value.accuracyRingBorderColor}
                    """
                      .trim()),
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget =
        MapWidget(key: ValueKey("mapWidget"), onMapCreated: _onMapCreated);

    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.addAll(
      <Widget>[
        _getPermission(),
        _show(),
        _hide(),
        _switchLocationPuck2D(),
        _switchLocationPuck3D(),
        _switchPuckScale(),
        _showBearing(),
        _hideBearing(),
        _showAccuracy(),
        _hideAccuracy(),
        _showPulsing(),
        _hidePulsing(),
        _switchAccuracyColor(),
        _switchPulsingColor(),
        _switchAccuracyBorderColor(),
        _getSettings(),
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
