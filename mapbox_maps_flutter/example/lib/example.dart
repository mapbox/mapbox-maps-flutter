import 'package:flutter/material.dart';

/// Catalog sections. Declaration order is the order they appear.
enum ExampleCategory {
  gettingStarted('Getting started'),
  camera('Camera'),
  animations('Animations'),
  styles('Styles, layers & data'),
  interaction('Interaction'),
  platform('Platform & tooling'),
  docs('Docs examples');

  const ExampleCategory(this.label);

  final String label;
}

/// One entry in the example app's catalog.
class Example {
  const Example({
    required this.slug,
    required this.category,
    required this.leading,
    required this.title,
    required this.builder,
    this.subtitle,
    this.docsUrl,
  });

  /// URL path segment for this example, for example `full_map`.
  ///
  /// The hosted app routes `/#/<slug>` here, and the documentation pages link
  /// to it. Do not rename a slug without updating that link.
  final String slug;

  /// Documentation page that publishes this example, when it has one.
  ///
  /// Such an example lives in `lib/docs/` and must compile on its own.
  final String? docsUrl;

  final ExampleCategory category;
  final Widget leading;
  final String title;
  final String? subtitle;
  final WidgetBuilder builder;
}

/// Chrome to hide around an example when it is embedded in another page,
/// read from the route's query parameters, e.g.
/// `/#/full_map?hideAppBar=true`.
///
/// A parameter must equal `true` to take effect; any other value, including
/// `false` or an empty one, leaves the chrome visible. This lets a caller
/// re-show chrome it had hidden by setting the parameter to `false`, rather
/// than needing to remove it from the URL.
class EmbedOptions {
  const EmbedOptions({this.hideAppBar = false, this.hideDocsLink = false});

  factory EmbedOptions.fromQuery(Map<String, String> query) => EmbedOptions(
    hideAppBar: query['hideAppBar'] == 'true',
    hideDocsLink: query['hideDocsLink'] == 'true',
  );

  final bool hideAppBar;
  final bool hideDocsLink;
}
