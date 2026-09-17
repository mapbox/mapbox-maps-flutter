import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// MapTexture talks to the host over one method channel, so the channel is
/// where its behaviour is observable without a device: what it asks for, when,
/// and whether it cleans up after itself.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.flutter.io/mapbox_maps_headless');
  late List<MethodCall> calls;

  setUp(() {
    calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      switch (call.method) {
        case 'create':
          return 7;
        case 'ornaments':
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  Future<void> pumpMap(WidgetTester tester, {ui.Size size = const ui.Size(320, 640)}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: const MapTexture(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  }

  MethodCall? callNamed(List<MethodCall> calls, String name) {
    for (final call in calls) {
      if (call.method == name) return call;
    }
    return null;
  }

  testWidgets('creates the map at the size of its constraints', (tester) async {
    await pumpMap(tester, size: const ui.Size(300, 500));
    final create = callNamed(calls, 'create');
    expect(create, isNotNull);
    expect(create!.arguments['width'], 300.0);
    expect(create.arguments['height'], 500.0);
    await unmount(tester);
  });

  testWidgets('renders a Texture once the host returns an id', (tester) async {
    await pumpMap(tester);
    expect(find.byType(Texture), findsOneWidget);
    final texture = tester.widget<Texture>(find.byType(Texture));
    expect(texture.textureId, 7);
    await unmount(tester);
  });

  testWidgets('every map gets its own channel suffix', (tester) async {
    await pumpMap(tester);
    final first = callNamed(calls, 'create')!.arguments['channelSuffix'] as int;
    calls.clear();
    await tester.pumpWidget(const SizedBox.shrink());
    await pumpMap(tester);
    final second = callNamed(calls, 'create')!.arguments['channelSuffix'] as int;
    expect(second, isNot(first));
    await unmount(tester);
  });

  testWidgets('passes the style through', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MapTexture(styleUri: 'mapbox://styles/test')),
    );
    await tester.pump();
    await tester.pump();
    expect(callNamed(calls, 'create')!.arguments['styleUri'],
        'mapbox://styles/test');
    await unmount(tester);
  });

  testWidgets('resizes the host map when the constraints change',
      (tester) async {
    await pumpMap(tester, size: const ui.Size(300, 500));
    calls.clear();
    await pumpMap(tester, size: const ui.Size(200, 400));
    await tester.pump();
    final resize = callNamed(calls, 'resize');
    expect(resize, isNotNull);
    expect(resize!.arguments['width'], 200.0);
    expect(resize.arguments['height'], 400.0);
    await unmount(tester);
  });

  testWidgets('disposes the host map when it leaves the tree', (tester) async {
    await pumpMap(tester);
    calls.clear();
    await tester.pumpWidget(const SizedBox.shrink());
    final dispose = callNamed(calls, 'dispose');
    expect(dispose, isNotNull);
    expect(dispose!.arguments['textureId'], 7);
  });

  testWidgets('a drag forwards panBegin, panUpdate and panEnd',
      (tester) async {
    await pumpMap(tester);
    calls.clear();
    await tester.drag(find.byType(Texture), const Offset(-40, -20));
    await tester.pumpAndSettle();
    expect(callNamed(calls, 'panBegin'), isNotNull);
    expect(callNamed(calls, 'panUpdate'), isNotNull);
    expect(callNamed(calls, 'panEnd'), isNotNull);
    await unmount(tester);
  });

  testWidgets('gesturesEnabled false forwards nothing', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox(
          width: 320,
          height: 640,
          child: MapTexture(gesturesEnabled: false),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    calls.clear();
    await tester.drag(find.byType(Texture), const Offset(-40, -20));
    await tester.pumpAndSettle();
    expect(callNamed(calls, 'panBegin'), isNull);
    await unmount(tester);
  });
}
