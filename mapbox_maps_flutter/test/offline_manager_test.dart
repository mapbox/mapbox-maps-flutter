import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MockOfflineManagerPlatformInterface
    implements OfflineManagerPlatformInterface {
  int loadStylePackCallCount = 0;
  int removeStylePackCallCount = 0;
  int stylePackCallCount = 0;
  int stylePackMetadataCallCount = 0;
  int allStylePacksCallCount = 0;

  String? lastStyleURI;
  StylePackLoadOptions? lastLoadOptions;
  OnStylePackLoadProgressListener? lastProgressListener;

  final StylePack _stubStylePack = StylePack(
    styleURI: 'mapbox://styles/mapbox/streets-v12',
    glyphsRasterizationMode: GlyphsRasterizationMode.NO_GLYPHS_RASTERIZED_LOCALLY,
    requiredResourceCount: 10,
    completedResourceCount: 10,
    completedResourceSize: 1024,
    expires: null,
  );

  @override
  Future<StylePack> loadStylePack(
    String styleURI,
    StylePackLoadOptions loadOptions,
    OnStylePackLoadProgressListener? progressListener,
  ) async {
    loadStylePackCallCount++;
    lastStyleURI = styleURI;
    lastLoadOptions = loadOptions;
    lastProgressListener = progressListener;
    return _stubStylePack;
  }

  @override
  Future<StylePack> removeStylePack(String styleURI) async {
    removeStylePackCallCount++;
    lastStyleURI = styleURI;
    return _stubStylePack;
  }

  @override
  Future<StylePack> stylePack(String styleURI) async {
    stylePackCallCount++;
    lastStyleURI = styleURI;
    return _stubStylePack;
  }

  @override
  Future<Map<String, Object>> stylePackMetadata(String styleURI) async {
    stylePackMetadataCallCount++;
    lastStyleURI = styleURI;
    return {'name': 'Streets'};
  }

  @override
  Future<List<StylePack>> allStylePacks() async {
    allStylePacksCallCount++;
    return [_stubStylePack];
  }
}

void main() {
  late MockOfflineManagerPlatformInterface mockImpl;
  late OfflineManager offlineManager;

  setUp(() {
    mockImpl = MockOfflineManagerPlatformInterface();
    offlineManager = OfflineManager(mockImpl);
  });

  group('OfflineManager', () {
    test('loadStylePack delegates to interface', () async {
      final loadOptions = StylePackLoadOptions(
        glyphsRasterizationMode:
            GlyphsRasterizationMode.NO_GLYPHS_RASTERIZED_LOCALLY,
        metadata: {},
        acceptExpired: false,
      );
      void progressListener(StylePackLoadProgress progress) {}

      final result = await offlineManager.loadStylePack(
        'mapbox://styles/mapbox/streets-v12',
        loadOptions,
        progressListener,
      );

      expect(mockImpl.loadStylePackCallCount, 1);
      expect(mockImpl.lastStyleURI, 'mapbox://styles/mapbox/streets-v12');
      expect(mockImpl.lastLoadOptions, same(loadOptions));
      expect(mockImpl.lastProgressListener, progressListener);
      expect(result.styleURI, 'mapbox://styles/mapbox/streets-v12');
    });

    test('removeStylePack delegates to interface', () async {
      final result = await offlineManager
          .removeStylePack('mapbox://styles/mapbox/streets-v12');

      expect(mockImpl.removeStylePackCallCount, 1);
      expect(mockImpl.lastStyleURI, 'mapbox://styles/mapbox/streets-v12');
      expect(result.styleURI, 'mapbox://styles/mapbox/streets-v12');
    });

    test('stylePack delegates to interface', () async {
      final result =
          await offlineManager.stylePack('mapbox://styles/mapbox/streets-v12');

      expect(mockImpl.stylePackCallCount, 1);
      expect(mockImpl.lastStyleURI, 'mapbox://styles/mapbox/streets-v12');
      expect(result.styleURI, 'mapbox://styles/mapbox/streets-v12');
    });

    test('stylePackMetadata delegates to interface', () async {
      final result = await offlineManager
          .stylePackMetadata('mapbox://styles/mapbox/streets-v12');

      expect(mockImpl.stylePackMetadataCallCount, 1);
      expect(mockImpl.lastStyleURI, 'mapbox://styles/mapbox/streets-v12');
      expect(result, {'name': 'Streets'});
    });

    test('allStylePacks delegates to interface', () async {
      final result = await offlineManager.allStylePacks();

      expect(mockImpl.allStylePacksCallCount, 1);
      expect(result.length, 1);
    });
  });
}
