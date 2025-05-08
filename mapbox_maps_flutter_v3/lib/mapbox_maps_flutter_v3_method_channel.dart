import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mapbox_maps_flutter_v3_platform_interface.dart';

/// An implementation of [MapboxMapsFlutterV3Platform] that uses method channels.
class MethodChannelMapboxMapsFlutterV3 extends MapboxMapsFlutterV3Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mapbox_maps_flutter_v3');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
