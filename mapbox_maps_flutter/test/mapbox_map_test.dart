import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:turf/turf.dart';

// ===== Stub sub-interfaces =====

class StubStylePlatformInterface implements StylePlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class StubGesturesSettingsPlatformInterface
    implements GesturesSettingsPlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class StubLocationSettingsPlatformInterface
    implements LocationSettingsPlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class StubScaleBarSettingsPlatformInterface
    implements ScaleBarSettingsPlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class StubCompassSettingsPlatformInterface
    implements CompassSettingsPlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class StubAttributionSettingsPlatformInterface
    implements AttributionSettingsPlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class StubLogoSettingsPlatformInterface
    implements LogoSettingsPlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class StubIndoorSelectorSettingsPlatformInterface
    implements IndoorSelectorSettingsPlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class StubAnnotationManagerPlatformInterface
    implements AnnotationManagerPlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class StubMapboxHttpServicePlatformInterface
    implements MapboxHttpServicePlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class StubProjectionPlatformInterface implements ProjectionPlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class StubMapRecorderPlatformInterface
    implements MapRecorderPlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}


// ===== Mock MapboxMapPlatformInterface =====

class MockMapboxMapPlatformInterface implements MapboxMapPlatformInterface {
  // Sub-interfaces
  @override
  final StylePlatformInterface style = StubStylePlatformInterface();
  @override
  final GesturesSettingsPlatformInterface gestures =
      StubGesturesSettingsPlatformInterface();
  @override
  final LocationSettingsPlatformInterface location =
      StubLocationSettingsPlatformInterface();
  @override
  final ScaleBarSettingsPlatformInterface scaleBar =
      StubScaleBarSettingsPlatformInterface();
  @override
  final CompassSettingsPlatformInterface compass =
      StubCompassSettingsPlatformInterface();
  @override
  final AttributionSettingsPlatformInterface attribution =
      StubAttributionSettingsPlatformInterface();
  @override
  final LogoSettingsPlatformInterface logo =
      StubLogoSettingsPlatformInterface();
  @override
  final IndoorSelectorSettingsPlatformInterface indoorSelector =
      StubIndoorSelectorSettingsPlatformInterface();
  @override
  final AnnotationManagerPlatformInterface annotations =
      StubAnnotationManagerPlatformInterface();
  @override
  final MapboxHttpServicePlatformInterface httpService =
      StubMapboxHttpServicePlatformInterface();
  @override
  final ProjectionPlatformInterface projection =
      StubProjectionPlatformInterface();
  @override
  final MapRecorderPlatformInterface mapRecorder =
      StubMapRecorderPlatformInterface();

  // Gesture listeners
  @override
  OnMapTapListener? onMapTapListener;
  @override
  OnMapLongTapListener? onMapLongTapListener;
  @override
  OnMapScrollListener? onMapScrollListener;
  @override
  OnMapZoomListener? onMapZoomListener;

  // Call counts
  int loadStyleURICallCount = 0;
  int loadStyleJsonCallCount = 0;
  int getCameraStateCallCount = 0;
  int setCameraCallCount = 0;
  int cameraForCoordinatesPaddingCallCount = 0;
  int cameraForCoordinateBoundsCallCount = 0;
  int cameraForCoordinatesCallCount = 0;
  int coordinateBoundsForCameraCallCount = 0;
  int coordinateBoundsForCameraUnwrappedCallCount = 0;
  int coordinateBoundsZoomForCameraCallCount = 0;
  int coordinateBoundsZoomForCameraUnwrappedCallCount = 0;
  int setBoundsCallCount = 0;
  int getBoundsCallCount = 0;
  int easeToCallCount = 0;
  int flyToCallCount = 0;
  int pitchByCallCount = 0;
  int scaleByCallCount = 0;
  int moveByCallCount = 0;
  int rotateByCallCount = 0;
  int cancelCameraAnimationCallCount = 0;
  int pixelForCoordinateCallCount = 0;
  int coordinateForPixelCallCount = 0;
  int pixelsForCoordinatesCallCount = 0;
  int coordinatesForPixelsCallCount = 0;
  int getSizeCallCount = 0;
  int triggerRepaintCallCount = 0;
  int getElevationCallCount = 0;
  int reduceMemoryUseCallCount = 0;
  int setTileCacheBudgetCallCount = 0;
  int setNorthOrientationCallCount = 0;
  int setConstrainModeCallCount = 0;
  int setViewportModeCallCount = 0;
  int disposeCallCount = 0;

