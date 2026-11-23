import 'package:meta/meta.dart';

import '../pigeons/platform_interface_data_types.dart';

/// Interface for indoor floor state and floor selection.
@experimental
abstract interface class IndoorPlatformInterface {
  /// Broadcast stream of the current [IndoorState] (available floors and
  /// the selected floor) for the venue underneath the camera.
  Stream<IndoorState> get indoorUpdates;

  /// Selects the floor with the given [floorId], or exits indoor floor
  /// selection when null.
  Future<void> selectFloor(String? floorId);
}
