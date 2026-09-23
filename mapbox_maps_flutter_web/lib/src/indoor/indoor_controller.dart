import 'dart:async';
import 'dart:js_interop';

import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';
import 'package:meta/meta.dart';

import '../bindings/map_bindings.dart';

/// Web indoor floor state and selection, backed by GL JS's `Style.indoorManager`.
@experimental
class IndoorController implements IndoorPlatformInterface, Disposable {
  IndoorController(this._map) {
    // `style.indoorManager` doesn't exist until the style (re)loads and
    // enables indoor. `styledata` re-checks on every style/config change,
    // including a style swap that creates a new manager instance; `idle`
    // is a one-shot catch-up in case indoor was already enabled before we
    // attached — any later change is still caught by `styledata`.
    _map.on(JSMapEvents.styleData, _updateConnectionListener);
    _map.once(JSMapEvents.idle, _updateConnectionListener);
    _updateConnection();
  }

  final JSMap _map;
  JSIndoorManager? _manager;

  final _indoorStateController = StreamController<IndoorState>.broadcast();

  @override
  Stream<IndoorState> get indoorUpdates => _indoorStateController.stream;

  late final JSFunction _updateConnectionListener =
      (() => _updateConnection()).toJS;
  late final JSFunction _onIndoorUpdateListener =
      ((JSIndoorControlModel model) {
        _indoorStateController.add(model.toIndoorState());
      }).toJS;

  void _updateConnection() {
    final manager = _map.style?.indoorManager;
    if (manager == null) return;
    if (manager != _manager) {
      manager.on(JSIndoorEvents.selectorUpdate, _onIndoorUpdateListener);
      _manager = manager;
      _indoorStateController.add(manager.getControlState().toIndoorState());
    }
  }

  @override
  Future<void> selectFloor(String? floorId) async {
    final manager = _manager;
    if (manager == null) return;
    manager.setActiveFloorsVisibility(floorId != null);
    manager.selectFloor(floorId);
  }

  @override
  void dispose() {
    _map.off(JSMapEvents.styleData, _updateConnectionListener);
    _map.off(JSMapEvents.idle, _updateConnectionListener);
    _manager?.off(JSIndoorEvents.selectorUpdate, _onIndoorUpdateListener);
    _manager = null;
    _indoorStateController.close();
  }
}

extension on JSIndoorControlModel {
  IndoorState toIndoorState() {
    final floorId = selectedFloorId;
    // IndoorManager.selectFloor(null) keeps the previously active floor set
    // (see IndoorActiveFloorStrategy), so getControlState().selectedFloorId
    // doesn't actually go back to null when clearing the selection.
    // activeFloorsVisible is the reliable signal for "nothing selected".
    final hasSelection = activeFloorsVisible && floorId != null && floorId.isNotEmpty;
    return IndoorState(
      floors: floors.toDart
          .map((f) => IndoorFloor(id: f.id, name: f.name))
          .toList(),
      selectedFloorId: hasSelection ? floorId : null,
    );
  }
}
