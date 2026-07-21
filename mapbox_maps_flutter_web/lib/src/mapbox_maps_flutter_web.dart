// AndroidPlatformViewHostingMode is @experimental on platform_interface;
// web buildView has to accept it for signature compat but ignores it.
// ignore_for_file: experimental_member_use

import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';
import 'package:mapbox_maps_flutter_web/src/gl_js_loader.dart';

import '../mapbox_maps_flutter_web.dart';

base class MapboxMapsFlutterWeb extends MapboxMapsFlutterPlatform
    implements
        MapboxOptionsPlatformInterface,
        MapboxMapsOptionsPlatformInterface {
  /// Registers the platform implementation.
  static void registerWith(Registrar registrar) {
    MapboxMapsFlutterPlatform.instance = MapboxMapsFlutterWeb();

    glJsReady.future.then((_) {
      setSdkInfo('FlutterPlugin/$mapboxPluginVersion');
    });
    // Warm up the loader eagerly. A failure is surfaced to whoever awaits
    // ensureMapboxGlJsLoaded() during map creation (and retried by the next
    // MapWidget), so swallow it here to avoid an unhandled async error.
    ensureMapboxGlJsLoaded().catchError((Object _) {});
  }

  @override
  Widget buildView({
    required String styleUri,
    PlatformMapCreatedCallback? onMapCreated,
    ViewportState? viewport,
    ViewportTransition? viewportTransition,
    void Function(bool)? viewportTransitionCompletion,
    void Function(MapEvent)? onMapEvent,
    MapOptions? mapOptions,
    bool? textureView,
    required AndroidPlatformViewHostingMode androidHostingMode,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
    bool? isOpaque = true,
  }) {
    // mapOptions / textureView / androidHostingMode / gestureRecognizers
    // are mobile-platform-view tuning knobs and are ignored on web.
    //
    // isOpaque is also ignored: gl-js always renders to an alpha-capable
    // canvas, so a transparent background works out of the box.
    return MapWebWidget(
      onMapCreated: onMapCreated,
      onMapEvent: onMapEvent,
      viewport: viewport,
      viewportTransition: viewportTransition,
      viewportTransitionCompletion: viewportTransitionCompletion,
    );
  }

  @override
  Future<String> getAccessToken() => glJsReady.future.then((_) => accessToken);
  @override
  void setAccessToken(String token) => glJsReady.future.then((_) => accessToken = token);

  @override
  Future<String> getBaseUrl() => glJsReady.future.then((_) => baseApiUrl);
  @override
  void setBaseUrl(String url) => glJsReady.future.then((_) => baseApiUrl = url);

  @override
  Future<String> getDataPath() =>
      throw UnimplementedError('getDataPath() is not implemented on web.');

  @override
  void setDataPath(String path) =>
      throw UnimplementedError('setDataPath() is not implemented on web.');

  @override
  Future<String> getAssetPath() =>
      throw UnimplementedError('getAssetPath() is not implemented on web.');

  @override
  void setAssetPath(String path) =>
      throw UnimplementedError('setAssetPath() is not implemented on web.');

  @override
  Future<String?> getFlutterAssetPath(String? flutterAssetUri) async {
    if (flutterAssetUri == null) return null;
    // `asset://assets/foo.glb` is a Flutter pseudo-scheme the mobile SDKs
    // resolve via Flutter's asset registrar. On web, Flutter bundles those
    // assets at `<base>/assets/<pubspec-asset-path>` (note the leading
    // `assets/` segment Flutter adds on top of whatever path was declared
    // in pubspec). Return an absolute URL: AssetManager handles the
    // `assets/` prefix and Uri.base anchors at the document base href.
    // The absolute form matters when the value lands in a layer's
    // `model-id` — gl-js's ModelBucket only routes it through the
    // URL-auto-load path when it contains `://` (see
    // 3d-style/data/bucket/model_bucket.ts), so a relative path is
    // silently dropped. Anything else (http(s), mapbox:, plain
    // identifier) passes through unchanged.
    if (!flutterAssetUri.startsWith('asset://')) return flutterAssetUri;
    final relative = flutterAssetUri.substring('asset://'.length);
    return Uri.base
        .resolve(ui_web.assetManager.getAssetUrl(relative))
        .toString();
  }

  @override
  Future<TileStoreUsageMode> getTileStoreUsageMode() =>
      throw UnimplementedError(
        'getTileStoreUsageMode() is not implemented on web.',
      );

  @override
  void setTileStoreUsageMode(TileStoreUsageMode mode) =>
      throw UnimplementedError(
        'setTileStoreUsageMode() is not implemented on web.',
      );

  @override
  Future<String?> getWorldview() =>
      throw UnimplementedError('getWorldview() is not implemented on web.');

  @override
  void setWorldview(String? worldview) =>
      throw UnimplementedError('setWorldview() is not implemented on web.');

  @override
  Future<String?> getLanguage() =>
      throw UnimplementedError('getLanguage() is not implemented on web.');

  @override
  void setLanguage(String? language) =>
      throw UnimplementedError('setLanguage() is not implemented on web.');

  @override
  Future<void> clearData() {
    final completer = Completer<void>();

    clearStorage(
      ([JSAny? error]) {
        if (error != null) {
          completer.completeError(error);
        } else {
          completer.complete();
        }
      }.toJS,
    );
    return completer.future;
  }

  @override
  MapboxMapsOptionsPlatformInterface get mapboxMapsOptions => this;

  @override
  MapboxOptionsPlatformInterface get mapboxOptions => this;

  @override
  OfflineSwitchPlatformInterface get offlineSwitch => throw UnsupportedError(
    'Offline functionalities are not supported on web.',
  );

  @override
  LogConfigurationPlatformInterface get logConfiguration =>
      throw UnsupportedError(
        'LogConfiguration is not supported on web; use the browser console.',
      );

  @override
  Future<OfflineManagerPlatformInterface> createOfflineManager() =>
      throw UnsupportedError(
        'Offline functionalities are not supported on web.',
      );

  @override
  Future<TileStorePlatformInterface> createTileStore({Uri? filePath}) =>
      throw UnsupportedError(
        'Offline functionalities are not supported on web.',
      );

  @override
  Future<SnapshotterPlatformInterface> createSnapshotter({
    required MapSnapshotOptions options,
    OnStyleLoadedListener? onStyleLoadedListener,
    OnMapLoadErrorListener? onMapLoadErrorListener,
    OnStyleDataLoadedListener? onStyleDataLoadedListener,
    OnStyleImageMissingListener? onStyleImageMissingListener,
  }) =>
      throw UnimplementedError(
        'MapboxMapsFlutterWeb.createSnapshotter is not yet implemented on web.',
      );
}
