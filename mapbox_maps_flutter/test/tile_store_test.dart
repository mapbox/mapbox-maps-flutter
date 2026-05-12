import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockTileStorePlatformInterface implements TileStorePlatformInterface {
  int loadTileRegionCallCount = 0;
  int estimateTileRegionCallCount = 0;
  int allTileRegionsCallCount = 0;
  int tileRegionCallCount = 0;
  int tileRegionContainsDescriptorCallCount = 0;
  int tileRegionMetadataCallCount = 0;
  int removeRegionCallCount = 0;
  int setDiskQuotaCallCount = 0;
  int setMapboxAPIUrlCallCount = 0;
  int setTileUrlTemplateCallCount = 0;

  String? lastId;
  TileRegionLoadOptions? lastLoadOptions;
  OnTileRegionLoadProgressListener? lastProgressListener;
  TileRegionEstimateOptions? lastEstimateOptions;
  OnTileRegionEstimateProgressListener? lastEstimateProgressListener;
  List<TilesetDescriptorOptions>? lastDescriptorOptions;
  int? lastQuota;
  TileDataDomain? lastDomain;
  Uri? lastUrl;
  String? lastTemplate;

  final TileRegion _stubTileRegion = TileRegion(
    id: 'test-region',
    requiredResourceCount: 100,
    completedResourceCount: 100,
    completedResourceSize: 2048,
    expires: null,
  );

  @override
  Future<TileRegion> loadTileRegion(
    String id,
    TileRegionLoadOptions loadOptions,
    OnTileRegionLoadProgressListener? progressListener,
  ) async {
    loadTileRegionCallCount++;
    lastId = id;
    lastLoadOptions = loadOptions;
    lastProgressListener = progressListener;
    return _stubTileRegion;
  }

  @override
  Future<TileRegionEstimateResult> estimateTileRegion(
    String id,
    TileRegionLoadOptions loadOptions,
    TileRegionEstimateOptions? estimateOptions,
    OnTileRegionEstimateProgressListener? progressListener,
  ) async {
    estimateTileRegionCallCount++;
    lastId = id;
    lastLoadOptions = loadOptions;
    lastEstimateOptions = estimateOptions;
    lastEstimateProgressListener = progressListener;
    return TileRegionEstimateResult(
      errorMargin: 0.1,
      transferSize: 512,
      storageSize: 1024,
    );
  }

  @override
  Future<List<TileRegion>> allTileRegions() async {
    allTileRegionsCallCount++;
    return [_stubTileRegion];
  }

  @override
  Future<TileRegion> tileRegion(String id) async {
    tileRegionCallCount++;
    lastId = id;
    return _stubTileRegion;
  }

  @override
  Future<bool> tileRegionContainsDescriptor(
    String id,
    List<TilesetDescriptorOptions> options,
  ) async {
    tileRegionContainsDescriptorCallCount++;
    lastId = id;
    lastDescriptorOptions = options;
    return true;
  }

  @override
  Future<Map<String, Object>> tileRegionMetadata(String id) async {
    tileRegionMetadataCallCount++;
    lastId = id;
    return {'name': 'Test Region'};
  }

  @override
  Future<TileRegion> removeRegion(String id) async {
    removeRegionCallCount++;
    lastId = id;
    return _stubTileRegion;
  }

  @override
  Future<void> setDiskQuota(int? quota, {TileDataDomain? domain}) async {
    setDiskQuotaCallCount++;
    lastQuota = quota;
    lastDomain = domain;
  }

  @override
  Future<void> setMapboxAPIUrl(Uri? url, {TileDataDomain? domain}) async {
    setMapboxAPIUrlCallCount++;
    lastUrl = url;
    lastDomain = domain;
  }

  @override
  Future<void> setTileUrlTemplate(
    String? template, {
    TileDataDomain? domain,
  }) async {
    setTileUrlTemplateCallCount++;
    lastTemplate = template;
    lastDomain = domain;
  }
}

