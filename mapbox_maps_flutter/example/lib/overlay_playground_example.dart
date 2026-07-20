import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class OverlayPlaygroundExample extends StatefulWidget {
  const OverlayPlaygroundExample({super.key});

  @override
  State<OverlayPlaygroundExample> createState() =>
      _OverlayPlaygroundExampleState();
}

/// A central region swapped in over the map to isolate one blocking behavior.
/// What it paints and whether it hit-tests is what decides whether the guard
/// blocks the click beneath it.
enum _TestZone {
  none('None', 'No test zone, the map is fully interactive.'),
  solid(
    'Solid background',
    'An opaque panel. It paints and hit-tests, so clicks are BLOCKED, the '
        'counter stays put.',
  ),
  translucent(
    'See-through background',
    'A half-transparent panel. You can see the map through it, but it still '
        'paints, so clicks are BLOCKED.',
  ),
  transparentColored(
    'Transparent color',
    'A Container with a fully transparent color. Nothing is visible, yet a '
        'ColoredBox always hit-tests, so clicks are BLOCKED, a common gotcha.',
  ),
  absorbPointer(
    'AbsorbPointer',
    'An invisible AbsorbPointer. Nothing is painted, yet clicks are BLOCKED '
        'because it absorbs pointers on purpose.',
  ),
  ignorePointer(
    'IgnorePointer',
    'A visibly-painted panel wrapped in IgnorePointer. You can see it, but '
        'clicks PASS THROUGH to the map underneath.',
  ),
  emptyBox(
    'Empty box',
    'A full-size empty SizedBox (no color, no child). It never self-hits, so '
        'clicks PASS THROUGH to the map.',
  );

  const _TestZone(this.label, this.description);

  final String label;
  final String description;
}

class _OverlayPlaygroundExampleState extends State<OverlayPlaygroundExample> {
  int _mapTaps = 0;
  bool _showCursorGallery = false;
  _TestZone _zone = _TestZone.none;

  // None of these drive the map; each control just captures its own gesture.
  double _slider = 0.6;
  bool _checkbox = true;
  bool _switch = false;
  String _dropdown = 'streets';
  int _segment = 0;
  int _drops = 0;

  void _onDrop() => setState(() => _drops++);

