library mapbox_maps_flutter_web;

import 'dart:html';
import 'dart:js';
import 'dart:js_util';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import 'src/interop/map_impl.dart';

part 'src/mapbox_maps_platform_web.dart';
part 'src/mapbox_maps_flutter_plugin.dart';
