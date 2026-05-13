@JS('mapboxgl')
library;

import 'dart:js_interop';

import 'map_bindings.dart';

/// GL JS `Interaction` config passed to `JSMap.addInteraction`.
@JS()
@anonymous
extension type JSInteraction._(JSObject _) implements JSObject {
  external factory JSInteraction({
    required String type,
    JSTargetDescriptor? target,
    JSObject? filter,
    required JSFunction handler,
  });
}

/// GL JS `TargetDescriptor` — `{layerId}` or `{featuresetId, importId?}`.
@JS()
@anonymous
extension type JSTargetDescriptor._(JSObject _) implements JSObject {
  external factory JSTargetDescriptor({
    String? featuresetId,
    String? importId,
    String? layerId,
  });

  external String? get featuresetId;
  external String? get importId;
  external String? get layerId;
}

/// Event payload delivered to a `JSInteraction.handler`.
@JS()
extension type JSInteractionEvent._(JSObject _) implements JSObject {
  external String get id;
  external JSScreenPoint get point;
  external JSLngLat get lngLat;
  external JSTargetFeature? get feature;
}

/// GL JS `TargetFeature`.
@JS()
extension type JSTargetFeature._(JSObject _) implements JSObject {
  external JSIdentifier? get id;
  external JSGeometry? get geometry;
  external JSDictionary<String, Object?>? get properties;
  external JSDictionary<String, Object?>? get state;
  external String? get namespace;
  external JSTargetDescriptor? get target;
}
