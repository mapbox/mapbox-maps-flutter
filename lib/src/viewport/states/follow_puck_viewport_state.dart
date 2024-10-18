part of mapbox_maps_flutter;

sealed class FollowPuckViewportStateBearing {
  const FollowPuckViewportStateBearing();
}

class FollowPuckViewportStateBearingConstant
    extends FollowPuckViewportStateBearing {
  final double bearing;

  const FollowPuckViewportStateBearingConstant(this.bearing);
}

class FollowPuckViewportStateBearingHeading
    extends FollowPuckViewportStateBearing {
  const FollowPuckViewportStateBearingHeading();
}

// Works only on iOS
class FollowPuckViewportStateBearingCourse
    extends FollowPuckViewportStateBearing {
  const FollowPuckViewportStateBearingCourse();
}

final class FollowPuckViewportState extends ViewportState {
  final double? zoom;
  final FollowPuckViewportStateBearing? bearing;
  final double? pitch;

  const FollowPuckViewportState({
    this.zoom = 16.35,
    this.bearing = const FollowPuckViewportStateBearingHeading(),
    this.pitch = 45,
  }) : super();
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
