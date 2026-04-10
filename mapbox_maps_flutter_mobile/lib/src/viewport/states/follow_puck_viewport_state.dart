part of mapbox_maps_flutter_mobile;

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
        padding: padding,
      ),
    );
  }
}

extension on FollowPuckViewportStateBearing {
  (_FollowPuckViewportStateBearing, double?) get _internalBearing {
    switch (this) {
      case FollowPuckViewportStateBearingConstant(bearing: var bearingConstant):
        return (_FollowPuckViewportStateBearing.constant, bearingConstant);
      case FollowPuckViewportStateBearingHeading():
        return (_FollowPuckViewportStateBearing.heading, null);
      case FollowPuckViewportStateBearingCourse():
        return (_FollowPuckViewportStateBearing.course, null);
    }
  }
}
