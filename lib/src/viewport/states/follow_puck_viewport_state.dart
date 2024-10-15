part of mapbox_maps_flutter;

sealed class FollowPuckViewportStateBearing {
  const FollowPuckViewportStateBearing();
}

class FollowPuckViewportStateBearingConstant
    extends FollowPuckViewportStateBearing {
  final double bearing;

  FollowPuckViewportStateBearingConstant(this.bearing);
}

class FollowPuckViewportStateBearingHeading
    extends FollowPuckViewportStateBearing {
  const FollowPuckViewportStateBearingHeading();
}

// Works only on iOS
class FollowPuckViewportStateBearingCourse
    extends FollowPuckViewportStateBearing {}

class FollowPuckViewportStateOptions {
  EdgeInsets? padding;
  double? zoom;
  FollowPuckViewportStateBearing? bearing;
  double? pitch;

  FollowPuckViewportStateOptions({
    this.padding,
    this.zoom = 16.35,
    this.bearing = const FollowPuckViewportStateBearingHeading(),
    this.pitch = 45,
  });
}

class FollowPuckViewportState implements ViewportState {
  final _FollowPuckViewportMessenger _messenger;

  FollowPuckViewportState._(this._messenger);

  Future<FollowPuckViewportStateOptions> getOptions() async {
    return _messenger.getInternalOptions().then((value) => value._options);
  }

  Future<void> setOptions(FollowPuckViewportStateOptions options) {
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

extension on _FollowPuckViewportStateOptions {
  FollowPuckViewportStateOptions get _options {
    final FollowPuckViewportStateBearing? bearing;
    switch (this.bearing) {
      case _FollowPuckViewportStateBearing.constant:
        bearing = FollowPuckViewportStateBearingConstant(bearingValue!);
        break;
      case _FollowPuckViewportStateBearing.heading:
        bearing = FollowPuckViewportStateBearingHeading();
        break;
      case _FollowPuckViewportStateBearing.course:
        bearing = FollowPuckViewportStateBearingCourse();
        break;
      default:
        bearing = null;
    }

    return FollowPuckViewportStateOptions(
      padding: padding?.toEdgeInsets(),
      zoom: zoom,
      bearing: bearing,
      pitch: pitch,
    );
  }
}

extension on FollowPuckViewportStateOptions {
  _FollowPuckViewportStateOptions get _internalOptions {
    final _FollowPuckViewportStateBearing? bearing;
    double? bearingValue;

    switch (this.bearing) {
      case FollowPuckViewportStateBearingConstant(bearing: var bearingConstant):
        bearing = _FollowPuckViewportStateBearing.constant;
        bearingValue = bearingConstant;
        break;
      case FollowPuckViewportStateBearingHeading():
        bearing = _FollowPuckViewportStateBearing.heading;
        break;
      case FollowPuckViewportStateBearingCourse():
        bearing = _FollowPuckViewportStateBearing.course;
        break;
      default:
        bearing = null;
    }

    return _FollowPuckViewportStateOptions(
      padding: padding?.toMbxEdgeInsets(),
      zoom: zoom,
      bearingValue: bearingValue,
      bearing: bearing,
      pitch: pitch,
    );
  }
}

extension on EdgeInsets {
  MbxEdgeInsets toMbxEdgeInsets() {
    return MbxEdgeInsets(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
    );
  }
}
