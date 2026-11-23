part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

/// Bridges the public [FreeCameraOptions] to its pigeon wire representation.
extension FreeCameraOptionsToWire on FreeCameraOptions {
  /// Converts to [FreeCameraOptionsWire]. Unset fields stay unset.
  FreeCameraOptionsWire toWire() => FreeCameraOptionsWire(
    position: switch (position) {
      final p? => [p.x, p.y, p.z],
      null => null,
    },
    orientation: switch (orientation) {
      final q? => [q.x, q.y, q.z, q.w],
      null => null,
    },
  );
}

/// Bridges [FreeCameraOptionsWire] to the public [FreeCameraOptions].
extension FreeCameraOptionsWireToFreeCameraOptions on FreeCameraOptionsWire {
  /// Converts to [FreeCameraOptions]. A list with the wrong length reads as
  /// unset.
  FreeCameraOptions toFreeCameraOptions() => FreeCameraOptions(
    position: switch (position) {
      [final x, final y, final z] => FreeCameraPosition(x: x, y: y, z: z),
      _ => null,
    },
    orientation: switch (orientation) {
      [final x, final y, final z, final w] => FreeCameraOrientation(
        x: x,
        y: y,
        z: z,
        w: w,
      ),
      _ => null,
    },
  );
}
