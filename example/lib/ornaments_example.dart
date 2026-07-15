import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'example.dart';

String _positionLabel(OrnamentPosition position) {
  switch (position) {
    case OrnamentPosition.TOP_LEFT:
      return 'TL';
    case OrnamentPosition.TOP_RIGHT:
      return 'TR';
    case OrnamentPosition.BOTTOM_LEFT:
      return 'BL';
    case OrnamentPosition.BOTTOM_RIGHT:
      return 'BR';
  }
}

/// Cycles a margin value through a small, clearly-distinguishable set so a
/// single tap visibly changes just that one side.
double _nextMarginValue(double? current) => ((current ?? 0) + 10) % 100;

class OrnamentsExample extends StatefulWidget implements Example {
  const OrnamentsExample({super.key});

  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'Ornaments';
  @override
  final String? subtitle =
      'Independently move/margin-test each ornament - useful for verifying '
      'that marginLeft/Top/Right/Bottom and enabled are tracked separately.';

  @override
  State<StatefulWidget> createState() => OrnamentsExampleState();
}

class OrnamentsExampleState extends State<OrnamentsExample> {
  MapboxMap? mapboxMap;

  /// Every ornament's state here is always whatever the last `getSettings()`
  /// call reported, never a locally-assumed value
  AttributionSettings? _attribution;
  CompassSettings? _compass;
  LogoSettings? _logo;
  ScaleBarSettings? _scaleBar;
  IndoorSelectorSettings? _indoorSelector;

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.attribution.getSettings().then((s) {
      if (mounted) setState(() => _attribution = s);
    });
    mapboxMap.compass.getSettings().then((s) {
      if (mounted) setState(() => _compass = s);
    });
    mapboxMap.logo.getSettings().then((s) {
      if (mounted) setState(() => _logo = s);
    });
    mapboxMap.scaleBar.getSettings().then((s) {
      if (mounted) setState(() => _scaleBar = s);
    });
    // IndoorSelector is currently only working on iOS
    if (Platform.isIOS) {
      mapboxMap.indoorSelector.getSettings().then((s) {
        if (mounted) setState(() => _indoorSelector = s);
      });
    }
  }

  Future<void> _updateAttribution(AttributionSettings settings) async {
    final attribution = mapboxMap?.attribution;
    if (attribution == null) return;
    await attribution.updateSettings(settings);
    final updated = await attribution.getSettings();
    if (!mounted) return;
    setState(() => _attribution = updated);
  }

  Future<void> _updateCompass(CompassSettings settings) async {
    final compass = mapboxMap?.compass;
    if (compass == null) return;
    await compass.updateSettings(settings);
    final updated = await compass.getSettings();
    if (!mounted) return;
    setState(() => _compass = updated);
  }

  Future<void> _updateLogo(LogoSettings settings) async {
    final logo = mapboxMap?.logo;
    if (logo == null) return;
    await logo.updateSettings(settings);
    final updated = await logo.getSettings();
    if (!mounted) return;
    setState(() => _logo = updated);
  }

  Future<void> _updateScaleBar(ScaleBarSettings settings) async {
    final scaleBar = mapboxMap?.scaleBar;
    if (scaleBar == null) return;
    await scaleBar.updateSettings(settings);
    final updated = await scaleBar.getSettings();
    if (!mounted) return;
    setState(() => _scaleBar = updated);
  }

  Future<void> _updateIndoorSelector(IndoorSelectorSettings settings) async {
    final indoorSelector = mapboxMap?.indoorSelector;
    if (indoorSelector == null) return;
    await indoorSelector.updateSettings(settings);
    final updated = await indoorSelector.getSettings();
    if (!mounted) return;
    setState(() => _indoorSelector = updated);
  }

  Widget _marginStepper(String label, double? value, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      child: Text('$label ${(value ?? 0).toStringAsFixed(0)}'),
    );
  }

  Widget _ornamentCard({
    required String title,
    required bool enabled,
    required OrnamentPosition position,
    required double? marginLeft,
    required double? marginTop,
    required double? marginRight,
    required double? marginBottom,
    required ValueChanged<bool> onEnabledChanged,
    required ValueChanged<OrnamentPosition> onPositionChanged,
    required void Function(String side) onBumpMargin,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Switch(value: enabled, onChanged: onEnabledChanged),
              ],
            ),
            Wrap(
              spacing: 6,
              children: [
                for (final p in OrnamentPosition.values)
                  ChoiceChip(
                    label: Text(_positionLabel(p)),
                    selected: position == p,
                    onSelected: (_) => onPositionChanged(p),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _marginStepper('L', marginLeft, () => onBumpMargin('L')),
                _marginStepper('T', marginTop, () => onBumpMargin('T')),
                _marginStepper('R', marginRight, () => onBumpMargin('R')),
                _marginStepper('B', marginBottom, () => onBumpMargin('B')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapWidget = MapWidget(
      key: const ValueKey('mapWidget'),
      onMapCreated: _onMapCreated,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 400,
            child: mapWidget,
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              _ornamentCard(
                title: 'Attribution',
                enabled: _attribution?.enabled ?? true,
                position:
                    _attribution?.position ?? OrnamentPosition.BOTTOM_RIGHT,
                marginLeft: _attribution?.marginLeft,
                marginTop: _attribution?.marginTop,
                marginRight: _attribution?.marginRight,
                marginBottom: _attribution?.marginBottom,
                onEnabledChanged: (v) => _updateAttribution(
                  AttributionSettings(enabled: v),
                ),
                onPositionChanged: (p) => _updateAttribution(
                  AttributionSettings(position: p),
                ),
                onBumpMargin: (side) {
                  if (side == 'L') {
                    _updateAttribution(
                      AttributionSettings(
                        marginLeft: _nextMarginValue(_attribution?.marginLeft),
                      ),
                    );
                  } else if (side == 'T') {
                    _updateAttribution(
                      AttributionSettings(
                        marginTop: _nextMarginValue(_attribution?.marginTop),
                      ),
                    );
                  } else if (side == 'R') {
                    _updateAttribution(
                      AttributionSettings(
                        marginRight:
                            _nextMarginValue(_attribution?.marginRight),
                      ),
                    );
                  } else {
                    _updateAttribution(
                      AttributionSettings(
                        marginBottom:
                            _nextMarginValue(_attribution?.marginBottom),
                      ),
                    );
                  }
                },
              ),
              _ornamentCard(
                title: 'Compass',
                enabled: _compass?.enabled ?? true,
                position: _compass?.position ?? OrnamentPosition.TOP_RIGHT,
                marginLeft: _compass?.marginLeft,
                marginTop: _compass?.marginTop,
                marginRight: _compass?.marginRight,
                marginBottom: _compass?.marginBottom,
                onEnabledChanged: (v) => _updateCompass(
                  CompassSettings(enabled: v),
                ),
                onPositionChanged: (p) => _updateCompass(
                  CompassSettings(position: p),
                ),
                onBumpMargin: (side) {
                  if (side == 'L') {
                    _updateCompass(
                      CompassSettings(
                        marginLeft: _nextMarginValue(_compass?.marginLeft),
                      ),
                    );
                  } else if (side == 'T') {
                    _updateCompass(
                      CompassSettings(
                        marginTop: _nextMarginValue(_compass?.marginTop),
                      ),
                    );
                  } else if (side == 'R') {
                    _updateCompass(
                      CompassSettings(
                        marginRight: _nextMarginValue(_compass?.marginRight),
                      ),
                    );
                  } else {
                    _updateCompass(
                      CompassSettings(
                        marginBottom: _nextMarginValue(_compass?.marginBottom),
                      ),
                    );
                  }
                },
              ),
              _ornamentCard(
                title: 'Logo',
                enabled: _logo?.enabled ?? true,
                position: _logo?.position ?? OrnamentPosition.BOTTOM_LEFT,
                marginLeft: _logo?.marginLeft,
                marginTop: _logo?.marginTop,
                marginRight: _logo?.marginRight,
                marginBottom: _logo?.marginBottom,
                onEnabledChanged: (v) => _updateLogo(
                  LogoSettings(enabled: v),
                ),
                onPositionChanged: (p) => _updateLogo(
                  LogoSettings(position: p),
                ),
                onBumpMargin: (side) {
                  if (side == 'L') {
                    _updateLogo(
                      LogoSettings(
                        marginLeft: _nextMarginValue(_logo?.marginLeft),
                      ),
                    );
                  } else if (side == 'T') {
                    _updateLogo(
                      LogoSettings(
                        marginTop: _nextMarginValue(_logo?.marginTop),
                      ),
                    );
                  } else if (side == 'R') {
                    _updateLogo(
                      LogoSettings(
                        marginRight: _nextMarginValue(_logo?.marginRight),
                      ),
                    );
                  } else {
                    _updateLogo(
                      LogoSettings(
                        marginBottom: _nextMarginValue(_logo?.marginBottom),
                      ),
                    );
                  }
                },
              ),
              _ornamentCard(
                title: 'Scale bar',
                enabled: _scaleBar?.enabled ?? true,
                position: _scaleBar?.position ?? OrnamentPosition.TOP_LEFT,
                marginLeft: _scaleBar?.marginLeft,
                marginTop: _scaleBar?.marginTop,
                marginRight: _scaleBar?.marginRight,
                marginBottom: _scaleBar?.marginBottom,
                onEnabledChanged: (v) => _updateScaleBar(
                  ScaleBarSettings(enabled: v),
                ),
                onPositionChanged: (p) => _updateScaleBar(
                  ScaleBarSettings(position: p),
                ),
                onBumpMargin: (side) {
                  if (side == 'L') {
                    _updateScaleBar(
                      ScaleBarSettings(
                        marginLeft: _nextMarginValue(_scaleBar?.marginLeft),
                      ),
                    );
                  } else if (side == 'T') {
                    _updateScaleBar(
                      ScaleBarSettings(
                        marginTop: _nextMarginValue(_scaleBar?.marginTop),
                      ),
                    );
                  } else if (side == 'R') {
                    _updateScaleBar(
                      ScaleBarSettings(
                        marginRight: _nextMarginValue(_scaleBar?.marginRight),
                      ),
                    );
                  } else {
                    _updateScaleBar(
                      ScaleBarSettings(
                        marginBottom: _nextMarginValue(_scaleBar?.marginBottom),
                      ),
                    );
                  }
                },
              ),
              if (Platform.isIOS)
                _ornamentCard(
                  title: 'Indoor selector (iOS only)',
                  enabled: _indoorSelector?.enabled ?? true,
                  position:
                      _indoorSelector?.position ?? OrnamentPosition.TOP_RIGHT,
                  marginLeft: _indoorSelector?.marginLeft,
                  marginTop: _indoorSelector?.marginTop,
                  marginRight: _indoorSelector?.marginRight,
                  marginBottom: _indoorSelector?.marginBottom,
                  onEnabledChanged: (v) => _updateIndoorSelector(
                    IndoorSelectorSettings(enabled: v),
                  ),
                  onPositionChanged: (p) => _updateIndoorSelector(
                    IndoorSelectorSettings(position: p),
                  ),
                  onBumpMargin: (side) {
                    if (side == 'L') {
                      _updateIndoorSelector(
                        IndoorSelectorSettings(
                          marginLeft:
                              _nextMarginValue(_indoorSelector?.marginLeft),
                        ),
                      );
                    } else if (side == 'T') {
                      _updateIndoorSelector(
                        IndoorSelectorSettings(
                          marginTop:
                              _nextMarginValue(_indoorSelector?.marginTop),
                        ),
                      );
                    } else if (side == 'R') {
                      _updateIndoorSelector(
                        IndoorSelectorSettings(
                          marginRight:
                              _nextMarginValue(_indoorSelector?.marginRight),
                        ),
                      );
                    } else {
                      _updateIndoorSelector(
                        IndoorSelectorSettings(
                          marginBottom:
                              _nextMarginValue(_indoorSelector?.marginBottom),
                        ),
                      );
                    }
                  },
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
