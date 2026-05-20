part of mapbox_maps_flutter_mobile;

/// Pairs the pigeon-generated [GesturesSettingsInterface] (settings host
/// API) with the four gesture-event broadcast streams produced by the
/// `MapEventChannel` event channels.
class GesturesController extends GesturesSettingsInterface
    implements GesturesSettingsPlatformInterface {
  GesturesController({super.binaryMessenger, String messageChannelSuffix = ''})
    : _channelSuffix = messageChannelSuffix,
      super(messageChannelSuffix: messageChannelSuffix);

  final String _channelSuffix;

  @override
  Stream<MapContentGestureContext> get panEvents =>
      _panEvents(instanceName: _channelSuffix);

  @override
  Stream<MapContentGestureContext> get zoomEvents =>
      _zoomEvents(instanceName: _channelSuffix);

  @override
  Stream<MapContentGestureContext> get rotateEvents =>
      _rotateEvents(instanceName: _channelSuffix);

  @override
  Stream<MapContentGestureContext> get pitchEvents =>
      _pitchEvents(instanceName: _channelSuffix);
}