  void _onMapCreated(MapboxMap map) {
    map.addInteraction(
      // Fires only for taps that reached the map, i.e. weren't blocked above.
      TapInteraction.onMap((_) => setState(() => _mapTaps++)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: MapWidget(
              key: const ValueKey('playground-map'),
              styleUri: MapboxStyles.STANDARD,
              viewport: CameraViewportState(
                center: Point(coordinates: Position(-122.4194, 37.7749)),
                zoom: 12.0,
              ),
              onMapCreated: _onMapCreated,
            ),
          ),
          if (_zone != _TestZone.none) _buildTestZone(),
          Positioned(
            top: 16,
            right: 16,
            child: _MapTapBadge(
              count: _mapTaps,
              onReset: () => setState(() => _mapTaps = 0),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            bottom: 16,
            width: 340,
            child: _controlPanel(),
          ),
          if (_showCursorGallery)
            const Positioned(right: 96, top: 96, child: _CursorGallery()),
        ],
      ),
    );
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
      );
  }

  Widget _controlPanel() {
    return _FrostedCard(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Overlay playground', style: _titleStyle(context)),
          const SizedBox(height: 4),
          Text(
            'Every widget here is painted over the map. On web it must block '
            'the map gestures beneath it and drive the cursor.',
            style: Theme.of(context).textTheme.bodySmall,
          ),

          const Divider(height: 24),
          _sectionLabel('Inline controls'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => _snack('ElevatedButton'),
                icon: const Icon(Icons.touch_app_outlined),
                label: const Text('Button'),
              ),
              OutlinedButton(
                onPressed: () => _snack('OutlinedButton'),
                child: const Text('Outlined'),
              ),
              IconButton.filledTonal(
                tooltip: 'Icon button',
                onPressed: () => _snack('IconButton'),
                icon: const Icon(Icons.favorite_border),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Text cursor + typing capture; must not leak clicks/scroll to map.
          const TextField(
            decoration: InputDecoration(
              labelText: 'Text field',
              hintText: 'Type here…',
              isDense: true,
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          // Dragging must not pan/zoom the map underneath.
          Row(
            children: [
              const Icon(Icons.tune, size: 20),
              Expanded(
                child: Slider(
                  value: _slider,
                  label: _slider.toStringAsFixed(2),
                  divisions: 20,
                  onChanged: (v) => setState(() => _slider = v),
                ),
              ),
            ],
          ),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(
                value: 0,
                label: Text('Map'),
                icon: Icon(Icons.map),
              ),
              ButtonSegment(
                value: 1,
                label: Text('Sat'),
                icon: Icon(Icons.satellite_alt),
              ),
              ButtonSegment(
                value: 2,
                label: Text('3D'),
                icon: Icon(Icons.view_in_ar),
              ),
            ],
            selected: {_segment},
            onSelectionChanged: (s) => setState(() => _segment = s.first),
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Checkbox'),
            value: _checkbox,
            onChanged: (v) => setState(() => _checkbox = v ?? false),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Switch'),
            value: _switch,
            onChanged: (v) => setState(() => _switch = v),
          ),
          // Opens a menu on its own overlay above the map.
          DropdownButtonFormField<String>(
            initialValue: _dropdown,
            decoration: const InputDecoration(
              labelText: 'Dropdown',
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: 'streets', child: Text('Streets')),
              DropdownMenuItem(value: 'outdoors', child: Text('Outdoors')),
              DropdownMenuItem(value: 'satellite', child: Text('Satellite')),
            ],
            onChanged: (v) => setState(() => _dropdown = v ?? _dropdown),
          ),
          const Divider(height: 24),
          _sectionLabel('Scroll & drag'),
          Text(
            'Scrolling the list must not zoom the map; dragging the chip must '
            'not pan it.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          const _ScrollTestList(),
          const SizedBox(height: 12),
          Row(
            children: [
              Draggable<int>(
                data: 1,
                feedback: _dragChip(context, dragging: true),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: _dragChip(context),
                ),
                child: _dragChip(context),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DropTarget(count: _drops, onDrop: _onDrop),
              ),
            ],
          ),
          const Divider(height: 24),
          _sectionLabel('Route overlays & popups'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: _showInfoDialog,
                icon: const Icon(Icons.info_outline),
                label: const Text('Dialog'),
              ),
              FilledButton.tonalIcon(
                onPressed: _showLayersSheet,
                icon: const Icon(Icons.layers_outlined),
                label: const Text('Bottom sheet'),
              ),
              _PopupMenuButtonTile(onSelected: (v) => _snack('Menu: $v')),
              FilledButton.tonalIcon(
                onPressed: () => _snack('Tap and hold for the tooltip'),
                icon: const Icon(Icons.help_outline),
                label: const Text('Tooltip'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // The contextmenu event must be taken from GL JS, not the map's.
          _ContextMenuSurface(onSelected: (v) => _snack('Context: $v')),

          const Divider(height: 24),
          _sectionLabel('Cursor gallery'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Show every cursor'),
            subtitle: const Text('A tile per SystemMouseCursor'),
            value: _showCursorGallery,
            onChanged: (v) => setState(() => _showCursorGallery = v),
          ),
          const Divider(height: 24),
          _sectionLabel('Edge-case zones'),
          Text(
            'Backgrounds and invisible regions that separate "painted" from '
            '"hit-testable".',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final zone in _TestZone.values)
                ChoiceChip(
                  label: Text(zone.label),
                  selected: _zone == zone,
                  onSelected: (_) => setState(() => _zone = zone),
                ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _zone.description,
              key: ValueKey(_zone),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dragChip(BuildContext context, {bool dragging = false}) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: Chip(
        avatar: Icon(
          Icons.drag_indicator,
          size: 18,
          color: scheme.onSecondaryContainer,
        ),
        label: const Text('Drag me'),
        backgroundColor: dragging
            ? scheme.secondary.withValues(alpha: 0.9)
            : scheme.secondaryContainer,
      ),
    );
  }

  Widget _buildTestZone() {
    final Widget zoneChild;
    switch (_zone) {
      case _TestZone.none:
        return const SizedBox.shrink();
      case _TestZone.solid:
        zoneChild = _zoneFill(Colors.indigo, 'Solid\n(blocks)');
      case _TestZone.translucent:
        zoneChild = _zoneFill(
          Colors.indigo.withValues(alpha: 0.4),
          'See-through\n(blocks)',
        );
      case _TestZone.transparentColored:
        // ColoredBox always hit-tests, even fully transparent → blocks.
        zoneChild = const ColoredBox(
          color: Colors.transparent,
          child: SizedBox.expand(),
        );
      case _TestZone.absorbPointer:
        // Invisible, but absorbs pointers on purpose → blocks.
        zoneChild = const AbsorbPointer(child: SizedBox.expand());
      case _TestZone.ignorePointer:
        // Visible but ignores pointers → passes through.
        zoneChild = IgnorePointer(
          child: _zoneFill(
            Colors.deepPurple.withValues(alpha: 0.25),
            'IgnorePointer\n(passes through)',
          ),
        );
      case _TestZone.emptyBox:
        // No paint, no self-hit → passes through.
        zoneChild = const SizedBox.expand();
    }

    return Positioned.fill(
      child: Stack(
        children: [
          // Centred so the panel stays reachable; the banner explains zones
          // that paint nothing.
          Positioned(
            left: 380,
            right: 120,
            top: 96,
            bottom: 140,
            child: zoneChild,
          ),
          Positioned(
            top: 84,
            left: 380,
            right: 120,
            child: _ZoneBanner(zone: _zone),
          ),
        ],
      ),
    );
  }

  Widget _zoneFill(Color color, String label) {
    return Container(
      alignment: Alignment.center,
      color: color,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _showInfoDialog() {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.place_outlined),
        title: const Text('San Francisco'),
        content: const Text(
          'Modal dialogs float above everything on their own overlay. The '
          'barrier behind this dialog swallows taps, they never reach the '
          'map.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Future<void> _showLayersSheet() {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Map layers', style: _titleStyle(ctx)),
              const SizedBox(height: 12),
              for (final layer in const ['Streets', 'Satellite', 'Terrain'])
                ListTile(
                  leading: const Icon(Icons.map_outlined),
                  title: Text(layer),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pop(ctx),
                ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle? _titleStyle(BuildContext context) => Theme.of(
    context,
  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 4),
    child: Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        letterSpacing: 1.1,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

/// A reusable frosted-glass card used for the floating panels.
class _FrostedCard extends StatelessWidget {
  const _FrostedCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surface.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          // ListTile/SwitchListTile and ink splashes need a Material ancestor;
          // transparency keeps the frosted background showing through.
          child: Material(type: MaterialType.transparency, child: child),
        ),
      ),
    );
  }
}

/// Live counter that increments whenever a tap reaches the map.
class _MapTapBadge extends StatelessWidget {
  const _MapTapBadge({required this.count, required this.onReset});

  final int count;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return _FrostedCard(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.ads_click, size: 18),
            const SizedBox(width: 8),
            Text(
              'Map taps: $count',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              tooltip: 'Reset',
              visualDensity: VisualDensity.compact,
              onPressed: onReset,
              icon: const Icon(Icons.refresh, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoneBanner extends StatelessWidget {
  const _ZoneBanner({required this.zone});

  final _TestZone zone;

  @override
  Widget build(BuildContext context) {
    return _FrostedCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.science_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone.label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    zone.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A short scrollable list. Scrolling it over the map must move the list, not
/// zoom the map: the guard blocks the `wheel` event beneath it.
class _ScrollTestList extends StatelessWidget {
  const _ScrollTestList();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: 20,
        itemBuilder: (_, i) => ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          leading: CircleAvatar(radius: 12, child: Text('${i + 1}')),
          title: Text('Result ${i + 1}'),
        ),
      ),
    );
  }
}

/// A drop target for the draggable chip; highlights while a chip hovers and
/// counts accepted drops.
class _DropTarget extends StatelessWidget {
  const _DropTarget({required this.count, required this.onDrop});

  final int count;
  final VoidCallback onDrop;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DragTarget<int>(
      onAcceptWithDetails: (_) => onDrop(),
      builder: (context, candidate, rejected) {
        final active = candidate.isNotEmpty;
        return Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? scheme.primaryContainer
                : scheme.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? scheme.primary : scheme.outlineVariant,
              width: active ? 2 : 1,
            ),
          ),
          child: Text(
            count == 0 ? 'Drop here' : 'Dropped ×$count',
            style: TextStyle(
              color: active
                  ? scheme.onPrimaryContainer
                  : scheme.onSurfaceVariant,
            ),
          ),
        );
      },
    );
  }
}

