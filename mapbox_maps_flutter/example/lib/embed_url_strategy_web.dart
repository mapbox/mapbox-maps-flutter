import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

/// Never pushes a new browser history entry while framed, so the host
/// page's back button is not hijacked by this app's internal navigation.
class _EmbedAwareHashUrlStrategy extends HashUrlStrategy {
  const _EmbedAwareHashUrlStrategy();

  @override
  void pushState(Object? state, String title, String url) =>
      replaceState(state, title, url);
}

/// `window.self !== window.top` whenever a page runs inside an iframe.
bool get _isEmbedded => web.window.self != web.window.top;

void installEmbedAwareUrlStrategy() {
  if (!_isEmbedded) return;
  setUrlStrategy(const _EmbedAwareHashUrlStrategy());
}
