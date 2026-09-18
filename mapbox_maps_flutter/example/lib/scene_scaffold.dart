import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'theme.dart';

// Re-exported so an example needs only this one import.
export 'theme.dart'
    show
        GlassSectionLabel,
        MapboxColors,
        MapboxGlass,
        MapboxRadius,
        MapHud,
        MapHudRow,
        applyCatalogOrnamentDefaults,
        compactBarClearance;

/// Preset heights for the narrow-viewport controls sheet.
///
/// Picked by each call site to match how much its controls need: a couple of
/// switches need far less room than a scrollable list of sliders. None of the
/// presets reach full height — some of the map must always stay visible and
/// interactive behind the sheet.
enum ControlsSheetSize {
  /// For a small handful of controls, e.g. one or two switches or a row of
  /// choice chips.
  small(initial: 0.28, min: 0.16, max: 0.45),

  /// The default: a typical options panel with a few labelled rows.
  medium(initial: 0.4, min: 0.2, max: 0.6),

  /// For a long or dense control list that benefits from more room to start.
  large(initial: 0.55, min: 0.28, max: 0.75);

  const ControlsSheetSize({
    required this.initial,
    required this.min,
    required this.max,
  });

  /// Fraction of the screen height the sheet opens to.
  final double initial;

  /// Fraction of the screen height the sheet can be dragged down to.
  final double min;

  /// Fraction of the screen height the sheet can be dragged up to.
  ///
  /// Kept well under full height, so the map and its scene picker stay
  /// reachable behind the sheet.
  final double max;
}

