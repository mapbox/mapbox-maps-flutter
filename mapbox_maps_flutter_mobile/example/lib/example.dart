import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:flutter/material.dart';

abstract interface class Example extends Widget {
  Widget get leading;
  String get title;
  String? get subtitle;
}