  // Captured arguments
  String? lastStyleURI;
  String? lastStyleJson;
  CameraOptions? lastCameraOptions;
  CameraBoundsOptions? lastCameraBoundsOptions;
  MapAnimationOptions? lastMapAnimationOptions;
  List<Point>? lastCoordinates;
  MbxEdgeInsets? lastPadding;
  double? lastBearing;
  double? lastPitch;
  double? lastMaxZoom;
  ScreenCoordinate? lastOffset;
  CoordinateBounds? lastBounds;
  Point? lastCoordinate;
  ScreenCoordinate? lastPixel;
  ScreenCoordinate? lastAnchor;
  double? lastAmount;
  ScreenCoordinate? lastFirst;
  ScreenCoordinate? lastSecond;
  ScreenCoordinate? lastScreenCoordinate;
  List<ScreenCoordinate?>? lastPixels;
  TileCacheBudgetInMegabytes? lastTileCacheBudgetInMegabytes;
  TileCacheBudgetInTiles? lastTileCacheBudgetInTiles;
  NorthOrientation? lastNorthOrientation;
  ConstrainMode? lastConstrainMode;
  ViewportMode? lastViewportMode;

  // Return values
  CameraState cameraStateToReturn = CameraState(
    center: Point(coordinates: Position(0, 0)),
    padding: MbxEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
    zoom: 0,
    bearing: 0,
    pitch: 0,
  );
  CameraOptions cameraOptionsToReturn = CameraOptions();
  CoordinateBounds coordinateBoundsToReturn = CoordinateBounds(
    southwest: Point(coordinates: Position(0, 0)),
    northeast: Point(coordinates: Position(1, 1)),
    infiniteBounds: false,
  );
  CoordinateBoundsZoom coordinateBoundsZoomToReturn = CoordinateBoundsZoom(
    bounds: CoordinateBounds(
      southwest: Point(coordinates: Position(0, 0)),
      northeast: Point(coordinates: Position(1, 1)),
      infiniteBounds: false,
    ),
    zoom: 10,
  );
  CameraBounds cameraBoundsToReturn = CameraBounds(
    bounds: CoordinateBounds(
      southwest: Point(coordinates: Position(0, 0)),
      northeast: Point(coordinates: Position(1, 1)),
      infiniteBounds: false,
    ),
    maxZoom: 22,
    minZoom: 0,
    maxPitch: 85,
    minPitch: 0,
  );
  ScreenCoordinate screenCoordinateToReturn = ScreenCoordinate(x: 0, y: 0);
  Point pointToReturn = Point(coordinates: Position(0, 0));
  Size sizeToReturn = Size(width: 100, height: 200);
  double? elevationToReturn = 42.0;

  @override
  Future<void> loadStyleURI(String styleURI) async {
    loadStyleURICallCount++;
    lastStyleURI = styleURI;
  }

  @override
  Future<void> loadStyleJson(String styleJson) async {
    loadStyleJsonCallCount++;
    lastStyleJson = styleJson;
  }

  @override
  Future<CameraState> getCameraState() async {
    getCameraStateCallCount++;
    return cameraStateToReturn;
  }

  @override
  Future<void> setCamera(CameraOptions cameraOptions) async {
    setCameraCallCount++;
    lastCameraOptions = cameraOptions;
  }

  @override
  Future<CameraOptions> cameraForCoordinatesPadding(
    List<Point> coordinates,
    CameraOptions camera,
    MbxEdgeInsets? coordinatesPadding,
    double? maxZoom,
    ScreenCoordinate? offset,
  ) async {
    cameraForCoordinatesPaddingCallCount++;
    lastCoordinates = coordinates;
    lastCameraOptions = camera;
    lastPadding = coordinatesPadding;
    lastMaxZoom = maxZoom;
    lastOffset = offset;
    return cameraOptionsToReturn;
  }

  @override
  Future<CameraOptions> cameraForCoordinateBounds(
    CoordinateBounds bounds,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
    double? maxZoom,
    ScreenCoordinate? offset,
  ) async {
    cameraForCoordinateBoundsCallCount++;
    lastBounds = bounds;
    lastPadding = padding;
    lastBearing = bearing;
    lastPitch = pitch;
    lastMaxZoom = maxZoom;
    lastOffset = offset;
    return cameraOptionsToReturn;
  }

