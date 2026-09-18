import 'package:flutter/material.dart';
// The SDK exports its own Size type, which shadows the Flutter geometry Size
// used by CustomPainter and PreferredSize below.
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Size;
import 'package:url_launcher/url_launcher.dart';

import 'embed_url_strategy.dart';
import 'example.dart';
import 'examples.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  installEmbedAwareUrlStrategy();
  MapboxOptions.setAccessToken(const String.fromEnvironment('ACCESS_TOKEN'));
  runApp(const ExampleApp());
}

/// Example app shell.
///
/// Routes are hash URLs, `/#/<slug>`, because a static bucket cannot rewrite
/// requests.
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapbox Maps Flutter examples',
      debugShowCheckedModeBanner: false,
      theme: buildExampleTheme(),
      initialRoute: '/',
      onGenerateRoute: _generateRoute,
    );
  }

  Route<void> _generateRoute(RouteSettings settings) {
    // `settings.name` is the hash route, e.g. `/full_map?hideAppBar=true`, so
    // the slug and any embedding query parameters must be split before use.
    final uri = Uri.parse(settings.name ?? '/');
    final slug = uri.path.replaceAll('/', '');
    if (slug.isEmpty) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const CatalogPage(),
      );
    }

    final example = exampleForSlug(slug);
    final embed = EmbedOptions.fromQuery(uri.queryParameters);
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => example == null
          ? _UnknownExamplePage(slug: slug)
          : _ExamplePage(example: example, embed: embed),
    );
  }
}

/// Catalog of every example available on this platform, grouped by category.
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final _searchController = TextEditingController();
  var _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Examples matching the search box, grouped by category, in declaration
  /// order.
  Map<ExampleCategory, List<Example>> get _sections {
    final query = _query.trim().toLowerCase();
    final sections = <ExampleCategory, List<Example>>{};
    for (final example in examples) {
      if (!_matches(example, query)) continue;
      sections.putIfAbsent(example.category, () => []).add(example);
    }
    return Map.fromEntries(
      ExampleCategory.values
          .where(sections.containsKey)
          .map((category) => MapEntry(category, sections[category]!)),
    );
  }

  /// Matches a lowercased [query] against the title, subtitle and slug. An
  /// empty query matches everything.
  static bool _matches(Example example, String query) {
    if (query.isEmpty) return true;
    return example.title.toLowerCase().contains(query) ||
        (example.subtitle?.toLowerCase().contains(query) ?? false) ||
        example.slug.contains(query);
  }

  @override
  Widget build(BuildContext context) {
    final sections = _sections;
    final total = sections.values.fold(0, (sum, list) => sum + list.length);

    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            children: [
              SafeArea(
                bottom: false,
                child: _Header(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  resultCount: total,
                  isSearching: _query.trim().isNotEmpty,
                ),
              ),
              Expanded(
                child: total == 0
                    ? const _EmptyResults()
                    : ListView(
                        // Scrolls under the home indicator etc., rather than
                        // stopping at it, so the list reaches the true bottom
                        // of the screen. The extra bottom padding keeps the
                        // last item clear of that system chrome once scrolled
                        // all the way down.
                        padding: EdgeInsets.fromLTRB(
                          16,
                          8,
                          16,
                          16 + bottomInset,
                        ),
                        children: [
                          for (final entry in sections.entries) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 14, 4, 6),
                              child: GlassSectionLabel(entry.key.label),
                            ),
                            _ExampleGroup(examples: entry.value),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.controller,
    required this.onChanged,
    required this.resultCount,
    required this.isSearching,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final int resultCount;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _MapboxMark(size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Maps SDK for Flutter',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      isSearching
                          ? '$resultCount matching examples'
                          : '$resultCount examples',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: MapboxGlass.labelFaint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Search examples',
              isDense: true,
              prefixIcon: const Icon(
                Icons.search,
                size: 17,
                color: MapboxGlass.labelFaint,
              ),
              suffixIcon: isSearching
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      color: MapboxGlass.labelFaint,
                      tooltip: 'Clear search',
                      onPressed: () {
                        controller.clear();
                        onChanged('');
                      },
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// One category's examples, drawn as a single bordered group.
class _ExampleGroup extends StatelessWidget {
  const _ExampleGroup({required this.examples});

  final List<Example> examples;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: MapboxColors.gray90,
        borderRadius: BorderRadius.circular(MapboxRadius.large),
        border: Border.all(color: MapboxGlass.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < examples.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: MapboxGlass.border),
            _ExampleTile(
              example: examples[i],
              isFirst: i == 0,
              isLast: i == examples.length - 1,
            ),
          ],
        ],
      ),
    );
  }
}

class _ExampleTile extends StatelessWidget {
  const _ExampleTile({
    required this.example,
    required this.isFirst,
    required this.isLast,
  });

