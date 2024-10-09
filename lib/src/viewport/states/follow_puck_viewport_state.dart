part of mapbox_maps_flutter;

sealed class FollowPuckViewportStateBearing {
  const FollowPuckViewportStateBearing();
}

class FollowPuckViewportStateBearingConstant extends FollowPuckViewportStateBearing {
  final double bearing;

  FollowPuckViewportStateBearingConstant(this.bearing);
}
class FollowPuckViewportStateBearingHeading extends FollowPuckViewportStateBearing {
  const FollowPuckViewportStateBearingHeading();
}
// Works only on iOS
class FollowPuckViewportStateBearingCourse extends FollowPuckViewportStateBearing {}

class FollowPuckViewportStateOptions {
  final EdgeInsets? padding;
  final double? zoom;
  final FollowPuckViewportStateBearing? bearing;
  final double pitch;

  const FollowPuckViewportStateOptions({
    this.padding,
    this.zoom = 16.35,
    this.bearing = const FollowPuckViewportStateBearingHeading(),
    this.pitch = 45,
  });
}

class FollowPuckViewportState implements ViewportState {
  final FollowPuckViewportStateOptions options;

  FollowPuckViewportState._(this.options);
  
  @override
  Cancelable observeDataSource(OnViewportCameraChange cameraChangeHandler) {
    // TODO: implement observeDataSource
    throw UnimplementedError();
  }
  
  @override
  void startUpdatingCamera() {
    // TODO: implement startUpdatingCamera
  }
  
  @override
  void stopUpdatingCamera() {
    // TODO: implement stopUpdatingCamera
  }
}
