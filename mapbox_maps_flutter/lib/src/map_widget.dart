import 'package:flutter/widgets.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface.dart';

import 'mapbox_map.dart';
import 'mapbox_styles.dart';

typedef MapCreatedCallback = MapboxMapCreatedCallback<MapboxMap>;

/// A widget that displays a Mapbox map using the Mapbox Maps Flutter SDK.
///
/// You use this class to display map information and to manipulate the map contents from your application.
/// You can center the map on a given coordinate, specify the size of the area you want to display,
/// and style the features of the map to fit your application's use case.
///
/// Use of MapWidget requires a Mapbox API access token.
/// Obtain an access token on the [Mapbox account page](https://www.mapbox.com/studio/account/tokens/).
///
/// <strong>Warning:</strong> Please note that you are responsible for getting permission to use the map data,
/// and for ensuring your use adheres to the relevant terms of use.
class MapWidget extends StatelessWidget {
  final MapboxMapsFlutterPlatform _platform;

  /// The styleUri will applied for the MapWidget in the onStart lifecycle event if no style is set. Default is [MapboxStyles.STANDARD].
  final String styleUri;

  /// Called when the map is created and ready for interaction.
  final MapCreatedCallback? onMapCreated;

  /// Invoked when the requested style has been fully loaded, including the style, specified sprite and sources' metadata.
  final OnStyleLoadedListener? onStyleLoadedListener;

  /// Invoked whenever camera position changes.
  final OnCameraChangeListener? onCameraChangeListener;

  /// Invoked when the Map has entered the idle state. The Map is in the idle state when there are no ongoing transitions
  /// and the Map has rendered all available tiles.
  final OnMapIdleListener? onMapIdleListener;

  /// Invoked when the Map's style has been fully loaded, and the Map has rendered all visible tiles.
  final OnMapLoadedListener? onMapLoadedListener;

  /// Invoked whenever the map load errors out.
  final OnMapLoadErrorListener? onMapLoadErrorListener;

  /// Invoked whenever the Map started rendering a frame.
  final OnRenderFrameStartedListener? onRenderFrameStartedListener;

  /// Invoked whenever the Map finished rendering a frame.
  /// The render-mode value tells whether the Map has all data ("full") required to render the visible viewport.
  /// The needs-repaint value provides information about ongoing transitions that trigger Map repaint.
  /// The placement-changed value tells if the symbol placement has been changed in the visible viewport.
  final OnRenderFrameFinishedListener? onRenderFrameFinishedListener;

  /// Invoked whenever the Source has been added with StyleManager#addStyleSource runtime API.
  final OnSourceAddedListener? onSourceAddedListener;

  /// Invoked when the requested source data has been loaded.
  final OnSourceDataLoadedListener? onSourceDataLoadedListener;

  /// Invoked whenever the Source has been removed with StyleManager#removeStyleSource runtime API.
  final OnSourceRemovedListener? onSourceRemovedListener;

  /// Invoked when the requested style data has been loaded.
  final OnStyleDataLoadedListener? onStyleDataLoadedListener;

  /// Invoked whenever a style has a missing image. This event is emitted when the Map renders visible tiles and
  /// one of the required images is missing in the sprite sheet. Subscriber has to provide the missing image
  /// by calling StyleManager#addStyleImage method.
  final OnStyleImageMissingListener? onStyleImageMissingListener;

  /// Invoked whenever an image added to the Style is no longer needed and can be removed using StyleManager#removeStyleImage method.
  final OnStyleImageUnusedListener? onStyleImageUnusedListener;

  /// Invoked when map makes a request to load required resources.
  final OnResourceRequestListener? onResourceRequestListener;

  MapWidget({
    super.key,
    this.styleUri = MapboxStyles.STANDARD,
    this.onMapCreated,
    this.onStyleLoadedListener,
    this.onCameraChangeListener,
    this.onMapIdleListener,
    this.onMapLoadedListener,
    this.onMapLoadErrorListener,
    this.onRenderFrameStartedListener,
    this.onRenderFrameFinishedListener,
    this.onSourceAddedListener,
    this.onSourceDataLoadedListener,
    this.onSourceRemovedListener,
    this.onStyleDataLoadedListener,
    this.onStyleImageMissingListener,
    this.onStyleImageUnusedListener,
    this.onResourceRequestListener,
  }) : _platform = MapboxMapsFlutterPlatform.instance;

  @override
  Widget build(BuildContext context) {
    return _platform.buildView(
      styleUri: styleUri,
      onMapCreated: onMapCreated != null
          ? (map) => onMapCreated!(MapboxMap(map))
          : null,
      onMapEvent: (event) {
        switch (event) {
          case StyleLoadedEventData():
            onStyleLoadedListener?.call(event);
          case CameraChangedEventData():
            onCameraChangeListener?.call(event);
          case MapIdleEventData():
            onMapIdleListener?.call(event);
          case MapLoadedEventData():
            onMapLoadedListener?.call(event);
          case MapLoadingErrorEventData():
            onMapLoadErrorListener?.call(event);
          case RenderFrameStartedEventData():
            onRenderFrameStartedListener?.call(event);
          case RenderFrameFinishedEventData():
            onRenderFrameFinishedListener?.call(event);
          case SourceAddedEventData():
            onSourceAddedListener?.call(event);
          case SourceRemovedEventData():
            onSourceRemovedListener?.call(event);
          case SourceDataLoadedEventData():
            onSourceDataLoadedListener?.call(event);
          case StyleDataLoadedEventData():
            onStyleDataLoadedListener?.call(event);
          case StyleImageMissingEventData():
            onStyleImageMissingListener?.call(event);
          case StyleImageUnusedEventData():
            onStyleImageUnusedListener?.call(event);
          case ResourceEventData():
            onResourceRequestListener?.call(event);
        }
      },
    );
  }
}