  final Example example;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const corner = Radius.circular(MapboxRadius.large);
    final subtitle = example.subtitle;

    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/${example.slug}'),
      borderRadius: BorderRadius.only(
        topLeft: isFirst ? corner : Radius.zero,
        topRight: isFirst ? corner : Radius.zero,
        bottomLeft: isLast ? corner : Radius.zero,
        bottomRight: isLast ? corner : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            IconTheme(
              data: const IconThemeData(
                color: MapboxGlass.labelMuted,
                size: 18,
              ),
              child: example.leading,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          example.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (example.docsUrl != null) ...[
                        const SizedBox(width: 8),
                        const _TutorialBadge(),
                      ],
                    ],
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: MapboxGlass.labelFaint,
                        height: 1.35,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: MapboxGlass.labelFaint,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 32, color: MapboxGlass.labelFaint),
          const SizedBox(height: 12),
          Text(
            'No examples match that search.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: MapboxGlass.labelMuted),
          ),
        ],
      ),
    );
  }
}

/// The Mapbox mark.
class _MapboxMark extends StatelessWidget {
  const _MapboxMark({this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _MapboxMarkPainter()),
    );
  }
}

class _MapboxMarkPainter extends CustomPainter {
  // Path data from the official Mapbox brand icon, on a 177.8 unit canvas.
  static const _viewBox = 177.8;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _viewBox;
    canvas.scale(scale);

    final fill = Paint()..color = MapboxColors.blue50;
    canvas.drawCircle(const Offset(88.9, 88.9), 88.9, fill);

    // The rounded "swoosh" and the four-point star, punched out in white.
    final mark = Paint()..color = Colors.white;
    final swoosh = Path()
      ..moveTo(131.1, 110.7)
      ..cubicTo(100.7, 141.1, 46.4, 131.4, 46.4, 131.4)
      ..cubicTo(36.6, 77.2, 67.1, 46.7, 67.1, 46.7)
      ..cubicTo(84.0, 29.8, 112.0, 30.5, 129.7, 48.1)
      ..cubicTo(147.4, 65.7, 148.0, 93.8, 131.1, 110.7)
      ..close();
    canvas.drawPath(swoosh, mark);

    final star = Path()
      ..moveTo(99.1, 52.1)
      ..lineTo(90.4, 70.0)
      ..lineTo(72.5, 78.7)
      ..lineTo(90.4, 87.4)
      ..lineTo(99.1, 105.3)
      ..lineTo(107.8, 87.4)
      ..lineTo(125.7, 78.7)
      ..lineTo(107.8, 70.0)
      ..close();
    canvas.drawPath(star, Paint()..color = MapboxColors.blue50);
  }

  @override
  bool shouldRepaint(_MapboxMarkPainter oldDelegate) => false;
}

class _ExamplePage extends StatelessWidget {
  const _ExamplePage({
    required this.example,
    this.embed = const EmbedOptions(),
  });

  final Example example;
  final EmbedOptions embed;

  @override
  Widget build(BuildContext context) {
    final showDocsLink = example.docsUrl != null && !embed.hideDocsLink;
    return Scaffold(
      appBar: embed.hideAppBar
          ? null
          : AppBar(
              title: Text(example.title),
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Divider(height: 1),
              ),
            ),
      body: example.builder(context),
      bottomNavigationBar: showDocsLink
          ? _DocsUrlBar(url: example.docsUrl!)
          : null,
    );
  }
}

/// Marks a catalog entry that a documentation page publishes.
class _TutorialBadge extends StatelessWidget {
  const _TutorialBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: MapboxColors.blue90,
        borderRadius: BorderRadius.circular(MapboxRadius.tiny),
        border: Border.all(color: MapboxColors.blue60),
      ),
      child: const Text(
        'TUTORIAL',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: MapboxColors.blue10,
        ),
      ),
    );
  }
}

/// Opens the documentation page that publishes an example.
class _DocsUrlBar extends StatelessWidget {
  const _DocsUrlBar({required this.url});

  final String url;

  Future<void> _open(BuildContext context) async {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (opened || !context.mounted) return;
    // Nothing handled the URL — show it so it can still be copied.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Could not open $url')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: MapboxColors.gray95,
          border: Border(top: BorderSide(color: MapboxGlass.border)),
        ),
        child: InkWell(
          onTap: () => _open(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  size: 15,
                  color: MapboxColors.blue40,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Open this example on docs.mapbox.com',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: MapboxColors.blue40,
                    ),
                  ),
                ),
                const Icon(
                  Icons.open_in_new,
                  size: 14,
                  color: MapboxColors.blue40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnknownExamplePage extends StatelessWidget {
  const _UnknownExamplePage({required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example not found')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.map_outlined,
                size: 40,
                color: MapboxGlass.labelFaint,
              ),
              const SizedBox(height: 16),
              Text(
                'No example is registered for "$slug" on this platform.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: MapboxGlass.labelMuted),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false),
                child: const Text('Back to all examples'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
