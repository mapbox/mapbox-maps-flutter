part of 'package:mapbox_maps_flutter_mobile/mapbox_maps_flutter_mobile.dart';

extension on StyleDefaultViewportState {
  _ViewportStateStorage _toStorage() => _ViewportStateStorage(
    type: _ViewportStateType.styleDefault,
    options: null,
  );
}
