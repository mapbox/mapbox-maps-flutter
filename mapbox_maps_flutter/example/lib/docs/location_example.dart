import 'dart:typed_data';
import 'dart:ui' show ImageFilter;
import 'dart:ui' as ui show Size;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// Colors cycled through by the pulsing/accuracy-ring buttons.
const _puckColors = [Colors.amber, Colors.black, Colors.blue];

class LocationExample extends StatefulWidget {
  const LocationExample({super.key});

  @override
  State<LocationExample> createState() => _LocationExampleState();
}

class _LocationExampleState extends State<LocationExample> {
  /// Space the bottom button card takes, so it can be handed to the camera as
  /// padding: without it, the card would cover whatever sits underneath it.
  static const _controlsHeight = 124.0;

  /// Extra clearance above the card: its own outer padding.
  static const _controlsClearance = 16.0;

  MapboxMap? _mapboxMap;
  final _viewportController = ViewportController();
  bool _enabled = false;
  bool _pulsing = false;
  bool _accuracy = false;
  bool _bearing = false;

  int _ringColorIndex = 0;

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    // The Mapbox logo and attribution default to the bottom edge, so they
    // would otherwise sit behind the button card.
    const ornamentMargin = _controlsHeight + _controlsClearance;
    mapboxMap.logo.updateSettings(LogoSettings(marginBottom: ornamentMargin));
    mapboxMap.attribution.updateSettings(
      AttributionSettings(marginBottom: ornamentMargin),
    );
  }

  @override
  void dispose() {
    _viewportController.dispose();
    super.dispose();
  }

  Future<void> _toggleLocation() async {
    final next = !_enabled;

    if (next) {
      await Geolocator.requestPermission();
    }

    await _mapboxMap?.location.updateSettings(
      LocationComponentSettings(enabled: next),
    );
    _viewportController.moveTo(
      next
          ? FollowPuckViewportState(
              // Keeps the puck centered above the bottom button card.
              padding: MbxEdgeInsets(
                top: 0,
                left: 0,
                right: 0,
                bottom: _controlsHeight,
              ),
            )
          : const IdleViewportState(),
      transition: const FlyViewportTransition(),
    );
    setState(() => _enabled = next);
  }

  void _togglePulsing() {
    final value = !_pulsing;
    setState(() => _pulsing = value);
    _mapboxMap?.location.updateSettings(
      LocationComponentSettings(pulsingEnabled: value),
    );
  }

  void _toggleAccuracy() {
    final value = !_accuracy;
    setState(() => _accuracy = value);
    _mapboxMap?.location.updateSettings(
      LocationComponentSettings(showAccuracyRing: value),
    );
  }

  void _toggleBearing() {
    final value = !_bearing;
    setState(() => _bearing = value);
    _mapboxMap?.location.updateSettings(
      LocationComponentSettings(puckBearingEnabled: value),
    );
  }

  /// Cycles the pulsing color, the accuracy ring's fill, and its border all
  /// at once, so one button demonstrates all three color settings.
  void _cycleRingColors() {
    _ringColorIndex = (_ringColorIndex + 1) % _puckColors.length;
    final color = _puckColors[_ringColorIndex].toARGB32();
    final nextColor = _puckColors[(_ringColorIndex + 1) % _puckColors.length]
        .toARGB32();
    _mapboxMap?.location.updateSettings(
      LocationComponentSettings(
        pulsingColor: color,
        accuracyRingColor: color,
        accuracyRingBorderColor: nextColor,
      ),
    );
  }

  Future<void> _switchToImagePuck() async {
    final bytes = await rootBundle.load('assets/symbols/custom-icon.png');
    final topImage = bytes.buffer.asUint8List();
    _mapboxMap?.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        puckBearingEnabled: true,
        locationPuck: LocationPuck(
          locationPuck2D: DefaultLocationPuck2D(
            topImage: topImage,
            shadowImage: Uint8List(0),
          ),
        ),
      ),
    );
  }

  void _switchToDuckPuck() {
    _mapboxMap?.location.updateSettings(
      LocationComponentSettings(
        locationPuck: LocationPuck(
          locationPuck3D: LocationPuck3D(
            modelUri:
                'https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Duck/glTF-Embedded/Duck.gltf',
            modelScale: [8, 8, 8],
          ),
        ),
      ),
    );
  }

  /// Restores the SDK's default 2D puck, undoing [_switchToImagePuck] and
  /// [_switchToDuckPuck]. A bare `LocationPuck2D()` would only clear the
  /// fields it sets, leaving the previous custom image in place —
  /// `DefaultLocationPuck2D()` is a marker the platform code recognizes to
  /// mean "reset to the platform's built-in puck assets".
  void _resetPuck() {
    _mapboxMap?.location.updateSettings(
      LocationComponentSettings(
        locationPuck: LocationPuck(locationPuck2D: DefaultLocationPuck2D()),
      ),
    );
  }

  Future<void> _showSettings() async {
    final settings = await _mapboxMap?.location.getSettings();
    if (settings == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'enabled: ${settings.enabled}, pulsing: ${settings.pulsingEnabled}, '
          'accuracy ring: ${settings.showAccuracyRing}, '
          'bearing: ${settings.puckBearingEnabled}',
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MapWidget(
              key: const ValueKey('mapWidget'),
              onMapCreated: _onMapCreated,
              viewportController: _viewportController,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: _ControlGrid(
                height: _controlsHeight,
                buttons: [
                  _GridButton(
                    _enabled ? 'Hide location' : 'Show location',
                    _toggleLocation,
                  ),
                  // The pulsing ring is Android and iOS only.
                  _GridButton(
                    'Pulsing',
                    kIsWeb || !_enabled ? null : _togglePulsing,
                    selected: kIsWeb || _pulsing,
                  ),
                  _GridButton(
                    'Accuracy ring',
                    _enabled ? _toggleAccuracy : null,
                    selected: _accuracy,
                  ),
                  _GridButton(
                    'Bearing',
                    _enabled ? _toggleBearing : null,
                    selected: _bearing,
                  ),
                  // The puck imagery and ring colors are Dart-side only on
                  // web — GL JS's GeolocateControl doesn't expose them (see
                  // mapbox_maps_flutter_web LocationController).
                  _GridButton(
                    'Ring colors',
                    kIsWeb || !_enabled ? null : _cycleRingColors,
                  ),
                  _GridButton(
                    'Image puck',
                    kIsWeb || !_enabled ? null : _switchToImagePuck,
                  ),
                  _GridButton(
                    '3D duck puck',
                    kIsWeb || !_enabled ? null : _switchToDuckPuck,
                  ),
                  _GridButton(
                    'Reset puck',
                    kIsWeb || !_enabled ? null : _resetPuck,
                  ),
                  _GridButton('Get settings', _enabled ? _showSettings : null),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One button in a [_ControlGrid], labelled and wired to [onPressed]. A null
/// [onPressed] renders the button disabled. [selected] highlights the button
/// for an on/off control instead of a one-shot action.
class _GridButton {
  const _GridButton(this.label, this.onPressed, {this.selected = false});

  final String label;
  final VoidCallback? onPressed;
  final bool selected;
}

/// Floating translucent card holding the example's controls in a 3-column
/// grid, docked to the bottom edge so it never covers the map's center.
class _ControlGrid extends StatelessWidget {
  const _ControlGrid({required this.height, required this.buttons});

  final double height;
  final List<_GridButton> buttons;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: height,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xCC0E1012),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x1FFFFFFF)),
            ),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 3.6,
              children: [
                for (final button in buttons)
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      disabledForegroundColor: const Color(0x80FFFFFF),
                      backgroundColor: button.selected
                          ? const Color(0x33357DF4)
                          : const Color(0x14FFFFFF),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: ui.Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textStyle: const TextStyle(fontSize: 9, height: 1.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: button.selected
                            ? const BorderSide(color: Color(0x80357DF4))
                            : BorderSide.none,
                      ),
                    ),
                    onPressed: button.onPressed,
                    child: Text(
                      button.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
