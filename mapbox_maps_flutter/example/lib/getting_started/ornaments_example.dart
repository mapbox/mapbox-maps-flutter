import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';
import '../utils.dart';

/// One scene per ornament, each exposing every field of its settings class.
///
/// The ornament APIs update partially: every control sends only the field it
/// changes, and the map merges it into the settings already in effect. Each
/// change is followed by a read-back, so the merged result stays visible —
/// including the fields a platform stores but cannot draw.
class OrnamentsExample extends StatefulWidget {
  const OrnamentsExample({super.key});

  @override
  State<OrnamentsExample> createState() => _OrnamentsExampleState();
}

const _scenes = [
  Scene(
    id: 'compass',
    title: 'Compass',
    subtitle: 'Shows the map bearing',
    icon: Icons.explore_outlined,
  ),
  Scene(
    id: 'scaleBar',
    title: 'Scale bar',
    subtitle: 'Distance reference',
    icon: Icons.straighten,
  ),
  Scene(
    id: 'logo',
    title: 'Logo',
    subtitle: 'The Mapbox wordmark',
    icon: Icons.copyright_outlined,
  ),
  Scene(
    id: 'attribution',
    title: 'Attribution',
    subtitle: 'Required data credits',
    icon: Icons.info_outline,
  ),
];

class _OrnamentsExampleState extends State<OrnamentsExample> {
  MapboxMap? _mapboxMap;
  var _sceneId = 'compass';

  /// Settings last read back from each ornament.
  CompassSettings? _compass;
  ScaleBarSettings? _scaleBar;
  LogoSettings? _logo;
  AttributionSettings? _attribution;

  /// Ornaments this platform does not implement, so their scenes can say so
  /// instead of failing.
  final _unsupported = <String>{};

