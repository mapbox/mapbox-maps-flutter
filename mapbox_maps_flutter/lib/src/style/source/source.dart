import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:meta/meta.dart';

/// Base class for all style sources.
abstract base class Source {
  Source({required this.id});

  /// The ID of the Source.
  String id;

  StylePlatformInterface? _style;

  /// Platform-interface handle bound via [bind] once the source is added to
  /// a style. Subclasses use it to read volatile properties back from the
  /// native runtime.
  @protected
  StylePlatformInterface? get style => _style;

  /// Returns the source's type as a String (e.g. "geojson", "vector").
  String getType();

  /// Encodes the source as a JSON string to be passed over the platform
  /// channel. [volatile] separates volatile (runtime-mutable) properties
  /// from the non-volatile add payload. Implemented by generated subclasses.
  @internal
  @mustBeOverridden
  String encode({required bool volatile});

  /// Binds this source to a style's platform interface. Called by
  /// [addToStyle] after the native-side add completes.
  @internal
  @mustCallSuper
  void bind(StylePlatformInterface platformStyle) {
    _style = platformStyle;
  }

  /// Adds this source to the given style via two Pigeon calls: first the
  /// non-volatile payload via `addStyleSource`, then the volatile payload
  /// via `setStyleSourceProperties`. Subclasses override to customize
  /// multi-phase adds (e.g. `GeoJsonSource` with initial data).
  @internal
  @mustCallSuper
  Future<void> addToStyle(StylePlatformInterface platformStyle) async {
    bind(platformStyle);
    await platformStyle.addStyleSource(id, encode(volatile: false));
    await platformStyle.setStyleSourceProperties(id, encode(volatile: true));
  }
}
