part of mapbox_maps_flutter;

// Multiple inheritance is not supported in Dart, so we need to create a new class
final class MapboxMapAdapter extends platform_interface.MapInterface {
  final MapboxMap mapboxMap;

  MapboxMapAdapter(this.mapboxMap);

  late final _events = StreamController<platform_interface.MapEvent>();

  @override
  Future<void> setCamera(platform_interface.CameraOptions cameraOptions) {
    final Point? center;
    if (cameraOptions.center != null) {
      center = Point(
        coordinates: turf.Position.named(
          lat: cameraOptions.center!.coordinates.lat,
          lng: cameraOptions.center!.coordinates.lng,
        ),
      );
    } else {
      center = null;
    }
    return mapboxMap.setCamera(CameraOptions(
      center: center,
      zoom: cameraOptions.zoom,
      bearing: cameraOptions.bearing,
      pitch: cameraOptions.pitch,
    ));
  }

  @override
  Stream<platform_interface.MapEvent> get events => _events.stream;
}

final class MapboxOptionsAdapter
    extends platform_interface.MapboxOptionsInterface {
  MapboxOptionsAdapter() : super.internal();

  @override
  Future<String> getAccessToken() {
    return MapboxOptions.getAccessToken();
  }

  @override
  void setAccessToken(String token) {
    return MapboxOptions.setAccessToken(token);
  }
}

final class MobileMapWidget extends platform_interface.PlatformMapWidget {
  @override
  platform_interface.MapInterface? get map => _map;

  MobileMapWidget() : super.internal();

  late final MapboxMapAdapter _map;

  @override
  Widget build(BuildContext context) {
    return MapWidget(onMapCreated: (controller) {
      _map = MapboxMapAdapter(controller);
      onMapCreated?.call(map!);
    }, onMapLoadErrorListener: (error) {
      print('Map load error: $error');
    }, onMapLoadedListener: (data) {
      _map._events.add(platform_interface.MapLoaded());
    });
  }
}

final class DartMobileMapPlugin {
  static void registerWith() {
    platform_interface.PlatformMapWidget.factory = () => MobileMapWidget();
    platform_interface.MapboxOptionsInterface.factory =
        () => MapboxOptionsAdapter();
  }
}