/// A menu whose popup floats over the map on its own overlay.
class _PopupMenuButtonTile extends StatelessWidget {
  const _PopupMenuButtonTile({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      child: FilledButton.tonalIcon(
        onPressed: null,
        icon: const Icon(Icons.more_horiz),
        label: const Text('Popup menu'),
      ),
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'share', child: Text('Share')),
        PopupMenuItem(value: 'report', child: Text('Report a problem')),
        PopupMenuItem(value: 'about', child: Text('About this map')),
      ],
    );
  }
}

/// A surface that opens a menu on right-click (or long-press), verifying the
/// `contextmenu` event is taken from GL JS.
class _ContextMenuSurface extends StatelessWidget {
  const _ContextMenuSurface({required this.onSelected});

  final ValueChanged<String> onSelected;

  Future<void> _show(BuildContext context, Offset globalPosition) async {
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final value = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(globalPosition.dx, globalPosition.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: const [
        PopupMenuItem(value: 'copy', child: Text('Copy coordinates')),
        PopupMenuItem(value: 'center', child: Text('Center here')),
        PopupMenuItem(value: 'inspect', child: Text('Inspect feature')),
      ],
    );
    if (value != null) onSelected(value);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onSecondaryTapDown: (d) => _show(context, d.globalPosition),
      onLongPressStart: (d) => _show(context, d.globalPosition),
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Right-click / long-press me',
          style: TextStyle(color: scheme.onTertiaryContainer),
        ),
      ),
    );
  }
}

