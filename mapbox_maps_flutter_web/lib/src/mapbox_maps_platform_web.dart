part of mapbox_maps_flutter_web;

class MapboxMapsPlatformWeb extends MapboxMapsPlatformInterface {
  MapboxMapsPlatformWeb() : super();

  late DivElement _mapElement;
  late MapJsImpl _map;
  late Map<String, dynamic> _creationParams;

  @override
  void initPlatform(String channelSuffix) {
    final List<double> list = List.from(_creationParams['cameraOptions']
            ['center']['coordinates']
        .cast<double>());

    _map = MapJsImpl(MapOptionsJsImpl(
        container: _mapElement,
        style: _creationParams['styleUri'],
        center: list,
        zoom: _creationParams['cameraOptions']['zoom'],
        accessToken: _creationParams['resourceOptions']['accessToken']));
  }

  @override
  Widget buildView(
      Map<String, dynamic> creationParams,
      OnPlatformViewCreatedCallback onPlatformViewCreated,
      Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers) {
    _creationParams = creationParams;
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'plugins.flutter.io/mapbox_maps${this.hashCode}',
      (int viewId) {
        _mapElement = DivElement()
          ..style.position = 'absolute'
          ..style.top = '0'
          ..style.bottom = '0'
          ..style.width = '100%';
        onPlatformViewCreated(viewId);
        return _mapElement;
      },
    );
    return HtmlElementView(
        viewType: 'plugins.flutter.io/mapbox_maps${this.hashCode}');
  }

  @override
  void dispose() {
    _mapElement.remove();
  }
}
