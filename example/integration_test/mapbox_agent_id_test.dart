import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'empty_map_widget.dart' as app;

// Verifies the wiring that forwards a compile-time `MAPBOX_AGENT` id
// (`--dart-define=MAPBOX_AGENT=<id>`) into the native platform channel when a
// real MapWidget is created. `MAPBOX_AGENT` is internal test tooling used to
// measure AI-coding-agent-driven traffic; it is never set for a normal app
// build.
//
// This test is self-verifying with respect to that define:
// - Run as `flutter test integration_test/mapbox_agent_id_test.dart` (no
//   define, the default for this repo's test suite): confirms rendering a
//   MapWidget still works with no agent id forwarded — i.e. this plumbing has
//   zero effect on a normal build.
// - Run as `flutter test integration_test/mapbox_agent_id_test.dart
//   --dart-define=MAPBOX_AGENT=claude-code`: additionally confirms the id is
//   forwarded to native without the map failing to load.
//
// What this test does NOT verify: the resulting outbound `User-Agent` header
// actually carrying ` agent/claude-code`. This plugin has no Dart-visible API
// for inspecting raw outbound request headers, and forwarding the id into
// Mapbox Common's native agent-context registry is currently a documented
// no-op placeholder (see the `platform#setMapboxAgentId` handlers in
// MapboxMapController on Android/iOS) pending a Common release that exposes
// that registry as a dependency here. Once that ships and those handlers are
// wired up for real, header-level verification belongs in Common's own HTTP
// layer tests rather than being re-implemented in this plugin.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MAPBOX_AGENT forwarding', () {
    testWidgets(
        'renders a MapWidget successfully whether or not MAPBOX_AGENT is set',
        (widgetTester) async {
      final mapFuture = app.main();
      await widgetTester.pumpAndSettle();
      final mapboxMap = await mapFuture;

      // The map above must load regardless of kMapboxAgentIdForTesting's
      // value; forwarding the id (or not) must never break map creation.
      // Errors from the forwarding call itself are caught and logged rather
      // than surfaced here (see _forwardMapboxAgentIdIfSet), so this only
      // proves the forwarding attempt doesn't interfere with map creation —
      // not that the native side actually received/applied the id.
      expect(mapboxMap, isNotNull);
    });
  });
}