  Uint8List? _customCompassImage;

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _refreshAll();
  }

  /// Runs [read], returning null when the platform does not implement the
  /// ornament. Web has no logo or attribution settings yet, and one missing
  /// ornament must not stop the others from working.
  ///
  /// The stubs throw synchronously rather than returning a failed future, so
  /// this wraps the call itself, not only the `await`.
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
    final map = _mapboxMap;
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
      _compass = compass;
      _scaleBar = scaleBar;
      _logo = logo;
      _attribution = attribution;
    });
  }

  /// Sends [settings] to one ornament, then re-reads the merged result.
  Future<void> _update<T>(
    String ornament,
    Future<void> Function(MapboxMap, T) update,
    T settings,
  ) async {
    final map = _mapboxMap;
    if (map == null) return;
    await _tryRead(ornament, () => update(map, settings));
    await _refreshAll();
  }

  Future<void> _updateCompass(CompassSettings settings) =>
      _update('Compass', (map, s) => map.compass.updateSettings(s), settings);

  Future<void> _updateScaleBar(ScaleBarSettings settings) => _update(
    'Scale bar',
    (map, s) => map.scaleBar.updateSettings(s),
    settings,
  );

  Future<void> _updateLogo(LogoSettings settings) =>
      _update('Logo', (map, s) => map.logo.updateSettings(s), settings);

  Future<void> _updateAttribution(AttributionSettings settings) => _update(
    'Attribution',
    (map, s) => map.attribution.updateSettings(s),
    settings,
  );

  Future<Uint8List> _loadCustomCompassImage() async {
    final cached = _customCompassImage;
    if (cached != null) return cached;
    final data = await rootBundle.load('assets/symbols/custom-icon.png');
    final bytes = data.buffer.asUint8List();
    _customCompassImage = bytes;
    return bytes;
  }

  /// Note for a field only Android draws.
  String get _androidOnly => kIsWeb
      ? 'Stored on web, but not drawn.'
      : 'Android only. Stored elsewhere, but not drawn.';

  /// Note for the scale bar styling fields, which Android and web draw but
  /// iOS does not.
  String get _stylingNote => kIsWeb
      ? 'Web maps these onto the GL JS scale bar label, so the colors '
            'approximate the segmented native ruler.'
      : 'Not drawn on iOS, but stored and returned by getSettings.';

  /// Note for the logo `enabled` switch.
  String get _logoEnabledNote => kIsWeb
      ? 'Hides the logo, but keeps it in the page. A style that does not '
            'require the logo hides it whatever this says.'
      : 'Restricted API. Contact Mapbox before you hide the logo.';

  /// Note for a field that only the mobile SDKs draw.
  String get _mobileOnly => kIsWeb
      ? 'Stored on web, but not drawn: GL JS draws the icon as an image '
            'that CSS cannot recolor.'
      : 'Tints the attribution icon.';

  /// Note for the attribution `clickable` field, which iOS does not model.
  String get _clickableNote => kIsWeb
      ? 'Turns pointer events on the attribution control on and off.'
      : 'Stored on iOS, but getSettings returns null for it.';

  // ===== Controls =====

  /// Banner for an ornament this platform has not implemented, so the
  /// controls below it do nothing.
  Widget? _unsupportedBanner(String ornament) {
    if (!_unsupported.contains(ornament)) return null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        '$ornament settings are not implemented on this platform. The '
        'controls below have no effect.',
        style: const TextStyle(
          fontSize: 11,
          height: 1.4,
          color: MapboxColors.orange50,
        ),
      ),
    );
  }

  Widget _note(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        height: 1.4,
        color: MapboxGlass.labelFaint,
      ),
    ),
  );

  Widget _positionChoices(
    OrnamentPosition? current,
    ValueChanged<OrnamentPosition> onChanged,
  ) => ControlRow(
    label: 'Position',
    child: ControlChoices<OrnamentPosition>(
      // Listed to match the corners visually, not enum order.
      options: const {
        OrnamentPosition.TOP_LEFT: 'Top left',
        OrnamentPosition.TOP_RIGHT: 'Top right',
        OrnamentPosition.BOTTOM_LEFT: 'Bottom left',
        OrnamentPosition.BOTTOM_RIGHT: 'Bottom right',
      },
      value: current ?? OrnamentPosition.TOP_LEFT,
      onChanged: onChanged,
    ),
  );

  /// The four margins, each sent on its own so the others stay untouched.
  List<Widget> _marginSliders({
    required double? left,
    required double? top,
    required double? right,
    required double? bottom,
    required ValueChanged<double> onLeft,
    required ValueChanged<double> onTop,
    required ValueChanged<double> onRight,
    required ValueChanged<double> onBottom,
  }) => [
    const GlassSectionLabel('Margins'),
    _note(
      'Only the two sides facing the active corner move the ornament. The '
      'others are kept and apply after a position change.',
    ),
    ControlSlider(
      label: 'Left',
      value: left ?? 0,
      min: 0,
      max: 100,
      fractionDigits: 0,
      onChanged: onLeft,
    ),
    ControlSlider(
      label: 'Top',
      value: top ?? 0,
      min: 0,
      max: 100,
      fractionDigits: 0,
      onChanged: onTop,
    ),
    ControlSlider(
      label: 'Right',
      value: right ?? 0,
      min: 0,
      max: 100,
      fractionDigits: 0,
      onChanged: onRight,
    ),
    ControlSlider(
      label: 'Bottom',
      value: bottom ?? 0,
      min: 0,
      max: 100,
      fractionDigits: 0,
      onChanged: onBottom,
    ),
  ];

  Widget _colorChoice(String label, int? value, ValueChanged<int> onChanged) =>
      ControlRow(
        label: label,
        child: ControlChoices<int>(
          columns: 3,
          options: _colorChoices,
          value: value ?? _colorChoices.keys.first,
          onChanged: onChanged,
        ),
      );

  List<Widget> _compassControls() {
    final settings = _compass;
    return [
      ?_unsupportedBanner('Compass'),
      ControlSwitch(
        label: 'Enabled',
        icon: Icons.visibility_outlined,
        value: settings?.enabled ?? false,
        onChanged: (v) => _updateCompass(CompassSettings(enabled: v)),
      ),
      ControlSwitch(
        label: 'Visibility',
        value: settings?.visibility ?? false,
        onChanged: (v) => _updateCompass(CompassSettings(visibility: v)),
      ),
      _note('Visibility is the same state as Enabled on iOS and web.'),
      _positionChoices(
        settings?.position,
        (pos) => _updateCompass(CompassSettings(position: pos)),
      ),
      ControlSlider(
        label: 'Opacity',
        value: settings?.opacity ?? 1,
        min: 0,
        max: 1,
        onChanged: (v) => _updateCompass(CompassSettings(opacity: v)),
      ),
      if (!kIsWeb)
        _note('Opacity is not drawn on iOS, but stored and returned.'),
      ControlSlider(
        label: 'Rotation',
        value: settings?.rotation ?? 0,
        min: 0,
        max: 360,
        fractionDigits: 0,
        unit: '°',
        onChanged: (v) => _updateCompass(CompassSettings(rotation: v)),
      ),
      _note('Rotation: $_androidOnly'),
      ControlSwitch(
        label: 'Fade when facing north',
        value: settings?.fadeWhenFacingNorth ?? false,
        onChanged: (v) =>
            _updateCompass(CompassSettings(fadeWhenFacingNorth: v)),
      ),
      _note(
        'Rotate the map to a bearing of 0 to see the compass fade out. Tap '
        'the compass to reset the bearing.',
      ),
      ControlSwitch(
        label: 'Clickable',
        value: settings?.clickable ?? false,
        onChanged: (v) => _updateCompass(CompassSettings(clickable: v)),
      ),
      ..._marginSliders(
        left: settings?.marginLeft,
        top: settings?.marginTop,
        right: settings?.marginRight,
        bottom: settings?.marginBottom,
        onLeft: (v) => _updateCompass(CompassSettings(marginLeft: v)),
        onTop: (v) => _updateCompass(CompassSettings(marginTop: v)),
        onRight: (v) => _updateCompass(CompassSettings(marginRight: v)),
        onBottom: (v) => _updateCompass(CompassSettings(marginBottom: v)),
      ),
      const GlassSectionLabel('Image'),
      ControlAction(
        label: 'Custom needle',
        icon: Icons.image_outlined,
        onPressed: () async => _updateCompass(
          CompassSettings(image: await _loadCustomCompassImage()),
        ),
      ),
      ControlAction(
        label: 'Default needle',
        icon: Icons.restart_alt,
        note: 'An empty list restores the default.',
        onPressed: () => _updateCompass(CompassSettings(image: Uint8List(0))),
      ),
    ];
  }

  List<Widget> _scaleBarControls() {
    final settings = _scaleBar;
    return [
      ?_unsupportedBanner('Scale bar'),
      ControlSwitch(
        label: 'Enabled',
        icon: Icons.visibility_outlined,
        value: settings?.enabled ?? false,
        onChanged: (v) => _updateScaleBar(ScaleBarSettings(enabled: v)),
      ),
      _positionChoices(
        settings?.position,
        (pos) => _updateScaleBar(ScaleBarSettings(position: pos)),
      ),
      ControlRow(
        label: 'Distance units',
        child: ControlChoices<DistanceUnits>(
          columns: 3,
          options: const {
            DistanceUnits.METRIC: 'Metric',
            DistanceUnits.IMPERIAL: 'Imperial',
            DistanceUnits.NAUTICAL: 'Nautical',
          },
          value: settings?.distanceUnits ?? DistanceUnits.METRIC,
          onChanged: (units) =>
              _updateScaleBar(ScaleBarSettings(distanceUnits: units)),
        ),
      ),
      ControlSlider(
        label: 'Ratio of map width',
        value: settings?.ratio ?? 0.5,
        min: 0.1,
        max: 1,
        fractionDigits: 2,
        onChanged: (v) => _updateScaleBar(ScaleBarSettings(ratio: v)),
      ),
      _note(
        'Ratio caps the width; the bar then shrinks to the nearest round '
        'distance that fits, so a small change may not move it.',
      ),
      const GlassSectionLabel('Styling'),
      _note(_stylingNote),
      _colorChoice(
        'Text color',
        settings?.textColor,
        (v) => _updateScaleBar(ScaleBarSettings(textColor: v)),
      ),
      _colorChoice(
        'Primary color',
        settings?.primaryColor,
        (v) => _updateScaleBar(ScaleBarSettings(primaryColor: v)),
      ),
      _colorChoice(
        'Secondary color',
        settings?.secondaryColor,
        (v) => _updateScaleBar(ScaleBarSettings(secondaryColor: v)),
      ),
      ControlSlider(
        label: 'Border width',
        value: settings?.borderWidth ?? 2,
        min: 0,
        max: 10,
        fractionDigits: 0,
        onChanged: (v) => _updateScaleBar(ScaleBarSettings(borderWidth: v)),
      ),
      ControlSlider(
        label: 'Text size',
        value: settings?.textSize ?? 8,
        min: 4,
        max: 24,
        fractionDigits: 0,
        onChanged: (v) => _updateScaleBar(ScaleBarSettings(textSize: v)),
      ),
      ..._marginSliders(
        left: settings?.marginLeft,
        top: settings?.marginTop,
        right: settings?.marginRight,
        bottom: settings?.marginBottom,
        onLeft: (v) => _updateScaleBar(ScaleBarSettings(marginLeft: v)),
        onTop: (v) => _updateScaleBar(ScaleBarSettings(marginTop: v)),
        onRight: (v) => _updateScaleBar(ScaleBarSettings(marginRight: v)),
        onBottom: (v) => _updateScaleBar(ScaleBarSettings(marginBottom: v)),
      ),
      const GlassSectionLabel('Android only'),
      _note(_androidOnly),
      ControlSlider(
        label: 'Height',
        value: settings?.height ?? 2,
        min: 1,
        max: 20,
        fractionDigits: 0,
        onChanged: (v) => _updateScaleBar(ScaleBarSettings(height: v)),
      ),
      ControlSlider(
        label: 'Text bar margin',
        value: settings?.textBarMargin ?? 8,
        min: 0,
        max: 20,
        fractionDigits: 0,
        onChanged: (v) => _updateScaleBar(ScaleBarSettings(textBarMargin: v)),
      ),
      ControlSlider(
        label: 'Text border width',
        value: settings?.textBorderWidth ?? 2,
        min: 0,
        max: 10,
        fractionDigits: 0,
        onChanged: (v) => _updateScaleBar(ScaleBarSettings(textBorderWidth: v)),
      ),
      ControlSwitch(
        label: 'Show text border',
        value: settings?.showTextBorder ?? false,
        onChanged: (v) => _updateScaleBar(ScaleBarSettings(showTextBorder: v)),
      ),
      ControlSlider(
        label: 'Refresh interval',
        value: (settings?.refreshInterval ?? 15).toDouble(),
        min: 1,
        max: 100,
        fractionDigits: 0,
        unit: ' ms',
        onChanged: (v) =>
            _updateScaleBar(ScaleBarSettings(refreshInterval: v.round())),
      ),
      ControlSwitch(
        label: 'Continuous rendering',
        value: settings?.useContinuousRendering ?? false,
        onChanged: (v) =>
            _updateScaleBar(ScaleBarSettings(useContinuousRendering: v)),
      ),
    ];
  }

  List<Widget> _logoControls() {
    final settings = _logo;
    return [
      ?_unsupportedBanner('Logo'),
      ControlSwitch(
        label: 'Enabled',
        icon: Icons.visibility_outlined,
        value: settings?.enabled ?? false,
        onChanged: (v) => _updateLogo(LogoSettings(enabled: v)),
      ),
      _note(_logoEnabledNote),
      _positionChoices(
        settings?.position,
        (pos) => _updateLogo(LogoSettings(position: pos)),
      ),
      ..._marginSliders(
        left: settings?.marginLeft,
        top: settings?.marginTop,
        right: settings?.marginRight,
        bottom: settings?.marginBottom,
        onLeft: (v) => _updateLogo(LogoSettings(marginLeft: v)),
        onTop: (v) => _updateLogo(LogoSettings(marginTop: v)),
        onRight: (v) => _updateLogo(LogoSettings(marginRight: v)),
        onBottom: (v) => _updateLogo(LogoSettings(marginBottom: v)),
      ),
    ];
  }

  List<Widget> _attributionControls() {
    final settings = _attribution;
    return [
      ?_unsupportedBanner('Attribution'),
      ControlSwitch(
        label: 'Enabled',
        icon: Icons.visibility_outlined,
        value: settings?.enabled ?? false,
        onChanged: (v) => _updateAttribution(AttributionSettings(enabled: v)),
      ),
      ControlSwitch(
        label: 'Clickable',
        value: settings?.clickable ?? false,
        onChanged: (v) => _updateAttribution(AttributionSettings(clickable: v)),
      ),
      _note(_clickableNote),
      _positionChoices(
        settings?.position,
        (pos) => _updateAttribution(AttributionSettings(position: pos)),
      ),
      _colorChoice(
        'Icon color',
        settings?.iconColor,
        (v) => _updateAttribution(AttributionSettings(iconColor: v)),
      ),
      _note(_mobileOnly),
      ..._marginSliders(
        left: settings?.marginLeft,
        top: settings?.marginTop,
        right: settings?.marginRight,
        bottom: settings?.marginBottom,
        onLeft: (v) => _updateAttribution(AttributionSettings(marginLeft: v)),
        onTop: (v) => _updateAttribution(AttributionSettings(marginTop: v)),
        onRight: (v) => _updateAttribution(AttributionSettings(marginRight: v)),
        onBottom: (v) =>
            _updateAttribution(AttributionSettings(marginBottom: v)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SceneScaffold(
      scenes: _scenes,
      selectedSceneId: _sceneId,
      onSceneSelected: (id) => setState(() => _sceneId = id),
      controlsTitle: 'Ornament',
      controlsSheetSize: ControlsSheetSize.large,
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      // This example moves the ornaments around the map's corners, so the
      // panels stay centered to keep every corner visible.
      centerPanels: true,
      map: MapWidget(
        key: const ValueKey('mapWidget'),
        styleUri: MapboxStyles.STANDARD,
        viewport: CameraViewportState(
          center: City.helsinki,
          zoom: 12,
          bearing: 40,
        ),
        onMapCreated: _onMapCreated,
      ),
      controlsBuilder: () => switch (_sceneId) {
        'scaleBar' => _scaleBarControls(),
        'logo' => _logoControls(),
        'attribution' => _attributionControls(),
        _ => _compassControls(),
      },
    );
  }
}

const _colorChoices = <int, String>{
  0xFF000000: 'Black',
  0xFFFFFFFF: 'White',
  0xFFF44336: 'Red',
  0xFF2196F3: 'Blue',
  0xFF4CAF50: 'Green',
};
