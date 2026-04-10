part of mapbox_maps_flutter_mobile;

extension on ViewportState {
  _ViewportStateStorage _toStorage() {
    return switch (this) {
      OverviewViewportState state => state._toStorage(),
      FollowPuckViewportState state => state._toStorage(),
      StyleDefaultViewportState state => state._toStorage(),
      CameraViewportState state => state._toStorage(),
      IdleViewportState state => state._toStorage(),
    };
  }
}

extension on EdgeInsets {
  MbxEdgeInsets get _toMbxEdgeInsets =>
      _MbxEdgeInsetsCodable.fromEdgeInsets(this);
}

extension on Offset {
  ScreenCoordinate get _toScreenCoordinate => ScreenCoordinate(x: dx, y: dy);
}
