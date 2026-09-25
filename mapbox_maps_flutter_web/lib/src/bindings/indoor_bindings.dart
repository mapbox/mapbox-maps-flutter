@JS('mapboxgl')
library;

import 'dart:js_interop';

import 'location_bindings.dart' show JSControl;

/// `Map.style`. Only [indoorManager] is bound here.
@JS()
extension type JSStyle._(JSObject _) implements JSObject {
  external JSIndoorManager? get indoorManager;
}

/// `mapboxgl.IndoorControl` — the built-in floor-selector ornament.
@JS('IndoorControl')
extension type JSIndoorControl._(JSObject _) implements JSControl {
  external JSIndoorControl();
}

/// `Style.indoorManager` — experimental, undocumented in GL JS.
@JS()
extension type JSIndoorManager._(JSObject _) implements JSObject {
  external void on(JSIndoorEvents event, JSFunction handler);
  external void off(JSIndoorEvents event, JSFunction handler);
  external JSIndoorControlModel getControlState();
  external void selectFloor(String? floorId);
  external void setActiveFloorsVisibility(bool visible);
}

extension type const JSIndoorEvents._(String value) {
  static const JSIndoorEvents selectorUpdate = JSIndoorEvents._(
    'selector-update',
  );
}

/// Payload of [JSIndoorEvents.selectorUpdate] / [JSIndoorManager.getControlState].
@JS()
@anonymous
extension type JSIndoorControlModel._(JSObject _) implements JSObject {
  external String? get selectedFloorId;
  external bool get activeFloorsVisible;
  external JSArray<JSIndoorControlFloor> get floors;
}

@JS()
@anonymous
extension type JSIndoorControlFloor._(JSObject _) implements JSObject {
  external String get id;
  external String get name;
  external double get zIndex;
}