/// One selectable scene in a [SceneScaffold].
class Scene {
  const Scene({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}

/// Layout shared by the app's feature-rich examples: one map with a scene
/// picker on the left and the selected scene's controls on the right.
///
/// A narrow viewport instead pins one bar to the bottom edge: every scene as a
/// chip, plus a button that opens the controls in a half-height sheet. The map
/// stays visible and interactive behind the sheet.
class SceneScaffold extends StatefulWidget {
  const SceneScaffold({
    super.key,
    required this.scenes,
    required this.selectedSceneId,
    required this.onSceneSelected,
    required this.map,
    required this.controlsBuilder,
    this.controlsTitle = 'Options',
    this.controlsSheetSize = ControlsSheetSize.medium,
    this.onSheetExtentChanged,
    this.centerPanels = false,
    this.log,
    this.logTitle = 'Event log',
  });

  /// A ready-made [onSheetExtentChanged] that keeps [mapboxMap]'s visual
  /// center clear of the open controls sheet.
  ///
  /// Pads the camera's bottom edge by the sheet's current height, so the
  /// centerpoint the user is looking at stays in the area the sheet does not
  /// cover. Not for an example that already manages its own camera padding,
  /// for example to demonstrate the padding API itself.
  ///
  /// `null` if [mapboxMap] is not yet available (before the map's
  /// `onMapCreated` fires), so a call site can pass this straight through
  /// without a null check of its own.
  static ValueChanged<double>? defaultOnSheetExtentChanged(
    MapboxMap? mapboxMap,
  ) {
    if (mapboxMap == null) return null;
    return (heightPx) {
      mapboxMap.setCamera(
        CameraOptions(
          padding: MbxEdgeInsets(top: 0, left: 0, right: 0, bottom: heightPx),
        ),
      );
    };
  }

  /// Newest-first lines of a live event log, for an example whose subject is
  /// the events themselves.
  ///
  /// On a narrow viewport these get a collapsed strip above the compact bar
  /// instead of the controls sheet, so the newest lines stay readable while
  /// the map is being touched. On a wide viewport the caller still renders the
  /// log in its own controls panel.
  final List<String>? log;

  final String logTitle;

  /// Centers the panels vertically, for a map whose own ornaments occupy the
  /// top corners.
  final bool centerPanels;

  final List<Scene> scenes;
  final String selectedSceneId;
  final ValueChanged<String> onSceneSelected;

  final Widget map;

  /// Builds the controls for the selected scene.
  ///
  /// Called on every rebuild, also for an open bottom sheet. See
  /// [_ControlsListenable].
  final List<Widget> Function() controlsBuilder;

  final String controlsTitle;

  /// How tall the narrow-viewport controls sheet opens, matched to how much
  /// the scene's controls need.
  final ControlsSheetSize controlsSheetSize;

  /// Called with the open sheet's height in logical pixels as it opens,
  /// drags, or closes (0 once closed).
  ///
  /// Lets the caller keep the map's visual center clear of the sheet, for
  /// example via [defaultOnSheetExtentChanged]. `null` if the example does
  /// not need this.
  final ValueChanged<double>? onSheetExtentChanged;

  @override
  State<SceneScaffold> createState() => _SceneScaffoldState();
}

class _SceneScaffoldState extends State<SceneScaffold>
    with _ControlsHost<SceneScaffold> {
  static const _panelWidth = 268.0;
  static const _wideBreakpoint = 900.0;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _wideBreakpoint;
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final controls = widget.controlsBuilder();

    return Stack(
      children: [
        Positioned.fill(child: widget.map),
        if (isWide) ...[
          Positioned(
            top: 16 + viewPadding.top,
            bottom: 16 + viewPadding.bottom,
            left: 16 + viewPadding.left,
            width: _panelWidth,
            child: Align(
              alignment: widget.centerPanels
                  ? Alignment.centerLeft
                  : Alignment.topLeft,
              child: _ScenePanel(
                scenes: widget.scenes,
                selectedSceneId: widget.selectedSceneId,
                onSceneSelected: widget.onSceneSelected,
              ),
            ),
          ),
          if (controls.isNotEmpty)
            Positioned(
              top: 16 + viewPadding.top,
              right: 16 + viewPadding.right,
              bottom: 16 + viewPadding.bottom,
              width: _panelWidth,
              child: Align(
                alignment: widget.centerPanels
                    ? Alignment.centerRight
                    : Alignment.topCenter,
                child: _ControlsPanel(
                  title: widget.controlsTitle,
                  children: controls,
                ),
              ),
            ),
        ] else
          Positioned(
            left: 12 + viewPadding.left,
            right: 12 + viewPadding.right,
            bottom: 12 + viewPadding.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.log != null) ...[
                  MapLogStrip(title: widget.logTitle, lines: widget.log!),
                  const SizedBox(height: 8),
                ],
                _CompactBar(
                  scenes: widget.scenes,
                  selectedSceneId: widget.selectedSceneId,
                  onSceneSelected: widget.onSceneSelected,
                  controlsTitle: widget.controlsTitle,
                  controlsBuilder: widget.controlsBuilder,
                  controlsListenable: _controlsListenable,
                  controlsSheetSize: widget.controlsSheetSize,
                  onSheetExtentChanged: widget.onSheetExtentChanged,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// A live event log pinned over the map, collapsed to its newest lines.
///
/// Sized so the map stays usable: the newest events are readable without
/// opening anything, and the strip expands for history.
class MapLogStrip extends StatefulWidget {
  const MapLogStrip({super.key, required this.title, required this.lines});

  final String title;

  /// Log lines, newest last.
  final List<String> lines;

  @override
  State<MapLogStrip> createState() => _MapLogStripState();
}

class _MapLogStripState extends State<MapLogStrip> {
  static const _collapsedHeight = 66.0;
  static const _expandedFraction = 0.4;

  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final newestFirst = widget.lines.reversed.toList();
    final height = _expanded
        ? MediaQuery.sizeOf(context).height * _expandedFraction
        : _collapsedHeight;

    return GlassPanel(
      padding: const EdgeInsets.fromLTRB(12, 6, 6, 8),
      radius: MapboxRadius.medium,
      opaque: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GlassSectionLabel(
                  '${widget.title} · ${widget.lines.length}',
                ),
              ),
              IconButton(
                icon: Icon(
                  _expanded ? Icons.unfold_less : Icons.unfold_more,
                  size: 16,
                ),
                color: MapboxGlass.labelMuted,
                visualDensity: VisualDensity.compact,
                tooltip: _expanded ? 'Collapse log' : 'Expand log',
                onPressed: () => setState(() => _expanded = !_expanded),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: height,
              child: newestFirst.isEmpty
                  ? const Text(
                      'No events yet — pan, zoom, rotate or pitch the map.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: MapboxGlass.labelFaint,
                      ),
                    )
                  : ListView.builder(
                      // Newest first at the top, so the latest event needs no
                      // scrolling and no autoscroll fighting the user.
                      padding: EdgeInsets.zero,
                      itemCount: newestFirst.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          newestFirst[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.3,
                            // The newest line reads brightest.
                            color: index == 0
                                ? MapboxGlass.label
                                : MapboxGlass.labelMuted,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A map with a single floating controls panel and no scene picker.
class MapScaffold extends StatefulWidget {
  const MapScaffold({
    super.key,
    required this.map,
    required this.controlsBuilder,
    this.controlsTitle = 'Options',
    this.controlsSheetSize = ControlsSheetSize.medium,
    this.onSheetExtentChanged,
    this.footer,
  });

  final Widget map;

  /// Builds the controls panel's contents.
  ///
  /// Called on every rebuild, also for an open bottom sheet. See
  /// [_ControlsListenable].
  final List<Widget> Function() controlsBuilder;

  final String controlsTitle;

  /// How tall the narrow-viewport controls sheet opens, matched to how much
  /// the panel's controls need.
  final ControlsSheetSize controlsSheetSize;

  /// Called with the open sheet's height in logical pixels as it opens,
  /// drags, or closes (0 once closed).
  ///
  /// Lets the caller keep the map's visual center clear of the sheet, for
  /// example via [SceneScaffold.defaultOnSheetExtentChanged]. `null` if the
  /// example does not need this.
  final ValueChanged<double>? onSheetExtentChanged;

  /// Optional note pinned under the panel, for platform caveats.
  final Widget? footer;

  @override
  State<MapScaffold> createState() => _MapScaffoldState();
}

class _MapScaffoldState extends State<MapScaffold>
    with _ControlsHost<MapScaffold> {
  static const _panelWidth = 268.0;
  static const _wideBreakpoint = 640.0;

  List<Widget> _buildPanelChildren() => [
    ...widget.controlsBuilder(),
    ?widget.footer,
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _wideBreakpoint;
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final panelChildren = _buildPanelChildren();

    return Stack(
      children: [
        Positioned.fill(child: widget.map),
        if (panelChildren.isNotEmpty)
          if (isWide)
            Positioned(
              top: 16 + viewPadding.top,
              right: 16 + viewPadding.right,
              bottom: 16 + viewPadding.bottom,
              width: _panelWidth,
              // Top aligned, so the panel hugs its content and scrolls once
              // it reaches the available height.
              child: Align(
                alignment: Alignment.topCenter,
                child: _ControlsPanel(
                  title: widget.controlsTitle,
                  children: panelChildren,
                ),
              ),
            )
          else
            Positioned(
              left: 12 + viewPadding.left,
              right: 12 + viewPadding.right,
              bottom: 12 + viewPadding.bottom,
              child: _CompactOptionsBar(
                title: widget.controlsTitle,
                controlsBuilder: _buildPanelChildren,
                controlsListenable: _controlsListenable,
                controlsSheetSize: widget.controlsSheetSize,
                onSheetExtentChanged: widget.onSheetExtentChanged,
              ),
            ),
      ],
    );
  }
}

class _ScenePanel extends StatelessWidget {
  const _ScenePanel({
    required this.scenes,
    required this.selectedSceneId,
    required this.onSceneSelected,
  });

  final List<Scene> scenes;
  final String selectedSceneId;
  final ValueChanged<String> onSceneSelected;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(6, 4, 6, 10),
            child: GlassSectionLabel('Scenes'),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: scenes.length,
              itemBuilder: (context, index) {
                final scene = scenes[index];
                return _SceneTile(
                  scene: scene,
                  selected: scene.id == selectedSceneId,
                  onTap: () => onSceneSelected(scene.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SceneTile extends StatelessWidget {
  const _SceneTile({
    required this.scene,
    required this.selected,
    required this.onTap,
  });

  final Scene scene;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(MapboxRadius.medium);
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: selected ? MapboxGlass.fillSelected : Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: selected ? MapboxGlass.borderStrong : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  scene.icon,
                  size: 18,
                  color: selected ? MapboxGlass.label : MapboxGlass.labelMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scene.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? MapboxGlass.label
                              : MapboxGlass.labelMuted,
                        ),
                      ),
                      Text(
                        scene.subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.3,
                          color: MapboxGlass.labelFaint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlsPanel extends StatelessWidget {
  const _ControlsPanel({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // A long control list scrolls inside the panel: the parent bounds the
    // height, and the list flexes within it.
    return GlassPanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassSectionLabel(title),
          const SizedBox(height: 8),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Notifies an open bottom sheet that its host scaffold has rebuilt.
///
/// The sheet builder runs only when the sheet opens, so the sheet would
/// otherwise freeze on the state it captured then. The scaffold calls [notify]
/// on every rebuild, and the sheet rebuilds its controls.
class _ControlsListenable extends ChangeNotifier {
  void notify() => notifyListeners();
}

/// Owns a scaffold's [_ControlsListenable] and pokes it on every rebuild.
mixin _ControlsHost<T extends StatefulWidget> on State<T> {
  final _controlsListenable = _ControlsListenable();

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Deferred: the sheet is a separate route, so a synchronous notify would
    // call setState on it during this build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controlsListenable.notify();
    });
  }

  @override
  void dispose() {
    _controlsListenable.dispose();
    super.dispose();
  }
}

/// Handle for a sheet opened by [_openOptionsSheet], letting the caller ask
/// the sheet to animate itself shut instead of vanishing outright.
class _OpenedOptionsSheet {
  const _OpenedOptionsSheet(this._controller, this._bodyKey);

  final PersistentBottomSheetController _controller;
  final GlobalKey<_OptionsSheetBodyState> _bodyKey;

  Future<void> get closed => _controller.closed;

  /// Animates the sheet down to its minimum extent, then removes it.
  ///
  /// The state can already be gone if the sheet closed some other way (a
  /// drag past its minimum extent) between the caller deciding to close it
  /// and this running, in which case there is nothing left to animate.
  Future<void> close() async {
    final body = _bodyKey.currentState;
    if (body == null) {
      _controller.close();
      return;
    }
    await body.animateToClosed();
    _controller.close();
  }
}

/// Opens a panel's contents as a controls sheet over the map.
///
/// The sheet is not modal: there is no scrim, and the map keeps receiving
/// gestures, so a control's effect can be watched while the sheet is open.
_OpenedOptionsSheet _openOptionsSheet(
  BuildContext context, {
  required String title,
  required List<Widget> Function() controlsBuilder,
  Listenable? controlsListenable,
  required ControlsSheetSize sheetSize,
  ValueChanged<double>? onExtentChanged,
}) {
  final bodyKey = GlobalKey<_OptionsSheetBodyState>();
  late final _OpenedOptionsSheet opened;
  final controller = showBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    elevation: 0,
    constraints: const BoxConstraints(maxWidth: double.infinity),
    builder: (_) => _OptionsSheetBody(
      key: bodyKey,
      title: title,
      controlsBuilder: controlsBuilder,
      controlsListenable: controlsListenable,
      sheetSize: sheetSize,
      onExtentChanged: onExtentChanged,
      // Routed back through the handle, so the close button animates the
      // sheet shut the same way an external close request does.
      onClose: () => opened.close(),
    ),
  );
  opened = _OpenedOptionsSheet(controller, bodyKey);
  return opened;
}

/// Body of [_openOptionsSheet], rebuilt whenever [controlsListenable] fires.
class _OptionsSheetBody extends StatefulWidget {
  const _OptionsSheetBody({
    super.key,
    required this.title,
    required this.controlsBuilder,
    required this.controlsListenable,
    required this.sheetSize,
    this.onExtentChanged,
    required this.onClose,
  });

  final String title;
  final List<Widget> Function() controlsBuilder;
  final Listenable? controlsListenable;
  final ControlsSheetSize sheetSize;
  final ValueChanged<double>? onExtentChanged;
  final VoidCallback onClose;

  @override
  State<_OptionsSheetBody> createState() => _OptionsSheetBodyState();
}

class _OptionsSheetBodyState extends State<_OptionsSheetBody> {
  /// Grows or shrinks the sheet's own open/close animation, instead of it
  /// appearing or vanishing on a single frame.
  static const _openDuration = Duration(milliseconds: 220);
  static const _openCurve = Curves.easeOutCubic;
  static const _closeDuration = Duration(milliseconds: 180);
  static const _closeCurve = Curves.easeInCubic;

  final _sheetController = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    widget.controlsListenable?.addListener(_onHostChanged);
    if (widget.onExtentChanged != null) {
      _sheetController.addListener(_onSheetExtentChanged);
    }
    // The sheet starts at its minimum extent and animates up, so anything
    // tracking [_onSheetExtentChanged] — such as camera padding — eases in
    // alongside the sheet instead of jumping straight to the open size.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _sheetController.animateTo(
        widget.sheetSize.initial,
        duration: _openDuration,
        curve: _openCurve,
      );
    });
  }

  @override
  void dispose() {
    widget.controlsListenable?.removeListener(_onHostChanged);
    _sheetController.removeListener(_onSheetExtentChanged);
    _sheetController.dispose();
    super.dispose();
  }

  void _onHostChanged() => setState(() {});

  /// Animates the sheet down to its minimum extent.
  ///
  /// [_openOptionsSheet]'s handle removes the sheet once this completes, so
  /// whatever tracks [widget.onExtentChanged] — camera padding included —
  /// eases back down before the sheet itself disappears.
  Future<void> animateToClosed() {
    if (!_sheetController.isAttached) return Future.value();
    return _sheetController.animateTo(
      widget.sheetSize.min,
      duration: _closeDuration,
      curve: _closeCurve,
    );
  }

  void _onSheetExtentChanged() {
    if (!_sheetController.isAttached) return;
    final screenHeight = MediaQuery.sizeOf(context).height;
    widget.onExtentChanged?.call(_sheetController.size * screenHeight);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _sheetController,
      // Starts at the minimum extent; initState animates it up to
      // widget.sheetSize.initial so the open transition is visible.
      initialChildSize: widget.sheetSize.min,
      minChildSize: widget.sheetSize.min,
      maxChildSize: widget.sheetSize.max,
      expand: false,
      snap: true,
      snapSizes: [widget.sheetSize.initial],
      // Opaque, not glass: a blurred panel does not composite over the map's
      // platform view, so the map would show through the controls.
      builder: (context, scrollController) => DecoratedBox(
        decoration: const BoxDecoration(
          color: MapboxColors.gray90,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(MapboxRadius.large),
          ),
          border: Border(top: BorderSide(color: MapboxGlass.border)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(MapboxRadius.large),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              // Pinned, so the handle and title stay reachable at any extent.
              SliverPersistentHeader(
                pinned: true,
                delegate: _SheetHeaderDelegate(
                  title: widget.title,
                  onClose: widget.onClose,
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  16 + MediaQuery.viewPaddingOf(context).bottom,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(widget.controlsBuilder()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pinned drag handle, title and close button for the controls sheet.
class _SheetHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _SheetHeaderDelegate({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  static const _height = 52.0;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DecoratedBox(
      // Opaque behind the pinned header, so rows do not show through it.
      decoration: const BoxDecoration(color: MapboxColors.gray90),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: MapboxGlass.borderStrong,
              borderRadius: BorderRadius.circular(MapboxRadius.tiny),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
              child: Row(
                children: [
                  Expanded(child: GlassSectionLabel(title)),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: MapboxGlass.labelMuted,
                    tooltip: 'Close',
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_SheetHeaderDelegate oldDelegate) =>
      oldDelegate.title != title;
}

/// Opens and closes the controls sheet for a compact bar's toggle button.
///
/// [showBottomSheet] stacks a new sheet on every call, so the button must
/// know whether one is already up.
mixin _ControlsSheetHost<T extends StatefulWidget> on State<T> {
  _OpenedOptionsSheet? _sheet;

  bool get isSheetOpen => _sheet != null;

  void toggleSheet({
    required String title,
    required List<Widget> Function() controlsBuilder,
    required Listenable controlsListenable,
    ControlsSheetSize sheetSize = ControlsSheetSize.medium,
    ValueChanged<double>? onExtentChanged,
  }) {
    final sheet = _sheet;
    if (sheet != null) {
      sheet.close();
      return;
    }
    final opened = _openOptionsSheet(
      context,
      title: title,
      controlsBuilder: controlsBuilder,
      controlsListenable: controlsListenable,
      sheetSize: sheetSize,
      onExtentChanged: onExtentChanged,
    );
    setState(() => _sheet = opened);
    // Also fires when the sheet closes itself, by drag or by the close button.
    opened.closed.whenComplete(() {
      if (mounted) setState(() => _sheet = null);
      // The sheet is gone, so nothing covers the map any more.
      onExtentChanged?.call(0);
    });
  }
}

/// Narrow-viewport fallback: a scene strip plus the controls toggle.
///
/// Every scene is a visible chip, so the choice reads as a choice. A picker
/// behind the current scene's name did not.
class _CompactBar extends StatefulWidget {
  const _CompactBar({
    required this.scenes,
    required this.selectedSceneId,
    required this.onSceneSelected,
    required this.controlsTitle,
    required this.controlsBuilder,
    required this.controlsListenable,
    this.controlsSheetSize = ControlsSheetSize.medium,
    this.onSheetExtentChanged,
  });

  final List<Scene> scenes;
  final String selectedSceneId;
  final ValueChanged<String> onSceneSelected;
  final String controlsTitle;
  final List<Widget> Function() controlsBuilder;
  final Listenable controlsListenable;
  final ControlsSheetSize controlsSheetSize;
  final ValueChanged<double>? onSheetExtentChanged;

  @override
  State<_CompactBar> createState() => _CompactBarState();
}

class _CompactBarState extends State<_CompactBar>
    with _ControlsSheetHost<_CompactBar> {
  @override
  Widget build(BuildContext context) {
    final controls = widget.controlsBuilder();
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      // Opaque: the bar sits on whatever the map draws, including a light
      // style that washes out a translucent fill.
      opaque: true,
      child: Row(
        children: [
          Expanded(
            child: _SceneStrip(
              scenes: widget.scenes,
              selectedSceneId: widget.selectedSceneId,
              onSceneSelected: widget.onSceneSelected,
            ),
          ),
          if (controls.isNotEmpty) ...[
            const SizedBox(width: 4),
            _ControlsToggle(
              title: widget.controlsTitle,
              open: isSheetOpen,
              onPressed: () => toggleSheet(
                title: widget.controlsTitle,
                controlsBuilder: widget.controlsBuilder,
                controlsListenable: widget.controlsListenable,
                sheetSize: widget.controlsSheetSize,
                onExtentChanged: widget.onSheetExtentChanged,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Every scene as a chip on one scrollable row.
class _SceneStrip extends StatefulWidget {
  const _SceneStrip({
    required this.scenes,
    required this.selectedSceneId,
    required this.onSceneSelected,
  });

  final List<Scene> scenes;
  final String selectedSceneId;
  final ValueChanged<String> onSceneSelected;

  @override
  State<_SceneStrip> createState() => _SceneStripState();
}

class _SceneStripState extends State<_SceneStrip> {
  final _controller = ScrollController();
  final _chipKeys = <String, GlobalKey>{};

  @override
  void didUpdateWidget(_SceneStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A scene can also be selected from elsewhere, so keep the active chip in
    // view rather than only scrolling on tap.
    if (oldWidget.selectedSceneId != widget.selectedSceneId) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelected());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _revealSelected() {
    final context = _chipKeys[widget.selectedSceneId]?.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      alignment: 0.5,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strip = SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          for (final scene in widget.scenes)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _SceneChip(
                key: _chipKeys.putIfAbsent(scene.id, GlobalKey.new),
                scene: scene,
                selected: scene.id == widget.selectedSceneId,
                onTap: () => widget.onSceneSelected(scene.id),
              ),
            ),
        ],
      ),
    );

    // A chip cut off at the trailing edge is the cue that the row scrolls.
    // Fading it reads as "more", where a hard clip reads as a glitch. Only
    // the overflowing end fades, so a row that fits keeps crisp edges.
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final position = _controller.hasClients ? _controller.position : null;
        final fadeStart = position != null && position.extentBefore > 1
            ? 0.04
            : 0.0;
        final fadeEnd = position != null && position.extentAfter > 1
            ? 0.96
            : 1.0;
        if (fadeStart == 0 && fadeEnd == 1) return child!;
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: const [
              Colors.transparent,
              Colors.white,
              Colors.white,
              Colors.transparent,
            ],
            stops: [0, fadeStart, fadeEnd, 1],
          ).createShader(bounds),
          blendMode: BlendMode.dstIn,
          child: child,
        );
      },
      child: strip,
    );
  }
}

class _SceneChip extends StatelessWidget {
  const _SceneChip({
    super.key,
    required this.scene,
    required this.selected,
    required this.onTap,
  });

  final Scene scene;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(MapboxRadius.small);
    return Material(
      color: selected ? MapboxColors.blue50 : MapboxGlass.fillRaised,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          // Tall enough to stay a comfortable touch target.
          constraints: const BoxConstraints(minHeight: 34),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: selected ? Colors.transparent : MapboxGlass.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                scene.icon,
                size: 15,
                color: selected ? Colors.white : MapboxGlass.labelMuted,
              ),
              const SizedBox(width: 6),
              Text(
                scene.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? Colors.white : MapboxGlass.labelMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Controls-sheet toggle, marked while its sheet is up.
class _ControlsToggle extends StatelessWidget {
  const _ControlsToggle({
    required this.title,
    required this.open,
    required this.onPressed,
  });

  final String title;
  final bool open;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(MapboxRadius.small);
    return Material(
      color: open ? MapboxGlass.fillSelected : MapboxGlass.fillRaised,
      borderRadius: radius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: Tooltip(
          message: title,
          child: Container(
            width: 38,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: open ? MapboxGlass.borderStrong : MapboxGlass.border,
              ),
            ),
            child: Icon(
              open ? Icons.close : Icons.tune,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Narrow-viewport fallback for [MapScaffold]: a bar with one button.
class _CompactOptionsBar extends StatefulWidget {
  const _CompactOptionsBar({
    required this.title,
    required this.controlsBuilder,
    required this.controlsListenable,
    this.controlsSheetSize = ControlsSheetSize.medium,
    this.onSheetExtentChanged,
  });

  final String title;
  final List<Widget> Function() controlsBuilder;
  final Listenable controlsListenable;
  final ControlsSheetSize controlsSheetSize;
  final ValueChanged<double>? onSheetExtentChanged;

  @override
  State<_CompactOptionsBar> createState() => _CompactOptionsBarState();
}

class _CompactOptionsBarState extends State<_CompactOptionsBar>
    with _ControlsSheetHost<_CompactOptionsBar> {
  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      // Opaque: the bar sits on whatever the map draws, including a light
      // style that washes out a translucent fill.
      opaque: true,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: MapboxGlass.labelMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          _ControlsToggle(
            title: widget.title,
            open: isSheetOpen,
            onPressed: () => toggleSheet(
              title: widget.title,
              controlsBuilder: widget.controlsBuilder,
              controlsListenable: widget.controlsListenable,
              sheetSize: widget.controlsSheetSize,
              onExtentChanged: widget.onSheetExtentChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Labelled row wrapping one control in the options panel.
class ControlRow extends StatelessWidget {
  const ControlRow({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: MapboxGlass.labelFaint,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

/// Grid of selectable option tiles.
class ControlChoices<T> extends StatelessWidget {
  const ControlChoices({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.columns = 2,
  });

  final Map<T, String> options;
  final T value;
  final ValueChanged<T> onChanged;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final entries = options.entries.toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 6.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final entry in entries)
              SizedBox(
                width: width,
                child: _ChoiceTile(
                  label: entry.value,
                  selected: entry.key == value,
                  onTap: () => onChanged(entry.key),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(MapboxRadius.small);
    return Material(
      color: selected ? MapboxGlass.fillSelected : MapboxGlass.fillRaised,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: selected ? MapboxGlass.borderStrong : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? MapboxGlass.label : MapboxGlass.labelMuted,
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact labelled on/off row.
class ControlSwitch extends StatelessWidget {
  const ControlSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: enabled ? MapboxGlass.labelMuted : MapboxGlass.labelFaint,
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: enabled ? MapboxGlass.label : MapboxGlass.labelFaint,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(value: value, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}

/// Labelled slider with a live value. Reports every change while dragging, so
/// the map follows the thumb.
class ControlSlider extends StatelessWidget {
  const ControlSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.fractionDigits = 1,
    this.unit = '',
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  /// Decimals shown in the trailing value.
  final int fractionDigits;

  /// Suffix for the trailing value, for example `°`.
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: MapboxGlass.labelFaint,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Text(
                '${value.toStringAsFixed(fractionDigits)}$unit',
                style: const TextStyle(
                  color: MapboxGlass.label,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              overlayShape: SliderComponentShape.noOverlay,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              activeTrackColor: MapboxColors.blue40,
              inactiveTrackColor: MapboxGlass.fillSelected,
              thumbColor: Colors.white,
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Full-width action button for the options panel.
class ControlAction extends StatelessWidget {
  const ControlAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.note,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Trailing hint, used to mark actions the current platform cannot run.
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed: onPressed,
          icon: icon == null ? null : Icon(icon, size: 16),
          label: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12)),
                if (note != null)
                  Text(
                    note!,
                    style: const TextStyle(
                      fontSize: 10,
                      color: MapboxGlass.labelFaint,
                    ),
                  ),
              ],
            ),
          ),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: MapboxGlass.fillRaised,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MapboxRadius.small),
            ),
          ),
        ),
      ),
    );
  }
}
