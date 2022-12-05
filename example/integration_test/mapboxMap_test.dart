import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_maps_example/empty_map_widget.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('addObserver', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final completer = Completer<Event>();
    mapboxMap.subscribe((Event event) {
      completer.complete(event);
    }, [MapEvents.SOURCE_ADDED]);
    var style = mapboxMap.style;
    var source = await rootBundle.loadString('assets/source.json');
    await style.addStyleSource('source', source);
    expect(completer.isCompleted, isTrue);
    var event = await completer.future;
    expect(event.type, MapEvents.SOURCE_ADDED);
    expect(event.data, isNotNull);
  });

  testWidgets('removeObserver', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final completer = Completer<Event>();
    var observer = (Event event) {
      completer.complete(event);
    };
    mapboxMap.subscribe(observer, [MapEvents.SOURCE_ADDED]);
    var style = mapboxMap.style;
    mapboxMap.unsubscribeAll(observer);
    var source = await rootBundle.loadString('assets/source.json');
    await style.addStyleSource('source', source);
    expect(completer.isCompleted, isFalse);
  });

  testWidgets('removeObserverWithEvent', (WidgetTester tester) async {
    final mapFuture = app.main();
    await tester.pumpAndSettle();
    final mapboxMap = await mapFuture;
    final completer = Completer<Event>();
    var observer = (Event event) {
      completer.complete(event);
    };
    mapboxMap.subscribe(observer, [MapEvents.SOURCE_ADDED]);
    var style = mapboxMap.style;
    mapboxMap.unsubscribe(observer, [MapEvents.SOURCE_ADDED]);
    var source = await rootBundle.loadString('assets/source.json');
    await style.addStyleSource('source', source);
    expect(completer.isCompleted, isFalse);
  });
}
