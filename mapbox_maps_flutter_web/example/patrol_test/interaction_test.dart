import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/mapbox_maps_flutter_web.dart';
import 'package:turf/turf.dart' show Point, Position;
import 'patrol.dart';

import 'test_utils.dart';

final _viewport = CameraViewportState(
  center: Point(coordinates: Position(0, 0)),
  zoom: 5,
);

void main() {
  patrolTest('TapInteraction.onMap fires on map click', ($) async {
    final controller = await pumpMapTree(
      $.tester,
      (onCreated) => MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: MapWebWidget(
                  viewport: _viewport,
                  onMapCreated: onCreated,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final completer = Completer<MapContentGestureContext>();
    controller.addInteraction(
      TypedInteraction<TypedFeaturesetFeature<FeaturesetDescriptor>>(
        interactionType: InteractionType.tap,
        featureFactory: TypedFeaturesetFeature.fromFeaturesetFeature,
        action: (feature, context) {
          // onMap interactions are targetless — feature is null.
          expect(feature, isNull);
          if (!completer.isCompleted) completer.complete(context);
        },
      ),
    );

    // Real DOM click on the GL JS canvas container, exercising the full
    // pipeline (DOM event → MapEventHandler.click → map.fire('click') →
    // InteractionSet → our handler).
    final rect = mapRect();
    canvasContainer().dispatchEvent(
      mouseEvent(
        'click',
        rect.left + rect.width / 2,
        rect.top + rect.height / 2,
      ),
    );

    final context = await completer.future.timeout(const Duration(seconds: 3));
    expect(context.gestureState, GestureState.ended);
  });
}
