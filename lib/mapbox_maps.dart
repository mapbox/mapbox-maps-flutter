// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
/// library for mapbox maps
library mapbox_maps;

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turf/helpers.dart';
import 'package:turf/turf.dart';

part 'src/annotation/CircleAnnotationManager.dart';
part 'src/annotation/PointAnnotationManager.dart';
part 'src/annotation/PolygonAnnotationManager.dart';
part 'src/annotation/PolylineAnnotationManager.dart';
part 'src/annotation/annotation_manager.dart';
part 'src/callbacks.dart';
part 'src/events.dart';
part 'src/map_view.dart';
part 'src/mapbox_map.dart';
part 'src/mapbox_maps_platform.dart';
part 'src/pigeons/CircleAnnotationMessager.dart';
part 'src/pigeons/PointAnnotationMessager.dart';
part 'src/pigeons/PolygonAnnotationMessager.dart';
part 'src/pigeons/PolylineAnnotationMessager.dart';
part 'src/pigeons/mapbox_map.dart';
part 'src/pigeons/settings.dart';
part 'src/style/layer/background_layer.dart';
part 'src/style/layer/circle_layer.dart';
part 'src/style/layer/fill-extrusion_layer.dart';
part 'src/style/layer/fill_layer.dart';
part 'src/style/layer/heatmap_layer.dart';
part 'src/style/layer/hillshade_layer.dart';
part 'src/style/layer/line_layer.dart';
part 'src/style/layer/location-indicator_layer.dart';
part 'src/style/layer/raster_layer.dart';
part 'src/style/layer/sky_layer.dart';
part 'src/style/layer/symbol_layer.dart';
part 'src/style/light.dart';
part 'src/style/source/geojson_source.dart';
part 'src/style/source/image_source.dart';
part 'src/style/source/raster_source.dart';
part 'src/style/source/rasterdem_source.dart';
part 'src/style/source/vector_source.dart';
part 'src/style/style.dart';
part 'src/style/styles.dart';
