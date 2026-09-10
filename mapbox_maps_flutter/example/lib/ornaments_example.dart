import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'cities.dart';

class OrnamentsExample extends StatefulWidget {
  const OrnamentsExample({super.key});

  @override
  State<OrnamentsExample> createState() => _OrnamentsExampleState();
}

class _OrnamentsExampleState extends State<OrnamentsExample>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  MapboxMap? mapboxMap;

  /// Settings last read back from each ornament, shown under the controls.
  ///
  /// The ornament APIs update partially: every control below sends only the
  /// field it changes, and the map merges it into the settings already in
  /// effect. These are re-read after each change so the merged result is
  /// visible — including the fields a platform stores but cannot draw.
  CompassSettings? compassSettings;
  ScaleBarSettings? scaleBarSettings;
  LogoSettings? logoSettings;
  AttributionSettings? attributionSettings;

  Uint8List? _customCompassImage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.setCamera(
      CameraOptions(center: City.helsinki, zoom: 12, bearing: 40),
    );
    _refreshAll();
  }

  /// Names of the ornaments this platform does not implement, so their tabs
  /// can say so instead of failing.
  final _unsupported = <String>{};

  /// Runs [read], returning null when the platform does not implement the
  /// ornament. Not every ornament is available everywhere — web has no logo
  /// or attribution settings yet — and one missing ornament must not stop
  /// the others from working.
  Future<T?> _tryRead<T>(String ornament, Future<T> Function() read) async {
    try {
      final value = await read();
      _unsupported.remove(ornament);
      return value;
    } on UnimplementedError {
      _unsupported.add(ornament);
      return null;
    } on UnsupportedError {
      _unsupported.add(ornament);
      return null;
    }
  }

  Future<void> _refreshAll() async {
    final map = mapboxMap;
    if (map == null) return;
    final compass = await _tryRead('Compass', map.compass.getSettings);
    final scaleBar = await _tryRead('Scale bar', map.scaleBar.getSettings);
    final logo = await _tryRead('Logo', map.logo.getSettings);
    final attribution = await _tryRead(
      'Attribution',
      map.attribution.getSettings,
    );
    if (!mounted) return;
    setState(() {
      compassSettings = compass;
      scaleBarSettings = scaleBar;
      logoSettings = logo;
      attributionSettings = attribution;
    });
  }

  /// Sends [settings] to one ornament, then re-reads the merged result so the
  /// read-back rows show what the platform kept.
  Future<void> _update<T>(
    String ornament,
    Future<void> Function(T) update,
    T settings,
  ) async {
    await _tryRead(ornament, () async => update(settings));
    await _refreshAll();
  }

  Future<void> _updateCompass(CompassSettings settings) async {
    final map = mapboxMap;
    if (map == null) return;
    await _update('Compass', map.compass.updateSettings, settings);
  }

  Future<void> _updateScaleBar(ScaleBarSettings settings) async {
    final map = mapboxMap;
    if (map == null) return;
    await _update('Scale bar', map.scaleBar.updateSettings, settings);
  }

  Future<void> _updateLogo(LogoSettings settings) async {
    final map = mapboxMap;
    if (map == null) return;
    await _update('Logo', map.logo.updateSettings, settings);
  }

  Future<void> _updateAttribution(AttributionSettings settings) async {
    final map = mapboxMap;
    if (map == null) return;
    await _update('Attribution', map.attribution.updateSettings, settings);
  }

  Future<Uint8List> _loadCustomCompassImage() async {
    final cached = _customCompassImage;
    if (cached != null) return cached;
    final data = await rootBundle.load('assets/symbols/custom-icon.png');
    final bytes = data.buffer.asUint8List();
    _customCompassImage = bytes;
    return bytes;
  }

  // ===== Controls =====

  Widget _switchTile(
    String title,
    bool? value,
    ValueChanged<bool> onChanged, {
    String? subtitle,
  }) => SwitchListTile(
    dense: true,
    title: Text(title),
    subtitle: subtitle == null ? null : Text(subtitle),
    value: value ?? false,
    onChanged: onChanged,
  );

  Widget _positionTile(
    OrnamentPosition? current,
    ValueChanged<OrnamentPosition> onChanged,
  ) => ListTile(
    dense: true,
    title: const Text('Position'),
    trailing: PopupMenuButton<OrnamentPosition>(
      initialValue: current,
      onSelected: onChanged,
      child: Chip(label: Text(_positionLabel(current))),
      itemBuilder: (_) => OrnamentPosition.values
          .map(
            (pos) =>
                PopupMenuItem(value: pos, child: Text(_positionLabel(pos))),
          )
          .toList(),
    ),
  );

  /// A stepper for one numeric field, sending only that field on change.
  ///
  /// Steppers rather than sliders: a slider thumb is hard to place precisely
  /// with a mouse, and these values are read back and compared, so landing
  /// on an exact number matters more than sweeping through a range.
  Widget _stepperTile(
    String title,
    double? value,
    double min,
    double max,
    ValueChanged<double> onChanged, {
    double step = 1,
    int decimals = 0,
    String? note,
  }) {
    final current = (value ?? min).clamp(min, max);
    void nudge(double delta) =>
        onChanged((current + delta).clamp(min, max).toDouble());
    return ListTile(
      dense: true,
      title: Text(title),
      subtitle: note == null
          ? null
          : Text(note, style: Theme.of(context).textTheme.bodySmall),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove),
            tooltip: 'Decrease',
            onPressed: current <= min ? null : () => nudge(-step),
          ),
          SizedBox(
            width: 44,
            child: Text(
              current.toStringAsFixed(decimals),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add),
            tooltip: 'Increase',
            onPressed: current >= max ? null : () => nudge(step),
          ),
        ],
      ),
    );
  }

  /// Ratio steps for the scale bar, spread across the range so a few presses
  /// cover it.
  ///
  /// The scale bar treats `ratio` as a maximum width and then shrinks to the
  /// nearest round distance that fits, so neighbouring ratios often draw the
  /// same width. Which ones collide moves with the zoom and the map width,
  /// so only steps a factor of two apart would always change the drawing —
  /// too coarse to explore the range with.
  static const _ratioChoices = <double>[0.1, 0.15, 0.25, 0.4, 0.6, 0.85, 1.0];

  /// A stepper that walks a fixed list of values instead of a linear range.
  ///
  /// Used where the platforms quantise the value they receive, so the nearest
  /// value that produces a visible change is not one linear step away.
  Widget _choiceStepperTile(
    String title,
    double? value,
    List<double> choices,
    ValueChanged<double> onChanged, {
    int decimals = 0,
    String? note,
  }) {
    final current = value ?? choices.first;
    // The value in effect may come from a platform default that is not in the
    // list, so step from the closest entry rather than requiring an exact
    // match.
    var index = 0;
    for (var i = 1; i < choices.length; i++) {
      if ((choices[i] - current).abs() < (choices[index] - current).abs()) {
        index = i;
      }
    }
    return ListTile(
      dense: true,
      title: Text(title),
      subtitle: note == null
          ? null
          : Text(note, style: Theme.of(context).textTheme.bodySmall),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove),
            tooltip: 'Decrease',
            onPressed: index == 0 ? null : () => onChanged(choices[index - 1]),
          ),
          SizedBox(
            width: 44,
            child: Text(
              current.toStringAsFixed(decimals),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add),
            tooltip: 'Increase',
            onPressed: index == choices.length - 1
                ? null
                : () => onChanged(choices[index + 1]),
          ),
        ],
      ),
    );
  }

  /// The four margins, each sent on its own so the others stay untouched.
  List<Widget> _marginTiles({
    required double? left,
    required double? top,
    required double? right,
    required double? bottom,
    required ValueChanged<double> onLeft,
    required ValueChanged<double> onTop,
    required ValueChanged<double> onRight,
    required ValueChanged<double> onBottom,
  }) => [
    const ListTile(
      dense: true,
      title: Text('Margins'),
      subtitle: Text(
        'Only the two sides facing the active corner move the ornament. '
        'The others are kept and apply after a position change.',
      ),
    ),
    _stepperTile('Left', left, 0, 100, onLeft, step: 4),
    _stepperTile('Top', top, 0, 100, onTop, step: 4),
    _stepperTile('Right', right, 0, 100, onRight, step: 4),
    _stepperTile('Bottom', bottom, 0, 100, onBottom, step: 4),
  ];

  Widget _colorTile(String title, int? value, ValueChanged<int> onChanged) =>
      ListTile(
        dense: true,
        title: Text(title),
        trailing: PopupMenuButton<int>(
          initialValue: value,
          onSelected: onChanged,
          child: Chip(
            avatar: CircleAvatar(
              backgroundColor: value == null ? null : Color(value),
            ),
            label: Text(_colorLabel(value)),
          ),
          itemBuilder: (_) => _colorChoices.entries
              .map(
                (entry) =>
                    PopupMenuItem(value: entry.value, child: Text(entry.key)),
              )
              .toList(),
        ),
      );

  /// Note for a field no platform except Android draws.
  String get _androidOnly => kIsWeb
      ? 'Stored on web, but not drawn.'
      : 'Android only. Stored elsewhere, but not drawn.';

  /// Note for the scale bar styling fields, which Android and web draw but
  /// iOS does not.
  String get _stylingNote => kIsWeb
      ? 'Web maps these onto the GL JS scale bar label, so the colors are '
            'an approximation of the segmented native ruler.'
      : 'Not drawn on iOS, but stored and returned by getSettings.';

  /// Banner shown at the top of a tab whose ornament this platform has not
  /// implemented, so the controls below it do nothing.
  Widget? _unsupportedBanner(String ornament) {
    if (!_unsupported.contains(ornament)) return null;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$ornament settings are not implemented on this platform. The '
        'controls below have no effect.',
        style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
      ),
    );
  }

  /// Read-back of the fields the platform stores but may not draw, so the
  /// partial-update behaviour stays visible even for unsupported fields.
  Widget _readBack(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
    child: Text(text, style: Theme.of(context).textTheme.bodySmall),
  );

  // ===== Tabs =====

  Widget _buildCompassTab() {
    final settings = compassSettings;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ?_unsupportedBanner('Compass'),
        _switchTile(
          'Enabled',
          settings?.enabled,
          (v) => _updateCompass(CompassSettings(enabled: v)),
        ),
        _switchTile(
          'Visibility',
          settings?.visibility,
          (v) => _updateCompass(CompassSettings(visibility: v)),
          subtitle: 'Same visibility state as Enabled on iOS and web.',
        ),
        _positionTile(
          settings?.position,
          (pos) => _updateCompass(CompassSettings(position: pos)),
        ),
        ..._marginTiles(
          left: settings?.marginLeft,
          top: settings?.marginTop,
          right: settings?.marginRight,
          bottom: settings?.marginBottom,
          onLeft: (v) => _updateCompass(CompassSettings(marginLeft: v)),
          onTop: (v) => _updateCompass(CompassSettings(marginTop: v)),
          onRight: (v) => _updateCompass(CompassSettings(marginRight: v)),
          onBottom: (v) => _updateCompass(CompassSettings(marginBottom: v)),
        ),
        _stepperTile(
          'Opacity',
          settings?.opacity,
          0,
          1,
          (v) => _updateCompass(CompassSettings(opacity: v)),
          step: 0.1,
          decimals: 1,
          note: kIsWeb ? null : 'Not drawn on iOS, but stored and returned.',
        ),
        _stepperTile(
          'Rotation',
          settings?.rotation,
          0,
          360,
          (v) => _updateCompass(CompassSettings(rotation: v)),
          step: 15,
          note: _androidOnly,
        ),
        _switchTile(
          'Fade when facing north',
          settings?.fadeWhenFacingNorth,
          (v) => _updateCompass(CompassSettings(fadeWhenFacingNorth: v)),
          subtitle:
              'Rotate the map to a bearing of 0 to see the compass '
              'fade out. Tap the compass to reset the bearing.',
        ),
        _switchTile(
          'Clickable',
          settings?.clickable,
          (v) => _updateCompass(CompassSettings(clickable: v)),
          subtitle: 'Tapping the compass resets the bearing.',
        ),
        ListTile(
          dense: true,
          title: const Text('Image'),
          subtitle: const Text('An empty list restores the default needle.'),
          trailing: Wrap(
            spacing: 8,
            children: [
              TextButton(
                onPressed: () async => _updateCompass(
                  CompassSettings(image: await _loadCustomCompassImage()),
                ),
                child: const Text('Custom'),
              ),
              TextButton(
                onPressed: () =>
                    _updateCompass(CompassSettings(image: Uint8List(0))),
                child: const Text('Default'),
              ),
            ],
          ),
        ),
        _readBack(
          'Read back: opacity=${settings?.opacity}, '
          'rotation=${settings?.rotation}, '
          'fadeWhenFacingNorth=${settings?.fadeWhenFacingNorth}, '
          'clickable=${settings?.clickable}, '
          'image=${settings?.image?.length ?? 0} bytes',
        ),
      ],
    );
  }

  Widget _buildScaleBarTab() {
    final settings = scaleBarSettings;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ?_unsupportedBanner('Scale bar'),
        _switchTile(
          'Enabled',
          settings?.enabled,
          (v) => _updateScaleBar(ScaleBarSettings(enabled: v)),
        ),
        _positionTile(
          settings?.position,
          (pos) => _updateScaleBar(ScaleBarSettings(position: pos)),
        ),
        ..._marginTiles(
          left: settings?.marginLeft,
          top: settings?.marginTop,
          right: settings?.marginRight,
          bottom: settings?.marginBottom,
          onLeft: (v) => _updateScaleBar(ScaleBarSettings(marginLeft: v)),
          onTop: (v) => _updateScaleBar(ScaleBarSettings(marginTop: v)),
          onRight: (v) => _updateScaleBar(ScaleBarSettings(marginRight: v)),
          onBottom: (v) => _updateScaleBar(ScaleBarSettings(marginBottom: v)),
        ),
        ListTile(
          dense: true,
          title: const Text('Distance units'),
          trailing: PopupMenuButton<DistanceUnits>(
            initialValue: settings?.distanceUnits,
            onSelected: (units) =>
                _updateScaleBar(ScaleBarSettings(distanceUnits: units)),
            child: Chip(label: Text(_unitsLabel(settings?.distanceUnits))),
            itemBuilder: (_) => DistanceUnits.values
                .map(
                  (units) => PopupMenuItem(
                    value: units,
                    child: Text(_unitsLabel(units)),
                  ),
                )
                .toList(),
          ),
        ),
        _choiceStepperTile(
          'Ratio of map width',
          settings?.ratio,
          _ratioChoices,
          (v) => _updateScaleBar(ScaleBarSettings(ratio: v)),
          decimals: 2,
          note:
              'Ratio caps the width; the bar then shrinks to the nearest '
              'round distance that fits, so a press near the current zoom '
              'may not move it. Zoom out or press again.',
        ),
        ListTile(
          dense: true,
          title: const Text('Styling'),
          subtitle: Text(_stylingNote),
        ),
        _colorTile(
          'Text color',
          settings?.textColor,
          (v) => _updateScaleBar(ScaleBarSettings(textColor: v)),
        ),
        _colorTile(
          'Primary color',
          settings?.primaryColor,
          (v) => _updateScaleBar(ScaleBarSettings(primaryColor: v)),
        ),
        _colorTile(
          'Secondary color',
          settings?.secondaryColor,
          (v) => _updateScaleBar(ScaleBarSettings(secondaryColor: v)),
        ),
        _stepperTile(
          'Border width',
          settings?.borderWidth,
          0,
          10,
          (v) => _updateScaleBar(ScaleBarSettings(borderWidth: v)),
        ),
        _stepperTile(
          'Text size',
          settings?.textSize,
          4,
          24,
          (v) => _updateScaleBar(ScaleBarSettings(textSize: v)),
        ),
        _stepperTile(
          'Height',
          settings?.height,
          1,
          20,
          (v) => _updateScaleBar(ScaleBarSettings(height: v)),
          note: _androidOnly,
        ),
        _stepperTile(
          'Text bar margin',
          settings?.textBarMargin,
          0,
          20,
          (v) => _updateScaleBar(ScaleBarSettings(textBarMargin: v)),
          note: _androidOnly,
        ),
        _stepperTile(
          'Text border width',
          settings?.textBorderWidth,
          0,
          10,
          (v) => _updateScaleBar(ScaleBarSettings(textBorderWidth: v)),
          note: _androidOnly,
        ),
        _switchTile(
          'Show text border',
          settings?.showTextBorder,
          (v) => _updateScaleBar(ScaleBarSettings(showTextBorder: v)),
          subtitle: _androidOnly,
        ),
        _stepperTile(
          'Refresh interval (ms)',
          settings?.refreshInterval?.toDouble(),
          1,
          100,
          (v) => _updateScaleBar(ScaleBarSettings(refreshInterval: v.round())),
          step: 5,
          note: _androidOnly,
        ),
        _switchTile(
          'Continuous rendering',
          settings?.useContinuousRendering,
          (v) => _updateScaleBar(ScaleBarSettings(useContinuousRendering: v)),
          subtitle: _androidOnly,
        ),
        _readBack(
          'Read back: textColor=${_hex(settings?.textColor)}, '
          'primaryColor=${_hex(settings?.primaryColor)}, '
          'secondaryColor=${_hex(settings?.secondaryColor)}, '
          'height=${settings?.height}, '
          'textBarMargin=${settings?.textBarMargin}, '
          'textBorderWidth=${settings?.textBorderWidth}, '
          'showTextBorder=${settings?.showTextBorder}, '
          'refreshInterval=${settings?.refreshInterval}, '
          'continuous=${settings?.useContinuousRendering}',
        ),
      ],
    );
  }

  Widget _buildLogoTab() {
    final settings = logoSettings;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ?_unsupportedBanner('Logo'),
        _switchTile(
          'Enabled',
          settings?.enabled,
          (v) => _updateLogo(LogoSettings(enabled: v)),
        ),
        _positionTile(
          settings?.position,
          (pos) => _updateLogo(LogoSettings(position: pos)),
        ),
        ..._marginTiles(
          left: settings?.marginLeft,
          top: settings?.marginTop,
          right: settings?.marginRight,
          bottom: settings?.marginBottom,
          onLeft: (v) => _updateLogo(LogoSettings(marginLeft: v)),
          onTop: (v) => _updateLogo(LogoSettings(marginTop: v)),
          onRight: (v) => _updateLogo(LogoSettings(marginRight: v)),
          onBottom: (v) => _updateLogo(LogoSettings(marginBottom: v)),
        ),
      ],
    );
  }

  Widget _buildAttributionTab() {
    final settings = attributionSettings;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        ?_unsupportedBanner('Attribution'),
        _switchTile(
          'Enabled',
          settings?.enabled,
          (v) => _updateAttribution(AttributionSettings(enabled: v)),
        ),
        _positionTile(
          settings?.position,
          (pos) => _updateAttribution(AttributionSettings(position: pos)),
        ),
        ..._marginTiles(
          left: settings?.marginLeft,
          top: settings?.marginTop,
          right: settings?.marginRight,
          bottom: settings?.marginBottom,
          onLeft: (v) => _updateAttribution(AttributionSettings(marginLeft: v)),
          onTop: (v) => _updateAttribution(AttributionSettings(marginTop: v)),
          onRight: (v) =>
              _updateAttribution(AttributionSettings(marginRight: v)),
          onBottom: (v) =>
              _updateAttribution(AttributionSettings(marginBottom: v)),
        ),
        _colorTile(
          'Icon color',
          settings?.iconColor,
          (v) => _updateAttribution(AttributionSettings(iconColor: v)),
        ),
        _switchTile(
          'Clickable',
          settings?.clickable,
          (v) => _updateAttribution(AttributionSettings(clickable: v)),
        ),
        _readBack(
          'Read back: iconColor=${_hex(settings?.iconColor)}, '
          'clickable=${settings?.clickable}',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MapWidget(
            key: const ValueKey('mapWidget'),
            onMapCreated: _onMapCreated,
          ),
        ),
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Compass'),
            Tab(text: 'Scale Bar'),
            Tab(text: 'Logo'),
            Tab(text: 'Attribution'),
          ],
        ),
        SizedBox(
          height: 260,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildCompassTab(),
              _buildScaleBarTab(),
              _buildLogoTab(),
              _buildAttributionTab(),
            ],
          ),
        ),
      ],
    );
  }
}

const _colorChoices = <String, int>{
  'Black': 0xFF000000,
  'White': 0xFFFFFFFF,
  'Red': 0xFFF44336,
  'Blue': 0xFF2196F3,
  'Green': 0xFF4CAF50,
  'Translucent': 0x80000000,
};

String _colorLabel(int? value) {
  if (value == null) return 'Default';
  for (final entry in _colorChoices.entries) {
    if (entry.value == value) return entry.key;
  }
  return _hex(value);
}

String _hex(int? value) =>
    value == null ? 'null' : '0x${value.toRadixString(16).padLeft(8, '0')}';

String _positionLabel(OrnamentPosition? pos) => switch (pos) {
  OrnamentPosition.TOP_LEFT => 'Top Left',
  OrnamentPosition.TOP_RIGHT => 'Top Right',
  OrnamentPosition.BOTTOM_LEFT => 'Bottom Left',
  OrnamentPosition.BOTTOM_RIGHT => 'Bottom Right',
  null => 'Default',
};

String _unitsLabel(DistanceUnits? units) => switch (units) {
  DistanceUnits.METRIC => 'Metric',
  DistanceUnits.IMPERIAL => 'Imperial',
  DistanceUnits.NAUTICAL => 'Nautical',
  null => 'Default',
};
