part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

/// Pairs the pigeon-generated [_IndoorMessenger] (`selectFloor` host API)
/// with the [IndoorState] broadcast stream produced by the
/// `MapEventChannel` event channel.
@experimental
class IndoorController extends _IndoorMessenger
    implements IndoorPlatformInterface {
  IndoorController({super.binaryMessenger, super.messageChannelSuffix})
    : _channelSuffix = messageChannelSuffix;

  final String _channelSuffix;

  @override
  Stream<IndoorState> get indoorUpdates =>
      _indoorUpdates(instanceName: _channelSuffix);
}
