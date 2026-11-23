// ignore_for_file: invalid_use_of_visible_for_testing_member
/// Shared setup for the ornament DOM tests.
///
/// Each of those tests lives in its own file on purpose. Patrol's web runner
/// replays every preceding test in a file for each Playwright test, so a
/// file with several tests ends up with several live maps on one page and
/// the DOM assertions become unreliable. One test per file keeps each
/// assertion running against exactly one map.
library;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:mapbox_maps_flutter_web/src/mapbox_map_web.dart';
import 'package:turf/turf.dart' show Point, Position;
import 'package:web/web.dart' as web;

import 'test_utils.dart';

final ornamentViewport = CameraViewportState(
  center: Point(coordinates: Position(0, 0)),
  zoom: 5,
);

/// Pumps a map and returns it, so a test reads the controllers and the GL JS
/// map off the same instance.
///
/// Both handles must come from one [MapboxMapWeb]: reading the map from the
/// widget state separately can hand back a different instance, since the web
/// runner leaves earlier maps in the document.
Future<MapboxMapWeb> pumpOrnamentMap(WidgetTester tester) async {
  final platformMap = await pumpMapTree(
    tester,
    (onCreated) => MaterialApp(
      home: Scaffold(
        body: MapWebWidget(
          styleUri: 'mapbox://styles/mapbox/standard',
          viewport: ornamentViewport,
          onMapCreated: onCreated,
        ),
      ),
    ),
  );
  return platformMap as MapboxMapWeb;
}

/// Compass button inside [map]'s own container, or null when no control is
/// attached. Scoped to this map, which GL JS keeps separate per map.
web.HTMLElement? compassElement(JSMap map) =>
    map.getContainer().querySelector('.mapboxgl-ctrl-compass')
        as web.HTMLElement?;

/// The compass control's root: the group `div` wrapping the button, which is
/// what carries the margins and opacity.
web.HTMLElement? compassRoot(JSMap map) =>
    compassElement(map)?.parentElement as web.HTMLElement?;

/// Scale bar element inside [map]'s own container, or null when no control
/// is attached. Unlike the compass, this element is the control's own root.
web.HTMLElement? scaleBarElement(JSMap map) =>
    map.getContainer().querySelector('.mapboxgl-ctrl-scale')
        as web.HTMLElement?;

/// Attribution element inside [map]'s own container.
web.HTMLElement? attributionElement(JSMap map) =>
    map.getContainer().querySelector('.mapboxgl-ctrl-attrib')
        as web.HTMLElement?;

/// The Mapbox logo link inside [map]'s own container.
web.HTMLElement? logoElement(JSMap map) =>
    map.getContainer().querySelector('.mapboxgl-ctrl-logo') as web.HTMLElement?;

/// The element wrapping the logo link, which carries the margins.
web.HTMLElement? logoRoot(JSMap map) =>
    logoElement(map)?.parentElement as web.HTMLElement?;

/// Indoor selector toggle button inside [map]'s own container, or null.
///
/// Unlike the other ornaments, `IndoorControl` adds an empty group on
/// attach and only renders this button once indoor floor data exists, so
/// it stays null on a plain map with no indoor venue in view.
web.HTMLElement? indoorToggleElement(JSMap map) =>
    map.getContainer().querySelector('.mapboxgl-ctrl-indoor-toggle')
        as web.HTMLElement?;

/// Name of the corner container [element] sits in.
String cornerOf(web.HTMLElement element) => element.parentElement!.className;

/// Points the camera away from north, so the compass's fade-at-north
/// behaviour does not drive opacity to zero during a styling assertion.
Future<void> faceAwayFromNorth(WidgetTester tester, JSMap map) async {
  map.jumpTo(JSCameraOptions()..bearing = 40);
  await tester.pumpAndSettle();
}

/// A 1x1 PNG. The compass only needs some valid image bytes to turn into a
/// blob URL, and building them here keeps the web example free of assets.
final onePixelPng = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, //
  0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
  0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
  0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
]);
