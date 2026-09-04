part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

/// Pairs the pigeon-generated [GesturesSettingsInterface] (settings host
/// API) with the four gesture-event broadcast streams produced by the
/// `MapEventChannel` event channels.
class GesturesController extends GesturesSettingsInterface
    implements GesturesSettingsPlatformInterface {
  GesturesController({super.binaryMessenger, super.messageChannelSuffix})
    : _channelSuffix = messageChannelSuffix;

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

  // Physical keyboards aren't a native mobile gesture source, so this
  // stream never emits. A broadcast controller (not `Stream.empty()`) keeps
  // it consistent with the interface's "streams are broadcast" contract —
  // `Stream.empty()` is single-subscription and completes immediately,
  // which would throw on a second listener.
  final _keyboardEventsController =
      StreamController<MapKeyboardGestureContext>.broadcast();

  @override
  Stream<MapKeyboardGestureContext> get keyboardEvents =>
      _keyboardEventsController.stream;
}