  @override
  Future<CameraOptions> cameraForCoordinates(
    List<Point> coordinates,
    MbxEdgeInsets padding,
    double? bearing,
    double? pitch,
  ) async {
    cameraForCoordinatesCallCount++;
    lastCoordinates = coordinates;
    lastPadding = padding;
    lastBearing = bearing;
    lastPitch = pitch;
    return cameraOptionsToReturn;
  }

  @override
  Future<CoordinateBounds> coordinateBoundsForCamera(
    CameraOptions camera,
  ) async {
    coordinateBoundsForCameraCallCount++;
    lastCameraOptions = camera;
    return coordinateBoundsToReturn;
  }

  @override
  Future<CoordinateBounds> coordinateBoundsForCameraUnwrapped(
    CameraOptions camera,
  ) async {
    coordinateBoundsForCameraUnwrappedCallCount++;
    lastCameraOptions = camera;
    return coordinateBoundsToReturn;
  }

  @override
  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCamera(
    CameraOptions camera,
  ) async {
    coordinateBoundsZoomForCameraCallCount++;
    lastCameraOptions = camera;
    return coordinateBoundsZoomToReturn;
  }

  @override
  Future<CoordinateBoundsZoom> coordinateBoundsZoomForCameraUnwrapped(
    CameraOptions camera,
  ) async {
    coordinateBoundsZoomForCameraUnwrappedCallCount++;
    lastCameraOptions = camera;
    return coordinateBoundsZoomToReturn;
  }

  @override
  Future<void> setBounds(CameraBoundsOptions options) async {
    setBoundsCallCount++;
    lastCameraBoundsOptions = options;
  }

  @override
  Future<CameraBounds> getBounds() async {
    getBoundsCallCount++;
    return cameraBoundsToReturn;
  }

  @override
  Future<void> easeTo(
    CameraOptions cameraOptions,
    MapAnimationOptions? mapAnimationOptions,
  ) async {
    easeToCallCount++;
    lastCameraOptions = cameraOptions;
    lastMapAnimationOptions = mapAnimationOptions;
  }

  @override
  Future<void> flyTo(
    CameraOptions cameraOptions,
    MapAnimationOptions? mapAnimationOptions,
  ) async {
    flyToCallCount++;
    lastCameraOptions = cameraOptions;
    lastMapAnimationOptions = mapAnimationOptions;
  }

  @override
  Future<void> pitchBy(
    double pitch,
    MapAnimationOptions? mapAnimationOptions,
  ) async {
    pitchByCallCount++;
    lastPitch = pitch;
    lastMapAnimationOptions = mapAnimationOptions;
  }

  @override
  Future<void> scaleBy(
    double amount,
    ScreenCoordinate? anchor,
    MapAnimationOptions? mapAnimationOptions,
  ) async {
    scaleByCallCount++;
    lastAmount = amount;
    lastAnchor = anchor;
    lastMapAnimationOptions = mapAnimationOptions;
  }

  @override
  Future<void> moveBy(
    ScreenCoordinate screenCoordinate,
    MapAnimationOptions? mapAnimationOptions,
  ) async {
    moveByCallCount++;
    lastScreenCoordinate = screenCoordinate;
    lastMapAnimationOptions = mapAnimationOptions;
  }

  @override
  Future<void> rotateBy(
    ScreenCoordinate first,
    ScreenCoordinate second,
    MapAnimationOptions? mapAnimationOptions,
  ) async {
    rotateByCallCount++;
    lastFirst = first;
    lastSecond = second;
    lastMapAnimationOptions = mapAnimationOptions;
  }

  @override
  Future<void> cancelCameraAnimation() async {
    cancelCameraAnimationCallCount++;
  }

  @override
  Future<ScreenCoordinate> pixelForCoordinate(Point coordinate) async {
    pixelForCoordinateCallCount++;
    lastCoordinate = coordinate;
    return screenCoordinateToReturn;
  }

  @override
  Future<Point> coordinateForPixel(ScreenCoordinate pixel) async {
    coordinateForPixelCallCount++;
    lastPixel = pixel;
    return pointToReturn;
  }

