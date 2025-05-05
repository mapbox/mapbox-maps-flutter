import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:test/test.dart';

void main() {
  test('CameraChangedEventData fromJson', () {
    final json = {
      'timestamp': 1,
      'cameraState': {
        'center': {'coordinates': [0, 0]},
        'padding': {'top': 0, 'left': 1, 'bottom': 2, 'right': 3},
        'zoom': 11,
        'bearing': 0,
        'pitch': 0,
      },
    };
    var cameraChangedEventData = CameraChangedEventData.fromJson(json);
    expect(cameraChangedEventData.timestamp, 1);
    expect(cameraChangedEventData.cameraState.center.coordinates, Position.of([0, 0]));
    expect(cameraChangedEventData.cameraState.padding.top, 0);
    expect(cameraChangedEventData.cameraState.padding.left, 1);
    expect(cameraChangedEventData.cameraState.padding.bottom, 2);
    expect(cameraChangedEventData.cameraState.padding.right, 3);
    expect(cameraChangedEventData.cameraState.zoom, 11);
    expect(cameraChangedEventData.cameraState.bearing, 0);
    expect(cameraChangedEventData.cameraState.pitch, 0);
  });

  test('MapIdleEventData fromJson', () {
    var mapIdleEventData =
        MapIdleEventData.fromJson(<String, dynamic>{'timestamp': 1});
    expect(mapIdleEventData.timestamp, 1);
  });

  test('MapLoadedEventData fromJson', () {
    var mapLoadedEventData = MapLoadedEventData.fromJson(<String, dynamic>{
      'timeInterval': <String, dynamic>{'begin': 1, 'end': 2}
    });
    expect(mapLoadedEventData.timeInterval.begin.microsecondsSinceEpoch, 1);
    expect(mapLoadedEventData.timeInterval.end.microsecondsSinceEpoch, 2);
  });

  test('MapLoadingErrorEventData fromJson', () {
    var mapLoadingErrorEventData =
        MapLoadingErrorEventData.fromJson(<String, dynamic>{
      'timestamp': 1,
      'end': 2,
      'type': 0,
      'message': 'message',
      'sourceId': 'source',
      'tileId': <String, dynamic>{'x': 1, 'y': 2, 'z': 3}
    });
    expect(mapLoadingErrorEventData.timestamp, 1);
    expect(mapLoadingErrorEventData.type, MapLoadErrorType.STYLE);
    expect(mapLoadingErrorEventData.message, 'message');
    expect(mapLoadingErrorEventData.sourceId, 'source');
    expect(mapLoadingErrorEventData.tileId, isNotNull);
    expect(mapLoadingErrorEventData.tileId!.x, 1);
    expect(mapLoadingErrorEventData.tileId!.y, 2);
    expect(mapLoadingErrorEventData.tileId!.z, 3);
  });

  test('MapLoadingErrorEventData fromJson with null value', () {
    var mapLoadingErrorEventData = MapLoadingErrorEventData.fromJson(
        <String, dynamic>{'timestamp': 1, 'type': 0, 'message': 'message'});
    expect(mapLoadingErrorEventData.timestamp, 1);
    expect(mapLoadingErrorEventData.type, MapLoadErrorType.STYLE);
    expect(mapLoadingErrorEventData.message, 'message');
    expect(mapLoadingErrorEventData.sourceId, isNull);
    expect(mapLoadingErrorEventData.tileId, isNull);
  });

  test('RenderFrameFinishedEventData fromJson', () {
    var renderFrameFinishedEventData =
        RenderFrameFinishedEventData.fromJson(<String, dynamic>{
      'timeInterval': <String, dynamic>{'begin': 1, 'end': 2},
      'renderMode': 1,
      'placementChanged': true,
      'needsRepaint': false
    });
    expect(
        renderFrameFinishedEventData.timeInterval.begin.microsecondsSinceEpoch,
        1);
    expect(renderFrameFinishedEventData.timeInterval.end.microsecondsSinceEpoch,
        2);
    expect(renderFrameFinishedEventData.renderMode, RenderMode.FULL);
    expect(renderFrameFinishedEventData.placementChanged, true);
    expect(renderFrameFinishedEventData.needsRepaint, false);
  });

  test('RenderFrameStartedEventData fromJson', () {
    var renderFrameStartedEventData =
        RenderFrameStartedEventData.fromJson(<String, dynamic>{'timestamp': 1});
    expect(renderFrameStartedEventData.timestamp, 1);
  });

  test('ResourceEventData fromJson', () {
    var resourceEventData = ResourceEventData.fromJson(<String, dynamic>{
      'timeInterval': <String, dynamic>{'begin': 1, 'end': 2},
      'cancelled': false,
      'source': 3,
      'request': <String, dynamic>{
        'loadingMethod': [0],
        'url': 'https://api.mapbox.com',
        'resource': 3,
        'priority': 0
      },
      'response': <String, dynamic>{
        'etag': 'd8abd8d10bee6b45b4dbf5c05496587a',
        'mustRevalidate': false,
        'noContent': false,
        'modified': 3,
        'source': 0,
        'notModified': false,
        'expires': 4,
        'size': 181576,
        'error': <String, dynamic>{'reason': 1, 'message': 'error message'}
      }
    });
    expect(resourceEventData.timeInterval.begin.microsecondsSinceEpoch, 1);
    expect(resourceEventData.timeInterval.end.microsecondsSinceEpoch, 2);
    expect(resourceEventData.cancelled, false);
    expect(resourceEventData.dataSource, DataSourceType.NETWORK);
    expect(resourceEventData.request.kind, RequestType.TILE);
    expect(resourceEventData.request.loadingMethod,
        [RequestLoadingMethodType.NETWORK]);
    expect(resourceEventData.request.url, 'https://api.mapbox.com');
    expect(resourceEventData.request.priority, RequestPriority.REGULAR);
    expect(
        resourceEventData.response!.eTag, 'd8abd8d10bee6b45b4dbf5c05496587a');
    expect(resourceEventData.response!.mustRevalidate, false);
    expect(resourceEventData.response!.noContent, false);
    expect(resourceEventData.response!.source, ResponseSourceType.NETWORK);
    expect(resourceEventData.response!.notModified, false);
    expect(resourceEventData.response!.modified?.microsecondsSinceEpoch, 3);
    expect(resourceEventData.response!.expires?.microsecondsSinceEpoch, 4);
    expect(resourceEventData.response!.size, 181576);
    expect(resourceEventData.response!.error!.reason,
        ResponseErrorReason.NOT_FOUND);
    expect(resourceEventData.response!.error!.message, 'error message');
  });

  test('SourceAddedEventData fromJson', () {
    var sourceAddedEventData = SourceAddedEventData.fromJson(
        <String, dynamic>{'timestamp': 1, 'sourceId': 'id'});
    expect(sourceAddedEventData.timestamp, 1);
    expect(sourceAddedEventData.id, 'id');
  });

  test('SourceDataLoadedEventData fromJson', () {
    var sourceDataLoadedEventData =
        SourceDataLoadedEventData.fromJson(<String, dynamic>{
      'timeInterval': <String, dynamic>{'begin': 1, 'end': 2},
      'sourceId': 'id',
      'type': 1,
      'loaded': false,
      'tileId': <String, dynamic>{'x': 1, 'y': 2, 'z': 3}
    });
    expect(
        sourceDataLoadedEventData.timeInterval.begin.microsecondsSinceEpoch, 1);
    expect(
        sourceDataLoadedEventData.timeInterval.end.microsecondsSinceEpoch, 2);
    expect(sourceDataLoadedEventData.id, 'id');
    expect(sourceDataLoadedEventData.type, SourceDataType.TILE);
    expect(sourceDataLoadedEventData.loaded, false);
    expect(sourceDataLoadedEventData.tileID!.x, 1);
    expect(sourceDataLoadedEventData.tileID!.y, 2);
    expect(sourceDataLoadedEventData.tileID!.z, 3);
  });

  test('SourceRemovedEventData fromJson', () {
    var sourceRemovedEventData = SourceRemovedEventData.fromJson(
        <String, dynamic>{'timestamp': 1, 'sourceId': 'id'});
    expect(sourceRemovedEventData.timestamp, 1);
    expect(sourceRemovedEventData.id, 'id');
  });

  test('StyleDataLoadedEventData fromJson', () {
    var styleDataLoadedEventData =
        StyleDataLoadedEventData.fromJson(<String, dynamic>{
      'timeInterval': <String, dynamic>{'begin': 1, 'end': 2},
      'type': 0
    });
    expect(
        styleDataLoadedEventData.timeInterval.begin.microsecondsSinceEpoch, 1);
    expect(styleDataLoadedEventData.type, StyleDataType.STYLE);
  });

  test('StyleImageMissingEventData fromJson', () {
    var styleImageMissingEventData = StyleImageMissingEventData.fromJson(
        <String, dynamic>{'timestamp': 1, 'imageId': 'id'});
    expect(styleImageMissingEventData.timestamp, 1);
    expect(styleImageMissingEventData.id, 'id');
  });

  test('StyleImageUnusedEventData fromJson', () {
    var styleImageUnusedEventData = StyleImageUnusedEventData.fromJson(
        <String, dynamic>{'timestamp': 1, 'imageId': 'id'});
    expect(styleImageUnusedEventData.timestamp, 1);
    expect(styleImageUnusedEventData.id, 'id');
  });

  test('StyleLoadedEventData fromJson', () {
    var styleLoadedEventData = StyleLoadedEventData.fromJson(<String, dynamic>{
      'timeInterval': <String, dynamic>{'begin': 1, 'end': 2}
    });
    expect(styleLoadedEventData.timeInterval.begin.microsecondsSinceEpoch, 1);
    expect(styleLoadedEventData.timeInterval.end.microsecondsSinceEpoch, 2);
  });
}
