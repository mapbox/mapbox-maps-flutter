/// Drop-in replacement for `package:patrol/patrol.dart` that gives every
/// test a default timeout.
///
/// Patrol runs on a live test binding whose default test timeout is
/// `Timeout.none`, so a single hung `await` otherwise stalls the suite
/// forever — locally and on the device farms (the only outer nets are the
/// per-test Playwright timeout on web and the whole-run Firebase timeout on
/// mobile). Import this file instead of `package:patrol/patrol.dart` in
/// patrol_test files; pass `timeout:` explicitly for a test that
/// legitimately needs longer.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart' as patrol;

export 'package:patrol/patrol.dart' hide patrolTest;

/// Generous for a single integration test (the slowest healthy ones take
/// ~15 s), short enough that a hang fails one test quickly instead of
/// eating the whole job budget.
const Timeout defaultPatrolTestTimeout = Timeout(Duration(minutes: 2));

void patrolTest(
  String description,
  patrol.PatrolTesterCallback callback, {
  bool? skip,
  Timeout timeout = defaultPatrolTestTimeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
  patrol.PatrolTesterConfig config = const patrol.PatrolTesterConfig(
    printLogs: true,
  ),
  patrol.PlatformAutomatorConfig? platformAutomatorConfig,
  LiveTestWidgetsFlutterBindingFramePolicy framePolicy =
      LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
}) => patrol.patrolTest(
  description,
  callback,
  skip: skip,
  timeout: timeout,
  semanticsEnabled: semanticsEnabled,
  variant: variant,
  tags: tags,
  config: config,
  platformAutomatorConfig: platformAutomatorConfig,
  framePolicy: framePolicy,
);
