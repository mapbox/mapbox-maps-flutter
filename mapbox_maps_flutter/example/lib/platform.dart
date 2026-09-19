import 'package:flutter/foundation.dart';

/// Platform predicates for the example app shell.
///
/// Examples do not import this file: a file in `lib/docs/` must compile on its
/// own. Such a file uses `kIsWeb` directly.
final isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
final isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
final isMobile = isAndroid || isIOS;
final isWeb = kIsWeb;
