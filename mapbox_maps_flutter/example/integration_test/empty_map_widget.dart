import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class Events {
  var onMapIdle = Completer();
  var onMapLoaded = Completer();
  var onStyleLoaded = Completer();
  var onStyleDataLoaded = Completer();
  var onSourceDataLoaded = Completer();
  var onCameraChanged = Completer();
  List<MapContentGestureContext> mapInteractions = [];
  var sourceDataIDs = [""];

  void resetOnMapLoaded() => onMapLoaded = Completer();
  void resetOnStyleLoaded() => onStyleLoaded = Completer();
  void resetOnStyleDataLoaded() => onStyleDataLoaded = Completer();
  void resetOnSourceDataLoaded() => {
    sourceDataIDs.clear(),
    onSourceDataLoaded = Completer(),
  };
  void resetOnCameraChanged() => onCameraChanged = Completer();
  void resetOnMapIdle() => onMapIdle = Completer();
  void resetMapInteractions() => mapInteractions.clear();
}

var events = Events();

Future<MapboxMap> main({
  double? width,
  double? height,
  ViewportState? viewport,
  Alignment alignment = Alignment.topLeft,
  String styleUri = MapboxStyles.STANDARD,
  // Raw style JSON applied in onMapCreated instead of [styleUri], so no
  // default style flashes before it loads.
  String? styleJson,
  bool isOpaque = true,
  bool textureView = true,
  // Solid backdrop placed behind the map, useful for asserting on
  // transparency of the map surface itself.
  Color? background,
}) {
  final completer = Completer<MapboxMap>();

  events = Events();
  final mapWidget = MapWidget(
    key: const ValueKey("mapWidget"),
    viewport: viewport,
    styleUri: styleJson == null ? styleUri : '',
    isOpaque: isOpaque,
    textureView: textureView,
    onMapCreated: (MapboxMap mapboxMap) async {
      if (styleJson != null) {
        await mapboxMap.style.setStyleJSON(styleJson);
      }
      completer.complete(mapboxMap);
    },
    onMapLoadedListener: (MapLoadedEventData data) {
      if (!events.onMapLoaded.isCompleted) {
        events.onMapLoaded.complete();
      }
    },
    onStyleLoadedListener: (StyleLoadedEventData data) {
      if (!events.onStyleLoaded.isCompleted) {
        events.onStyleLoaded.complete();
      }
    },
    onStyleDataLoadedListener: (StyleDataLoadedEventData data) {
      if (!events.onStyleDataLoaded.isCompleted) {
        events.onStyleDataLoaded.complete();
      }
    },
    onSourceDataLoadedListener: (SourceDataLoadedEventData data) {
      final dataID = data.dataId;
      if (dataID != null) {
        events.sourceDataIDs.add(dataID);
      }
      if (!events.onSourceDataLoaded.isCompleted) {
        events.onSourceDataLoaded.complete();
      }
    },
    onCameraChangeListener: (CameraChangedEventData data) {
      if (!events.onCameraChanged.isCompleted) {
        events.onCameraChanged.complete();
      }
    },
    onMapIdleListener: (MapIdleEventData data) {
      if (!events.onMapIdle.isCompleted) {
        events.onMapIdle.complete();
      }
    },
  );

  runApp(
    MaterialApp(
      home: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width,
          height: height,
          child: background == null
              ? mapWidget
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(color: background),
                    mapWidget,
                  ],
                ),
        ),
      ),
    ),
  );

  return Future.wait([
    completer.future,
    events.onStyleLoaded.future,
  ]).then((value) => value.first as MapboxMap);
}

void runEmpty() {
  runApp(const MaterialApp());
}

extension CompleterExpect<T> on Completer<T> {
  void ensureCompletedOnce([FutureOr<T>? value, String? description]) {
    if (completeOnce(value)) return;
    fail(description ?? "Completer was already completed");
  }

  bool completeOnce([FutureOr<T>? value]) {
    if (isCompleted) return false;

    complete(value);
    return true;
  }

  void completeWhen(bool condition, [String? description, FutureOr<T>? value]) {
    if (isCompleted) return;
    if (condition) {
      complete(value);
    } else {
      completeError(
        description ?? 'Completer completed before condition was met',
      );
    }
  }
}
