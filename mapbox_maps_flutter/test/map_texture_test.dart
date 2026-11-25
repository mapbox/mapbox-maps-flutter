import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_flutter_platform_interface/mapbox_maps_flutter_platform_interface_internal.dart';

class _StubStyle implements StylePlatformInterface {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _StubMap implements MapboxMapPlatformInterface {
  @override
  final StylePlatformInterface style = _StubStyle();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

base class _TexturePlatform extends MapboxMapsFlutterPlatform {
  String? styleUri;
  bool? gesturesEnabled;
  final map = _StubMap();

  @override
  Widget buildTextureView({
    String? styleUri,
    PlatformMapCreatedCallback? onMapCreated,
    bool gesturesEnabled = true,
  }) {
    this.styleUri = styleUri;
    this.gesturesEnabled = gesturesEnabled;
    onMapCreated?.call(map);
    return const SizedBox(key: ValueKey('platform-texture'));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

base class _NoTexturePlatform extends MapboxMapsFlutterPlatform {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('builds the platform texture view with its options', (
    tester,
  ) async {
    final platform = _TexturePlatform();
    MapboxMapsFlutterPlatform.instance = platform;

    await tester.pumpWidget(
      const MapTexture(
        styleUri: MapboxStyles.MAPBOX_STREETS,
        gesturesEnabled: false,
      ),
    );

    expect(find.byKey(const ValueKey('platform-texture')), findsOneWidget);
    expect(platform.styleUri, MapboxStyles.MAPBOX_STREETS);
    expect(platform.gesturesEnabled, isFalse);
  });

  testWidgets('hands back a MapboxMap wrapping the platform map', (
    tester,
  ) async {
    MapboxMapsFlutterPlatform.instance = _TexturePlatform();
    MapboxMap? created;

    await tester.pumpWidget(MapTexture(onMapCreated: (map) => created = map));

    expect(created, isA<MapboxMap>());
  });

  test('platforms without a texture view say so', () {
    expect(
      () => _NoTexturePlatform().buildTextureView(),
      throwsUnsupportedError,
    );
  });
}
