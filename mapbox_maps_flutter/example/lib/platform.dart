import 'package:flutter/foundation.dart';

final isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
final isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
final isMobile = isAndroid || isIOS;