  @override
  Future<List<ScreenCoordinate?>> pixelsForCoordinates(
    List<Point> coordinates,
  ) async {
    pixelsForCoordinatesCallCount++;
    lastCoordinates = coordinates;
    return [screenCoordinateToReturn];
  }

  @override
  Future<List<Point?>> coordinatesForPixels(
    List<ScreenCoordinate?> pixels,
  ) async {
    coordinatesForPixelsCallCount++;
    lastPixels = pixels;
    return [pointToReturn];
  }

  @override
  Future<Size> getSize() async {
    getSizeCallCount++;
    return sizeToReturn;
  }

  @override
  Future<void> triggerRepaint() async {
    triggerRepaintCallCount++;
  }

  @override
  Future<double?> getElevation(Point coordinate) async {
    getElevationCallCount++;
    lastCoordinate = coordinate;
    return elevationToReturn;
  }

  @override
  Future<void> reduceMemoryUse() async {
    reduceMemoryUseCallCount++;
  }

  @override
  Future<void> setTileCacheBudget(
    TileCacheBudgetInMegabytes? tileCacheBudgetInMegabytes,
    TileCacheBudgetInTiles? tileCacheBudgetInTiles,
  ) async {
    setTileCacheBudgetCallCount++;
    lastTileCacheBudgetInMegabytes = tileCacheBudgetInMegabytes;
    lastTileCacheBudgetInTiles = tileCacheBudgetInTiles;
  }

  @override
  Future<void> setNorthOrientation(NorthOrientation orientation) async {
    setNorthOrientationCallCount++;
    lastNorthOrientation = orientation;
  }

  @override
  Future<void> setConstrainMode(ConstrainMode mode) async {
    setConstrainModeCallCount++;
    lastConstrainMode = mode;
  }

  @override
  Future<void> setViewportMode(ViewportMode mode) async {
    setViewportModeCallCount++;
    lastViewportMode = mode;
  }

  @override
  void addInteraction<T extends TypedFeaturesetFeature<FeaturesetDescriptor>>(
    TypedInteraction<T> interaction, {
    String? interactionID,
  }) {}

  @override
  void removeInteraction(String interactionID) {}

  @override
  Future<List<FeaturesetFeature>> queryRenderedFeaturesForFeatureset({
    required FeaturesetDescriptor featureset,
    RenderedQueryGeometry? geometry,
    String? filter,
  }) async => [];

  @override
  Future<void> setFeatureStateForFeaturesetDescriptor(
    FeaturesetDescriptor featureset,
    FeaturesetFeatureId featureId,
    FeatureState state,
  ) async {}

  @override
  Future<void> setFeatureStateForFeaturesetFeature(
    FeaturesetFeature feature,
    FeatureState state,
  ) async {}

  @override
  Future<Map<String, Object?>> getFeatureStateForFeaturesetDescriptor(
    FeaturesetDescriptor featureset,
    FeaturesetFeatureId featureId,
  ) async => {};

  @override
  Future<Map<String, Object?>> getFeatureStateForFeaturesetFeature(
    FeaturesetFeature feature,
  ) async => {};

  @override
  Future<void> removeFeatureStateForFeaturesetDescriptor({
    required FeaturesetDescriptor featureset,
    required FeaturesetFeatureId featureId,
    String? stateKey,
  }) async {}

  @override
  Future<void> removeFeatureStateForFeaturesetFeature({
    required FeaturesetFeature feature,
    String? stateKey,
  }) async {}

  @override
  Future<void> resetFeatureStatesForFeatureset(
    FeaturesetDescriptor featureset,
  ) async {}

  // ===== Performance statistics =====

  int startPerformanceStatisticsCollectionCallCount = 0;
  int stopPerformanceStatisticsCollectionCallCount = 0;
  PerformanceStatisticsOptions? lastPerfStatsOptions;
  PerformanceStatisticsListener? lastPerfStatsListener;

  @override
  void startPerformanceStatisticsCollection(
    PerformanceStatisticsOptions options,
    PerformanceStatisticsListener listener,
  ) {
    startPerformanceStatisticsCollectionCallCount++;
    lastPerfStatsOptions = options;
    lastPerfStatsListener = listener;
  }

  @override
  void stopPerformanceStatisticsCollection() {
    stopPerformanceStatisticsCollectionCallCount++;
  }

