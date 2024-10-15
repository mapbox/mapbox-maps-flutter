part of mapbox_maps_flutter;

class OverviewViewportStateOptions {
  turf.GeometryObject geometry;
  EdgeInsets geometryPadding;
  double? bearing;
  double? pitch;
  EdgeInsets? padding;
  double? maxZoom;
  ScreenCoordinate? offset;
  Duration animationDuration;

  OverviewViewportStateOptions({
    required this.geometry,
    this.geometryPadding = const EdgeInsets.all(0),
    this.bearing = 0,
    this.pitch = 0,
    this.padding,
    this.maxZoom,
    this.offset,
    this.animationDuration = const Duration(seconds: 1),
  });
}

class OverviewViewportState implements ViewportState {
  final _OverviewViewportMessenger _messenger;

  OverviewViewportState._(this._messenger);

  Future<OverviewViewportStateOptions> getOptions() async {
    return _messenger.getInternalOptions().then((value) => value._options);
  }

  Future<void> setOptions(OverviewViewportStateOptions options) {
    return _messenger.setInternalOptions(options._internalOptions);
  }

  @override
  Cancelable observeDataSource(OnViewportCameraChange cameraChangeHandler) {
    return Cancelable();
  }

  @override
  void startUpdatingCamera() {}

  @override
  void stopUpdatingCamera() {}
}

extension on _OverviewViewportStateOptions {
  OverviewViewportStateOptions get _options {
    return OverviewViewportStateOptions(
      geometry: turf.GeometryObject.deserialize(jsonDecode(geometry)),
      geometryPadding: geometryPadding.toEdgeInsets(),
      bearing: bearing,
      pitch: pitch,
      padding: padding?.toEdgeInsets(),
      maxZoom: maxZoom,
      offset: offset,
      animationDuration: Duration(milliseconds: animationDurationMs),
    );
  }
}

extension on OverviewViewportStateOptions {
  _OverviewViewportStateOptions get _internalOptions {
    return _OverviewViewportStateOptions(
      geometry: jsonEncode(geometry),
      geometryPadding: _MbxEdgeInsetsCodable.fromEdgeInsets(geometryPadding),
      bearing: bearing,
      pitch: pitch,
      padding: padding != null
          ? _MbxEdgeInsetsCodable.fromEdgeInsets(padding!)
          : null,
      maxZoom: maxZoom,
      offset: offset,
      animationDurationMs: animationDuration.inMilliseconds,
    );
  }
}
