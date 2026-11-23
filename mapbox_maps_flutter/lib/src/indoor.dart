import 'package:meta/meta.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

/// Manages indoor floor state and selection for the map.
///
/// [indoorUpdates] is a broadcast stream of the current [IndoorState]
/// (available floors and the currently-selected floor) for the venue
/// underneath the camera. Use [selectFloor] to change which floor is
/// displayed.
@experimental
final class IndoorManager {
  final IndoorPlatformInterface _impl;

  @internal
  IndoorManager(this._impl);

  /// Broadcast stream of indoor state changes.
  Stream<IndoorState> get indoorUpdates => _impl.indoorUpdates;

  /// Selects the floor with the given [floorId], or exits indoor floor
  /// selection when null.
  Future<void> selectFloor(String? floorId) => _impl.selectFloor(floorId);
}
