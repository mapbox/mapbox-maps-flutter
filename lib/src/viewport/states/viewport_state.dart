part of mapbox_maps_flutter;

sealed class ViewportState {
  const ViewportState();
}

extension on OverviewViewportState {
  _ViewportStateStorage _toStorage() => _ViewportStateStorage(
        type: _ViewportStateType.overview,
        options: _OverviewViewportStateOptions(
          geometry: jsonEncode(geometry),
          geometryPadding: geometryPadding._toMbxEdgeInsets,
          bearing: bearing,
          pitch: pitch,
          maxZoom: maxZoom,
          offset: offset?._toScreenCoordinate,
          animationDurationMs: animationDuration.inMilliseconds,
        ),
      );
}

extension on FollowPuckViewportState {
  _ViewportStateStorage _toStorage() {
    final internalBearing = bearing?._internalBearing;
    return _ViewportStateStorage(
        type: _ViewportStateType.followPuck,
        options: _FollowPuckViewportStateOptions(
          zoom: zoom,
          bearing: internalBearing?.$1,
          bearingValue: internalBearing?.$2,
          pitch: pitch,
        ),
      );
  }
}

extension on ViewportState {
  _ViewportStateStorage _toStorage() {
    return switch (this) {
      OverviewViewportState state => state._toStorage(),
      FollowPuckViewportState state => state._toStorage(),
      StyleDefaultViewportState() => throw UnimplementedError(),
      CameraViewportState() => throw UnimplementedError(),
      IdleViewportState() => throw UnimplementedError(),
    };
  }
}

extension on EdgeInsets {
  MbxEdgeInsets get _toMbxEdgeInsets => _MbxEdgeInsetsCodable.fromEdgeInsets(this);
}

extension on Offset {
  ScreenCoordinate get _toScreenCoordinate => ScreenCoordinate(x: dx, y: dy);
}
