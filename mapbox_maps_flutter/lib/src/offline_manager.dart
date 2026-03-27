import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// Manages offline style packages for the Mapbox SDK.
class OfflineManager {
  final OfflineManagerPlatformInterface _impl;

  @internal
  OfflineManager(this._impl);

  /// Loads or updates a style package.
  Future<StylePack> loadStylePack(
    String styleURI,
    StylePackLoadOptions loadOptions,
    OnStylePackLoadProgressListener? progressListener,
  ) =>
      _impl.loadStylePack(styleURI, loadOptions, progressListener);

  /// Removes a style package.
  Future<StylePack> removeStylePack(String styleURI) =>
      _impl.removeStylePack(styleURI);

  /// Returns a style package by its style URI.
  Future<StylePack> stylePack(String styleURI) => _impl.stylePack(styleURI);

  /// Returns the metadata associated with a style package.
  Future<Map<String, Object>> stylePackMetadata(String styleURI) =>
      _impl.stylePackMetadata(styleURI);

  /// Returns all existing style packages.
  Future<List<StylePack>> allStylePacks() => _impl.allStylePacks();
}
