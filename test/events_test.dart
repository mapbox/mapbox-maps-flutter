import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:test/test.dart';

void main() {
  test('CameraChangedEventData fromJson', () {
    var cameraChangedEventData = CameraChangedEventData.fromJson(
        <String, dynamic>{'begin': 1, 'end': 2});
    expect(cameraChangedEventData.begin, 1);
    expect(cameraChangedEventData.end, 2);
  });

  test('MapIdleEventData fromJson', () {
    var mapIdleEventData =
        MapIdleEventData.fromJson(<String, dynamic>{'begin': 1, 'end': 2});
    expect(mapIdleEventData.begin, 1);
    expect(mapIdleEventData.end, 2);
  });

  test('MapLoadedEventData fromJson', () {
    var mapLoadedEventData =
        MapLoadedEventData.fromJson(<String, dynamic>{'begin': 1, 'end': 2});
    expect(mapLoadedEventData.begin, 1);
    expect(mapLoadedEventData.end, 2);
  });

  test('MapLoadingErrorEventData fromJson', () {
    var mapLoadingErrorEventData =
        MapLoadingErrorEventData.fromJson(<String, dynamic>{
      'begin': 1,
      'end': 2,
      'type': 'style',
      'message': 'message',
      'source-id': 'source',
      'tile-id': <String, dynamic>{'x': 1, 'y': 2, 'z': 3}
    });
    expect(mapLoadingErrorEventData.begin, 1);
    expect(mapLoadingErrorEventData.end, 2);
    expect(mapLoadingErrorEventData.type, MapLoadErrorType.STYLE);
    expect(mapLoadingErrorEventData.message, 'message');
    expect(mapLoadingErrorEventData.sourceId, 'source');
    expect(mapLoadingErrorEventData.tileId, isNotNull);
    expect(mapLoadingErrorEventData.tileId!.x, 1);
    expect(mapLoadingErrorEventData.tileId!.y, 2);
    expect(mapLoadingErrorEventData.tileId!.z, 3);
  });

  test('MapLoadingErrorEventData fromJson with null value', () {
    var mapLoadingErrorEventData =
        MapLoadingErrorEventData.fromJson(<String, dynamic>{
      'begin': 1,
      'end': 2,
      'type': 'style',
      'message': 'message'
    });
    expect(mapLoadingErrorEventData.begin, 1);
    expect(mapLoadingErrorEventData.end, 2);
    expect(mapLoadingErrorEventData.type, MapLoadErrorType.STYLE);
    expect(mapLoadingErrorEventData.message, 'message');
    expect(mapLoadingErrorEventData.sourceId, isNull);
    expect(mapLoadingErrorEventData.tileId, isNull);
  });

  test('RenderFrameFinishedEventData fromJson', () {
    var renderFrameFinishedEventData =
        RenderFrameFinishedEventData.fromJson(<String, dynamic>{
      'begin': 1,
      'end': 2,
      'render-mode': 'full',
      'placement-changed': true,
      'needs-repaint': false
    });
    expect(renderFrameFinishedEventData.begin, 1);
    expect(renderFrameFinishedEventData.end, 2);
    expect(renderFrameFinishedEventData.renderMode, RenderMode.FULL);
    expect(renderFrameFinishedEventData.placementChanged, true);
    expect(renderFrameFinishedEventData.needsRepaint, false);
  });

  test('RenderFrameStartedEventData fromJson', () {
    var renderFrameStartedEventData = RenderFrameStartedEventData.fromJson(
        <String, dynamic>{'begin': 1, 'end': 2});
    expect(renderFrameStartedEventData.begin, 1);
    expect(renderFrameStartedEventData.end, 2);
  });

  test('ResourceEventData fromJson', () {
    var resourceEventData = ResourceEventData.fromJson(<String, dynamic>{
      'begin': 1,
      'end': 2,
      'cancelled': false,
      'data-source': 'network',
      'request': <String, dynamic>{
        'loading-method': ['network'],
        'url': 'https://api.mapbox.com',
        'kind': 'tile',
        'priority': 'regular'
      },
      'response': <String, dynamic>{
        'etag': 'd8abd8d10bee6b45b4dbf5c05496587a',
        'must-revalidate': false,
        'no-content': false,
        'modified': 'Mon, 05 Oct 2020 14:23:52 GMT',
        'source': 'network',
        'not-modified': false,
        'expires': 'Thu, 15 Oct 2020 14:32:23 GMT',
        'size': 181576,
        'error': <String, dynamic>{
          'reason': 'not-found',
          'message': 'error message'
        }
      }
    });
    expect(resourceEventData.begin, 1);
    expect(resourceEventData.end, 2);
    expect(resourceEventData.cancelled, false);
    expect(resourceEventData.dataSource, DataSourceType.NETWORK);
    expect(resourceEventData.request.kind, RequestType.TILE);
    expect(resourceEventData.request.loadingMethod, ['network']);
    expect(resourceEventData.request.url, 'https://api.mapbox.com');
    expect(resourceEventData.request.priority, RequestPriority.REGULAR);
    expect(
        resourceEventData.response!.eTag, 'd8abd8d10bee6b45b4dbf5c05496587a');
    expect(resourceEventData.response!.mustRevalidate, false);
    expect(resourceEventData.response!.noContent, false);
    expect(resourceEventData.response!.source, ResponseSourceType.NETWORK);
    expect(resourceEventData.response!.notModified, false);
    expect(
        resourceEventData.response!.expires, 'Thu, 15 Oct 2020 14:32:23 GMT');
    expect(resourceEventData.response!.size, 181576);
    expect(resourceEventData.response!.error!.reason,
        ResponseErrorReason.NOT_FOUND);
    expect(resourceEventData.response!.error!.message, 'error message');
  });

  test('SourceAddedEventData fromJson', () {
    var sourceAddedEventData = SourceAddedEventData.fromJson(
        <String, dynamic>{'begin': 1, 'end': 2, 'id': 'id'});
    expect(sourceAddedEventData.begin, 1);
    expect(sourceAddedEventData.end, 2);
    expect(sourceAddedEventData.id, 'id');
  });

  test('SourceDataLoadedEventData fromJson', () {
    var sourceDataLoadedEventData =
        SourceDataLoadedEventData.fromJson(<String, dynamic>{
      'begin': 1,
      'end': 2,
      'id': 'id',
      'type': 'tile',
      'loaded': false,
      'tile-id': <String, dynamic>{'x': 1, 'y': 2, 'z': 3}
    });
    expect(sourceDataLoadedEventData.begin, 1);
    expect(sourceDataLoadedEventData.end, 2);
    expect(sourceDataLoadedEventData.id, 'id');
    expect(sourceDataLoadedEventData.tileID!.x, 1);
    expect(sourceDataLoadedEventData.tileID!.y, 2);
    expect(sourceDataLoadedEventData.tileID!.z, 3);
  });

  test('SourceRemovedEventData fromJson', () {
    var sourceRemovedEventData = SourceRemovedEventData.fromJson(
        <String, dynamic>{'begin': 1, 'end': 2, 'id': 'id'});
    expect(sourceRemovedEventData.begin, 1);
    expect(sourceRemovedEventData.end, 2);
    expect(sourceRemovedEventData.id, 'id');
  });

  test('StyleDataLoadedEventData fromJson', () {
    var styleDataLoadedEventData = StyleDataLoadedEventData.fromJson(
        <String, dynamic>{'begin': 1, 'end': 2, 'type': 'style'});
    expect(styleDataLoadedEventData.begin, 1);
    expect(styleDataLoadedEventData.end, 2);
    expect(styleDataLoadedEventData.type, StyleDataType.STYLE);
  });

  test('StyleImageMissingEventData fromJson', () {
    var styleImageMissingEventData = StyleImageMissingEventData.fromJson(
        <String, dynamic>{'begin': 1, 'end': 2, 'id': 'id'});
    expect(styleImageMissingEventData.begin, 1);
    expect(styleImageMissingEventData.end, 2);
    expect(styleImageMissingEventData.id, 'id');
  });

  test('StyleImageUnusedEventData fromJson', () {
    var styleImageUnusedEventData = StyleImageUnusedEventData.fromJson(
        <String, dynamic>{'begin': 1, 'end': 2, 'id': 'id'});
    expect(styleImageUnusedEventData.begin, 1);
    expect(styleImageUnusedEventData.end, 2);
    expect(styleImageUnusedEventData.id, 'id');
  });

  test('StyleLoadedEventData fromJson', () {
    var styleLoadedEventData = StyleLoadedEventData.fromJson(
        <String, dynamic>{'begin': 1, 'end': 2, 'id': 'id'});
    expect(styleLoadedEventData.begin, 1);
    expect(styleLoadedEventData.end, 2);
  });
}