  @override
  void dispose() {
    disposeCallCount++;
  }
}

void main() {
  late MockMapboxMapPlatformInterface mockImpl;
  late MapboxMap mapboxMap;

  setUp(() {
    mockImpl = MockMapboxMapPlatformInterface();
    mapboxMap = MapboxMap(mockImpl);
  });

  group('MapboxMap', () {
    // ===== Sub-interfaces =====

    test('style returns a StyleManager wrapping the platform interface', () {
      expect(mapboxMap.style, isA<StyleManager>());
    });

    test('gestures returns a GesturesSettingsManager', () {
      expect(mapboxMap.gestures, isA<GesturesSettingsManager>());
    });

    test('location returns a LocationSettingsManager', () {
      expect(mapboxMap.location, isA<LocationSettingsManager>());
    });

    test('scaleBar returns a ScaleBarSettingsManager', () {
      expect(mapboxMap.scaleBar, isA<ScaleBarSettingsManager>());
    });

    test('compass returns a CompassSettingsManager', () {
      expect(mapboxMap.compass, isA<CompassSettingsManager>());
    });

    test('attribution returns an AttributionSettingsManager', () {
      expect(mapboxMap.attribution, isA<AttributionSettingsManager>());
    });

    test('logo returns a LogoSettingsManager', () {
      expect(mapboxMap.logo, isA<LogoSettingsManager>());
    });

    test('indoorSelector returns an IndoorSelectorSettingsManager', () {
      expect(mapboxMap.indoorSelector, isA<IndoorSelectorSettingsManager>());
    });

    test('annotations returns an AnnotationManager', () {
      expect(mapboxMap.annotations, isA<AnnotationManager>());
    });

    test('projection returns a Projection', () {
      expect(mapboxMap.projection, isA<Projection>());
    });

    test('mapRecorder returns a MapRecorder', () {
      expect(mapboxMap.mapRecorder, isA<MapRecorder>());
    });

    test('httpService returns a MapboxHttpService', () {
      expect(mapboxMap.httpService, isA<MapboxHttpService>());
    });

    test('sub-interfaces are cached (late final)', () {
      final style1 = mapboxMap.style;
      final style2 = mapboxMap.style;
      expect(identical(style1, style2), isTrue);
    });

    // ===== Gesture listeners =====

    test('onMapTapListener delegates get and set', () {
      void listener(MapContentGestureContext context) {}
      mapboxMap.onMapTapListener = listener;
      expect(mockImpl.onMapTapListener, same(listener));
      expect(mapboxMap.onMapTapListener, same(listener));
    });

    test('onMapLongTapListener delegates get and set', () {
      void listener(MapContentGestureContext context) {}
      mapboxMap.onMapLongTapListener = listener;
      expect(mockImpl.onMapLongTapListener, same(listener));
      expect(mapboxMap.onMapLongTapListener, same(listener));
    });

    test('onMapScrollListener delegates get and set', () {
      void listener(MapContentGestureContext context) {}
      mapboxMap.onMapScrollListener = listener;
      expect(mockImpl.onMapScrollListener, same(listener));
      expect(mapboxMap.onMapScrollListener, same(listener));
    });

    test('onMapZoomListener delegates get and set', () {
      void listener(MapContentGestureContext context) {}
      mapboxMap.onMapZoomListener = listener;
      expect(mockImpl.onMapZoomListener, same(listener));
      expect(mapboxMap.onMapZoomListener, same(listener));
    });

    // ===== Style loading =====

    test('loadStyleURI delegates to interface', () async {
      await mapboxMap.loadStyleURI('mapbox://styles/mapbox/streets-v12');

      expect(mockImpl.loadStyleURICallCount, 1);
      expect(mockImpl.lastStyleURI, 'mapbox://styles/mapbox/streets-v12');
    });

    test('loadStyleJson delegates to interface', () async {
      await mapboxMap.loadStyleJson('{"version": 8}');

      expect(mockImpl.loadStyleJsonCallCount, 1);
      expect(mockImpl.lastStyleJson, '{"version": 8}');
    });

    // ===== Camera getters / setters =====

    test('getCameraState delegates to interface', () async {
      final result = await mapboxMap.getCameraState();

      expect(mockImpl.getCameraStateCallCount, 1);
      expect(result, same(mockImpl.cameraStateToReturn));
    });

    test('setCamera delegates to interface', () async {
      final options = CameraOptions(zoom: 15);
      await mapboxMap.setCamera(options);

      expect(mockImpl.setCameraCallCount, 1);
      expect(mockImpl.lastCameraOptions, same(options));
    });

    // ===== Camera convenience =====

    test('cameraForCoordinatesPadding delegates to interface', () async {
      final coordinates = [Point(coordinates: Position(0, 0))];
      final camera = CameraOptions();
      final padding = MbxEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
      final offset = ScreenCoordinate(x: 5, y: 5);

      final result = await mapboxMap.cameraForCoordinatesPadding(
        coordinates,
        camera,
        padding,
        15.0,
        offset,
      );

      expect(mockImpl.cameraForCoordinatesPaddingCallCount, 1);
      expect(mockImpl.lastCoordinates, same(coordinates));
      expect(mockImpl.lastCameraOptions, same(camera));
      expect(mockImpl.lastPadding, same(padding));
      expect(mockImpl.lastMaxZoom, 15.0);
      expect(mockImpl.lastOffset, same(offset));
      expect(result, same(mockImpl.cameraOptionsToReturn));
    });

    test('cameraForCoordinateBounds delegates to interface', () async {
      final bounds = CoordinateBounds(
        southwest: Point(coordinates: Position(0, 0)),
        northeast: Point(coordinates: Position(1, 1)),
        infiniteBounds: false,
      );

      final padding = MbxEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
      final result = await mapboxMap.cameraForCoordinateBounds(
        bounds,
        padding,
        45.0,
        30.0,
        18.0,
        null,
      );

      expect(mockImpl.cameraForCoordinateBoundsCallCount, 1);
      expect(mockImpl.lastBounds, same(bounds));
      expect(mockImpl.lastPadding, same(padding));
      expect(mockImpl.lastBearing, 45.0);
      expect(mockImpl.lastPitch, 30.0);
      expect(mockImpl.lastMaxZoom, 18.0);
      expect(result, same(mockImpl.cameraOptionsToReturn));
    });

    test('cameraForCoordinates delegates to interface', () async {
      final coordinates = [Point(coordinates: Position(0, 0))];
      final padding = MbxEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);

      final result = await mapboxMap.cameraForCoordinates(
        coordinates,
        padding,
        90.0,
        60.0,
      );

      expect(mockImpl.cameraForCoordinatesCallCount, 1);
      expect(mockImpl.lastCoordinates, same(coordinates));
      expect(mockImpl.lastPadding, same(padding));
      expect(mockImpl.lastBearing, 90.0);
      expect(mockImpl.lastPitch, 60.0);
      expect(result, same(mockImpl.cameraOptionsToReturn));
    });

    test('coordinateBoundsForCamera delegates to interface', () async {
      final camera = CameraOptions();
      final result = await mapboxMap.coordinateBoundsForCamera(camera);

      expect(mockImpl.coordinateBoundsForCameraCallCount, 1);
      expect(mockImpl.lastCameraOptions, same(camera));
      expect(result, same(mockImpl.coordinateBoundsToReturn));
    });

    test('coordinateBoundsForCameraUnwrapped delegates to interface', () async {
      final camera = CameraOptions();
      final result =
          await mapboxMap.coordinateBoundsForCameraUnwrapped(camera);

      expect(mockImpl.coordinateBoundsForCameraUnwrappedCallCount, 1);
      expect(mockImpl.lastCameraOptions, same(camera));
      expect(result, same(mockImpl.coordinateBoundsToReturn));
    });

    test('coordinateBoundsZoomForCamera delegates to interface', () async {
      final camera = CameraOptions();
      final result = await mapboxMap.coordinateBoundsZoomForCamera(camera);

      expect(mockImpl.coordinateBoundsZoomForCameraCallCount, 1);
      expect(mockImpl.lastCameraOptions, same(camera));
      expect(result, same(mockImpl.coordinateBoundsZoomToReturn));
    });

    test('coordinateBoundsZoomForCameraUnwrapped delegates to interface',
        () async {
      final camera = CameraOptions();
      final result =
          await mapboxMap.coordinateBoundsZoomForCameraUnwrapped(camera);

      expect(mockImpl.coordinateBoundsZoomForCameraUnwrappedCallCount, 1);
      expect(mockImpl.lastCameraOptions, same(camera));
      expect(result, same(mockImpl.coordinateBoundsZoomToReturn));
    });

    // ===== Camera bounds =====

    test('setBounds delegates to interface', () async {
      final options = CameraBoundsOptions();
      await mapboxMap.setBounds(options);

      expect(mockImpl.setBoundsCallCount, 1);
      expect(mockImpl.lastCameraBoundsOptions, same(options));
    });

    test('getBounds delegates to interface', () async {
      final result = await mapboxMap.getBounds();

      expect(mockImpl.getBoundsCallCount, 1);
      expect(result, same(mockImpl.cameraBoundsToReturn));
    });

    // ===== Animation =====

    test('easeTo delegates to interface', () async {
      final camera = CameraOptions(zoom: 10);
      final animation = MapAnimationOptions(duration: 300);
      await mapboxMap.easeTo(camera, animation);

      expect(mockImpl.easeToCallCount, 1);
      expect(mockImpl.lastCameraOptions, same(camera));
      expect(mockImpl.lastMapAnimationOptions, same(animation));
    });

    test('flyTo delegates to interface', () async {
      final camera = CameraOptions(zoom: 10);
      final animation = MapAnimationOptions(duration: 300);
      await mapboxMap.flyTo(camera, animation);

      expect(mockImpl.flyToCallCount, 1);
      expect(mockImpl.lastCameraOptions, same(camera));
      expect(mockImpl.lastMapAnimationOptions, same(animation));
    });

    test('pitchBy delegates to interface', () async {
      final animation = MapAnimationOptions(duration: 200);
      await mapboxMap.pitchBy(30.0, animation);

      expect(mockImpl.pitchByCallCount, 1);
      expect(mockImpl.lastPitch, 30.0);
      expect(mockImpl.lastMapAnimationOptions, same(animation));
    });

    test('scaleBy delegates to interface', () async {
      final anchor = ScreenCoordinate(x: 100, y: 200);
      final animation = MapAnimationOptions(duration: 200);
      await mapboxMap.scaleBy(2.0, anchor, animation);

      expect(mockImpl.scaleByCallCount, 1);
      expect(mockImpl.lastAmount, 2.0);
      expect(mockImpl.lastAnchor, same(anchor));
      expect(mockImpl.lastMapAnimationOptions, same(animation));
    });

    test('moveBy delegates to interface', () async {
      final offset = ScreenCoordinate(x: 50, y: 50);
      final animation = MapAnimationOptions(duration: 200);
      await mapboxMap.moveBy(offset, animation);

      expect(mockImpl.moveByCallCount, 1);
      expect(mockImpl.lastScreenCoordinate, same(offset));
      expect(mockImpl.lastMapAnimationOptions, same(animation));
    });

    test('rotateBy delegates to interface', () async {
      final first = ScreenCoordinate(x: 0, y: 0);
      final second = ScreenCoordinate(x: 100, y: 100);
      final animation = MapAnimationOptions(duration: 200);
      await mapboxMap.rotateBy(first, second, animation);

      expect(mockImpl.rotateByCallCount, 1);
      expect(mockImpl.lastFirst, same(first));
      expect(mockImpl.lastSecond, same(second));
      expect(mockImpl.lastMapAnimationOptions, same(animation));
    });

    test('cancelCameraAnimation delegates to interface', () async {
      await mapboxMap.cancelCameraAnimation();

      expect(mockImpl.cancelCameraAnimationCallCount, 1);
    });

    // ===== Coordinate / pixel conversion =====

    test('pixelForCoordinate delegates to interface', () async {
      final coordinate = Point(coordinates: Position(10, 20));
      final result = await mapboxMap.pixelForCoordinate(coordinate);

      expect(mockImpl.pixelForCoordinateCallCount, 1);
      expect(mockImpl.lastCoordinate, same(coordinate));
      expect(result, same(mockImpl.screenCoordinateToReturn));
    });

    test('coordinateForPixel delegates to interface', () async {
      final pixel = ScreenCoordinate(x: 100, y: 200);
      final result = await mapboxMap.coordinateForPixel(pixel);

      expect(mockImpl.coordinateForPixelCallCount, 1);
      expect(mockImpl.lastPixel, same(pixel));
      expect(result, same(mockImpl.pointToReturn));
    });

    test('pixelsForCoordinates delegates to interface', () async {
      final coordinates = [Point(coordinates: Position(0, 0))];
      final result = await mapboxMap.pixelsForCoordinates(coordinates);

      expect(mockImpl.pixelsForCoordinatesCallCount, 1);
      expect(mockImpl.lastCoordinates, same(coordinates));
      expect(result.length, 1);
    });

    test('coordinatesForPixels delegates to interface', () async {
      final pixels = [ScreenCoordinate(x: 0, y: 0)];
      final result = await mapboxMap.coordinatesForPixels(pixels);

      expect(mockImpl.coordinatesForPixelsCallCount, 1);
      expect(mockImpl.lastPixels, same(pixels));
      expect(result.length, 1);
    });

    // ===== Map state =====

    test('getSize delegates to interface', () async {
      final result = await mapboxMap.getSize();

      expect(mockImpl.getSizeCallCount, 1);
      expect(result, same(mockImpl.sizeToReturn));
    });

    test('triggerRepaint delegates to interface', () async {
      await mapboxMap.triggerRepaint();

      expect(mockImpl.triggerRepaintCallCount, 1);
    });

    test('getElevation delegates to interface', () async {
      final coordinate = Point(coordinates: Position(10, 20));
      final result = await mapboxMap.getElevation(coordinate);

      expect(mockImpl.getElevationCallCount, 1);
      expect(mockImpl.lastCoordinate, same(coordinate));
      expect(result, 42.0);
    });

    test('reduceMemoryUse delegates to interface', () async {
      await mapboxMap.reduceMemoryUse();

      expect(mockImpl.reduceMemoryUseCallCount, 1);
    });

    test('setTileCacheBudget delegates to interface', () async {
      final megabytes = TileCacheBudgetInMegabytes(size: 100);
      await mapboxMap.setTileCacheBudget(megabytes, null);

      expect(mockImpl.setTileCacheBudgetCallCount, 1);
      expect(mockImpl.lastTileCacheBudgetInMegabytes, same(megabytes));
      expect(mockImpl.lastTileCacheBudgetInTiles, isNull);
    });

    // ===== Map orientation =====

    test('setNorthOrientation delegates to interface', () async {
      await mapboxMap.setNorthOrientation(NorthOrientation.UPWARDS);

      expect(mockImpl.setNorthOrientationCallCount, 1);
      expect(mockImpl.lastNorthOrientation, NorthOrientation.UPWARDS);
    });

    test('setConstrainMode delegates to interface', () async {
      await mapboxMap.setConstrainMode(ConstrainMode.HEIGHT_ONLY);

      expect(mockImpl.setConstrainModeCallCount, 1);
      expect(mockImpl.lastConstrainMode, ConstrainMode.HEIGHT_ONLY);
    });

    test('setViewportMode delegates to interface', () async {
      await mapboxMap.setViewportMode(ViewportMode.FLIPPED_Y);

      expect(mockImpl.setViewportModeCallCount, 1);
      expect(mockImpl.lastViewportMode, ViewportMode.FLIPPED_Y);
    });

    // ===== Performance statistics =====

    test('startPerformanceStatisticsCollection delegates to interface', () {
      final options = PerformanceStatisticsOptions(
        samplerOptions: [PerformanceSamplerOptions.CUMULATIVE],
        samplingDurationMillis: 1000,
      );
      final listener = _RecordingPerformanceStatisticsListener();
      mapboxMap.startPerformanceStatisticsCollection(options, listener);

      expect(mockImpl.startPerformanceStatisticsCollectionCallCount, 1);
      expect(mockImpl.lastPerfStatsOptions, options);
      expect(mockImpl.lastPerfStatsListener, listener);
    });

    test('stopPerformanceStatisticsCollection delegates to interface', () {
      mapboxMap.stopPerformanceStatisticsCollection();

      expect(mockImpl.stopPerformanceStatisticsCollectionCallCount, 1);
    });

    // ===== Lifecycle =====

    test('dispose delegates to interface', () {
      mapboxMap.dispose();

      expect(mockImpl.disposeCallCount, 1);
    });
  });
}

class _RecordingPerformanceStatisticsListener
    implements PerformanceStatisticsListener {
  @override
  void onPerformanceStatisticsCollected(PerformanceStatistics statistics) {}
}
