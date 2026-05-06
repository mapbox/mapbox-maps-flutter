import 'dart:typed_data';

import 'pigeons/platform_interface_data_types.dart' show LocationPuck2D;

/// Marker subclass of [LocationPuck2D] that signals the platform
/// implementation should fall back to the default 2D puck imagery
/// (top / bearing / shadow) for any sprite slot the caller leaves
/// unset.
///
/// `is DefaultLocationPuck2D` is the contract the mobile platform
/// implementation uses to differentiate "no override, use defaults"
/// from "explicit empty puck"; web throws on the surrounding
/// `updateSettings` call regardless.
class DefaultLocationPuck2D extends LocationPuck2D {
  DefaultLocationPuck2D({
    Uint8List? topImage,
    Uint8List? bearingImage,
    Uint8List? shadowImage,
    String? scaleExpression,
    double? opacity,
  }) : super(
         topImage: topImage,
         bearingImage: bearingImage,
         shadowImage: shadowImage,
         scaleExpression: scaleExpression,
         opacity: opacity,
       );
}