void main() {
  late MockTileStorePlatformInterface mockImpl;
  late TileStore tileStore;

  setUp(() {
    mockImpl = MockTileStorePlatformInterface();
    tileStore = TileStore(mockImpl);
  });

  group('TileStore', () {
    test('loadTileRegion delegates to interface', () async {
      final loadOptions = TileRegionLoadOptions(
        descriptorsOptions: [],
        acceptExpired: false,
        networkRestriction: NetworkRestriction.NONE,
      );
      void progressListener(TileRegionLoadProgress progress) {}

      final result = await tileStore.loadTileRegion(
        'test-region',
        loadOptions,
        progressListener,
      );

      expect(mockImpl.loadTileRegionCallCount, 1);
      expect(mockImpl.lastId, 'test-region');
      expect(mockImpl.lastLoadOptions, same(loadOptions));
      expect(mockImpl.lastProgressListener, progressListener);
      expect(result.id, 'test-region');
    });

    test('estimateTileRegion delegates to interface', () async {
      final loadOptions = TileRegionLoadOptions(
        descriptorsOptions: [],
        acceptExpired: false,
        networkRestriction: NetworkRestriction.NONE,
      );
      final estimateOptions = TileRegionEstimateOptions(
        errorMargin: 0.1,
        preciseEstimationTimeout: 0,
        timeout: 0,
      );

      final result = await tileStore.estimateTileRegion(
        'test-region',
        loadOptions,
        estimateOptions,
        null,
      );

      expect(mockImpl.estimateTileRegionCallCount, 1);
      expect(mockImpl.lastId, 'test-region');
      expect(mockImpl.lastLoadOptions, same(loadOptions));
      expect(mockImpl.lastEstimateOptions, same(estimateOptions));
      expect(result.storageSize, 1024);
    });

    test('allTileRegions delegates to interface', () async {
      final result = await tileStore.allTileRegions();

      expect(mockImpl.allTileRegionsCallCount, 1);
      expect(result.length, 1);
    });

    test('tileRegion delegates to interface', () async {
      final result = await tileStore.tileRegion('test-region');

      expect(mockImpl.tileRegionCallCount, 1);
      expect(mockImpl.lastId, 'test-region');
      expect(result.id, 'test-region');
    });

    test('tileRegionContainsDescriptor delegates to interface', () async {
      final result = await tileStore.tileRegionContainsDescriptor(
        'test-region',
        [],
      );

      expect(mockImpl.tileRegionContainsDescriptorCallCount, 1);
      expect(mockImpl.lastId, 'test-region');
      expect(result, true);
    });

    test('tileRegionMetadata delegates to interface', () async {
      final result = await tileStore.tileRegionMetadata('test-region');

      expect(mockImpl.tileRegionMetadataCallCount, 1);
      expect(mockImpl.lastId, 'test-region');
      expect(result, {'name': 'Test Region'});
    });

    test('removeRegion delegates to interface', () async {
      final result = await tileStore.removeRegion('test-region');

      expect(mockImpl.removeRegionCallCount, 1);
      expect(mockImpl.lastId, 'test-region');
      expect(result.id, 'test-region');
    });

    test('setDiskQuota delegates to interface', () async {
      await tileStore.setDiskQuota(500);

      expect(mockImpl.setDiskQuotaCallCount, 1);
      expect(mockImpl.lastQuota, 500);
    });

    test('setMapboxAPIUrl delegates to interface', () async {
      final url = Uri.parse('https://api.mapbox.com');
      await tileStore.setMapboxAPIUrl(url);

      expect(mockImpl.setMapboxAPIUrlCallCount, 1);
      expect(mockImpl.lastUrl, url);
    });

    test('setTileUrlTemplate delegates to interface', () async {
      await tileStore.setTileUrlTemplate('https://example.com/{z}/{x}/{y}');

      expect(mockImpl.setTileUrlTemplateCallCount, 1);
      expect(mockImpl.lastTemplate, 'https://example.com/{z}/{x}/{y}');
    });
  });
}
