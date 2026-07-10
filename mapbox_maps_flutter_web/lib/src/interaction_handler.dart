import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:turf/turf.dart' show Point, Position;

import 'bindings/map_bindings.dart';

/// Adapts GL JS interaction events to a [TypedInteraction]'s Dart action.
final class InteractionHandler {
  InteractionHandler();

  /// Returns `interaction.stopPropagation` — GL JS treats `false` as
  /// "continue propagation" and anything else as "stop".
  bool call<T extends TypedFeaturesetFeature<FeaturesetDescriptor>>(
    TypedInteraction<T> interaction,
    JSInteractionEvent event,
  ) {
    final context = MapContentGestureContext(
      touchPosition: ScreenCoordinate(x: event.point.x, y: event.point.y),
      point: Point(coordinates: Position(event.lngLat.lng, event.lngLat.lat)),
      gestureState: GestureState.ended,
    );

    final jsFeature = event.feature;
    if (jsFeature == null) {
      interaction.action(null, context);
    } else {
      final raw = _adaptFeature(jsFeature);
      interaction.action(interaction.featureFactory(raw), context);
    }

    return interaction.stopPropagation;
  }

  FeaturesetFeature _adaptFeature(JSTargetFeature jsFeature) {
    final rawId = jsFeature.id?.toDart();
    return FeaturesetFeature(
      id: rawId == null
          ? null
          : FeaturesetFeatureId(id: rawId, namespace: jsFeature.namespace),
      featureset:
          jsFeature.target?.featuresetDescriptor ?? FeaturesetDescriptor(),
      geometry: jsFeature.geometry?.toDart() ?? <String?, Object?>{},
      properties: jsFeature.properties?.toDart() ?? <String, Object?>{},
      state: jsFeature.state?.toDart() ?? <String, Object?>{},
    );
  }
}

extension InteractionTypeJSExtension on InteractionType {
  String get jsInteractionType => switch (this) {
    InteractionType.tap => 'click',
    InteractionType.longTap => throw UnsupportedError(
      'LongTapInteraction is not supported on web.',
    ),
  };
}

extension FeaturesetDescriptorJSExtension on FeaturesetDescriptor {
  JSTargetDescriptor toJSTargetDescriptor() {
    final descriptor = JSTargetDescriptor();
    if (featuresetId != null) descriptor.featuresetId = featuresetId;
    if (importId != null) descriptor.importId = importId;
    if (layerId != null) descriptor.layerId = layerId;
    return descriptor;
  }
}

extension FeaturesetFeatureIdJSExtension on FeaturesetFeatureId {
  JSTargetFeature toJSTargetFeature(FeaturesetDescriptor featureset) {
    final feature = JSTargetFeature()
      ..id = id
      ..target = featureset.toJSTargetDescriptor();
    if (namespace != null) feature.namespace = namespace;
    return feature;
  }
}

extension FeaturesetFeatureJSExtension on FeaturesetFeature {
  JSTargetFeature toJSTargetFeature() {
    final featureId = id;
    if (featureId == null) {
      throw ArgumentError(
        'FeaturesetFeature.id must be non-null to access feature state.',
      );
    }
    return featureId.toJSTargetFeature(featureset);
  }
}

extension JSTargetDescriptorExtension on JSTargetDescriptor {
  FeaturesetDescriptor get featuresetDescriptor => FeaturesetDescriptor(
    featuresetId: featuresetId,
    importId: importId,
    layerId: layerId,
  );
}
