import 'package:flutter/foundation.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

/// The [OfflineManager] provides a configuration interface and entrypoint for offline map functionality.
///
/// {@template supported_platforms_mobile}
/// **Supported platforms:** Android and iOS.
/// {@endtemplate}
///
/// By default, users may download up to 750 tile packs for offline
/// use across all regions. If the limit is hit, any loadRegion call
/// will fail until excess regions are deleted. This limit is subject
/// to change. Please contact Mapbox if you require a higher limit.
/// Additional charges may apply.
class OfflineManager {
  final OfflineManagerPlatformInterface _impl;

  @internal
  OfflineManager(this._impl);

  /// Creates a new instance of [OfflineManager].
  static Future<OfflineManager> create() async {
    final impl = await MapboxMapsFlutterPlatform.instance
        .createOfflineManager();
    return OfflineManager(impl);
  }

  /// Loads a new style package or updates the existing one.
  ///
  /// If a style package with the given id already exists, it is updated with
  /// the values provided to the given [loadOptions]. The missing resources get
  /// loaded and the expired resources get updated.
  ///
  /// If there are no values provided to the given [loadOptions], the existing
  /// style package gets refreshed: the missing resources get loaded and the
  /// expired resources get updated.
  ///
  /// A failed load request can be reattempted with another [loadStylePack] call.
  ///
  /// If the style cannot be fetched for any reason, the load request is terminated.
  /// If the style is fetched but loading some of the style package resources
  /// fails, the load request proceeds trying to load the remaining style package
  /// resources.
  ///
  /// [styleURI]: The URI of the style package's associated style.
  /// [loadOptions]: The style package load options.
  /// [progressListener]: Invoked when loading progress is updated.
  Future<StylePack> loadStylePack(
    String styleURI,
    StylePackLoadOptions loadOptions,
    OnStylePackLoadProgressListener? progressListener,
  ) => _impl.loadStylePack(styleURI, loadOptions, progressListener);

  /// Removes a style package.
  ///
  /// Removes a style package from the existing packages list. The actual
  /// resources eviction might be deferred. All pending loading operations for
  /// the style package with the given id will fail with Canceled error.
  ///
  /// [styleURI]: The URI of the style package's associated style.
  Future<StylePack> removeStylePack(String styleURI) =>
      _impl.removeStylePack(styleURI);

  /// Returns a style package by its style URI.
  ///
  /// [styleURI]: The URI of the style package's associated style.
  Future<StylePack> stylePack(String styleURI) => _impl.stylePack(styleURI);

  /// Returns a style package's associated metadata.
  ///
  /// [styleURI]: The URI of the style package's associated style.
  Future<Map<String, Object>> stylePackMetadata(String styleURI) =>
      _impl.stylePackMetadata(styleURI);

  /// Fetches an array of the existing style packages.
  Future<List<StylePack>> allStylePacks() => _impl.allStylePacks();
}
