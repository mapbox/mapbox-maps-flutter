import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMapboxMapsFlutterWebPlatform
    with MockPlatformInterfaceMixin
    implements MapboxMapsFlutterWebPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MapboxMapsFlutterWebPlatform initialPlatform = MapboxMapsFlutterWebPlatform.instance;

  test('$MethodChannelMapboxMapsFlutterWeb is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMapboxMapsFlutterWeb>());
  });

  test('getPlatformVersion', () async {
    MapboxMapsFlutterWeb mapboxMapsFlutterWebPlugin = MapboxMapsFlutterWeb();
    MockMapboxMapsFlutterWebPlatform fakePlatform = MockMapboxMapsFlutterWebPlatform();
    MapboxMapsFlutterWebPlatform.instance = fakePlatform;

    expect(await mapboxMapsFlutterWebPlugin.getPlatformVersion(), '42');
  });
}