/// A gallery with one tile per [SystemMouseCursor], so you can sweep the mouse
/// across them and watch the cursor mirror change over the map.
class _CursorGallery extends StatelessWidget {
  const _CursorGallery();

  static const _cursors = <(String, MouseCursor)>[
    ('basic', SystemMouseCursors.basic),
    ('click', SystemMouseCursors.click),
    ('text', SystemMouseCursors.text),
    ('grab', SystemMouseCursors.grab),
    ('grabbing', SystemMouseCursors.grabbing),
    ('move', SystemMouseCursors.move),
    ('forbidden', SystemMouseCursors.forbidden),
    ('noDrop', SystemMouseCursors.noDrop),
    ('help', SystemMouseCursors.help),
    ('wait', SystemMouseCursors.wait),
    ('progress', SystemMouseCursors.progress),
    ('precise', SystemMouseCursors.precise),
    ('cell', SystemMouseCursors.cell),
    ('copy', SystemMouseCursors.copy),
    ('contextMenu', SystemMouseCursors.contextMenu),
    ('zoomIn', SystemMouseCursors.zoomIn),
    ('zoomOut', SystemMouseCursors.zoomOut),
    ('resizeLR', SystemMouseCursors.resizeLeftRight),
    ('resizeUD', SystemMouseCursors.resizeUpDown),
    ('allScroll', SystemMouseCursors.allScroll),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _FrostedCard(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.mouse_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Cursor gallery',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Hover each tile, the map cursor mirrors it.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (label, cursor) in _cursors)
                    MouseRegion(
                      cursor: cursor,
                      child: Container(
                        width: 96,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
