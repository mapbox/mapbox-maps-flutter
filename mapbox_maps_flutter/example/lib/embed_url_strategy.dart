import 'embed_url_strategy_stub.dart'
    if (dart.library.js_interop) 'embed_url_strategy_web.dart'
    as platform;

/// Installs a URL strategy that never pushes a new browser history entry
/// while this app runs inside an iframe, only on web.
///
/// A framed hash-routed SPA otherwise splices every internal route change
/// into the host page's own back/forward stack, so the host's back button
/// unwinds this app's navigation before it ever reaches the host page. A
/// standalone visit (`window.self == window.top`) is unaffected and keeps
/// the default push-based history.
void installEmbedAwareUrlStrategy() => platform.installEmbedAwareUrlStrategy();
