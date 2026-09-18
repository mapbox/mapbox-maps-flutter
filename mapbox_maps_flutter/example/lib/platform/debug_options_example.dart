import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../scene_scaffold.dart';

/// Every debug overlay the renderer can draw, grouped for the controls panel.
///
/// Terrain and layer wireframes are Android-only, so they are left out of
/// [_allOptions] on iOS rather than shown as a switch that does nothing.
List<MapWidgetDebugOptions> get _allOptions => [
  MapWidgetDebugOptions.tileBorders,
  MapWidgetDebugOptions.parseStatus,
  MapWidgetDebugOptions.timestamps,
  MapWidgetDebugOptions.collision,
  MapWidgetDebugOptions.overdraw,
  MapWidgetDebugOptions.stencilClip,
  MapWidgetDebugOptions.depthBuffer,
  MapWidgetDebugOptions.modelBounds,
  if (Platform.isAndroid) ...[
    MapWidgetDebugOptions.terrainWireframe,
    MapWidgetDebugOptions.layers2DWireframe,
    MapWidgetDebugOptions.layers3DWireframe,
  ],
  MapWidgetDebugOptions.light,
  MapWidgetDebugOptions.camera,
  MapWidgetDebugOptions.padding,
];

extension on MapWidgetDebugOptions {
  String get label {
    switch (this) {
      case MapWidgetDebugOptions.tileBorders:
        return 'Tile borders';
      case MapWidgetDebugOptions.parseStatus:
        return 'Parse status';
      case MapWidgetDebugOptions.timestamps:
        return 'Timestamps';
      case MapWidgetDebugOptions.collision:
        return 'Collision';
      case MapWidgetDebugOptions.overdraw:
        return 'Overdraw';
      case MapWidgetDebugOptions.stencilClip:
        return 'Stencil clip';
      case MapWidgetDebugOptions.depthBuffer:
        return 'Depth buffer';
      case MapWidgetDebugOptions.modelBounds:
        return 'Model bounds';
      case MapWidgetDebugOptions.terrainWireframe:
        return 'Terrain wireframe';
      case MapWidgetDebugOptions.layers2DWireframe:
        return '2D layers wireframe';
      case MapWidgetDebugOptions.layers3DWireframe:
        return '3D layers wireframe';
      case MapWidgetDebugOptions.light:
        return 'Light';
      case MapWidgetDebugOptions.camera:
        return 'Camera';
      case MapWidgetDebugOptions.padding:
        return 'Padding';
      default:
        return 'Unknown';
    }
  }

  IconData get icon {
    switch (this) {
      case MapWidgetDebugOptions.tileBorders:
        return Icons.grid_on_outlined;
      case MapWidgetDebugOptions.parseStatus:
        return Icons.rule_folder_outlined;
      case MapWidgetDebugOptions.timestamps:
        return Icons.schedule_outlined;
      case MapWidgetDebugOptions.collision:
        return Icons.grid_view_outlined;
      case MapWidgetDebugOptions.overdraw:
        return Icons.layers_outlined;
      case MapWidgetDebugOptions.stencilClip:
        return Icons.crop_outlined;
      case MapWidgetDebugOptions.depthBuffer:
        return Icons.view_in_ar_outlined;
      case MapWidgetDebugOptions.modelBounds:
        return Icons.category_outlined;
      case MapWidgetDebugOptions.terrainWireframe:
        return Icons.terrain_outlined;
      case MapWidgetDebugOptions.layers2DWireframe:
        return Icons.filter_2_outlined;
      case MapWidgetDebugOptions.layers3DWireframe:
        return Icons.filter_3_outlined;
      case MapWidgetDebugOptions.light:
        return Icons.wb_sunny_outlined;
      case MapWidgetDebugOptions.camera:
        return Icons.videocam_outlined;
      case MapWidgetDebugOptions.padding:
        return Icons.padding_outlined;
      default:
        return Icons.help_outline;
    }
  }
}

/// The renderer's debug overlays, toggled live from the controls panel.
///
/// Every switch calls `setDebugOptions` with the full enabled set, so
/// overlays can be combined freely (for example tile borders with the
/// camera readout) to inspect exactly what the renderer is doing.
class DebugOptionsExample extends StatefulWidget {
  const DebugOptionsExample({super.key});

  @override
  State<DebugOptionsExample> createState() => _DebugOptionsExampleState();
}

class _DebugOptionsExampleState extends State<DebugOptionsExample> {
  MapboxMap? _mapboxMap;
  var _enabled = <MapWidgetDebugOptions>{};

  static const _defaults = {
    MapWidgetDebugOptions.tileBorders,
    MapWidgetDebugOptions.parseStatus,
    MapWidgetDebugOptions.timestamps,
    MapWidgetDebugOptions.camera,
    MapWidgetDebugOptions.padding,
  };

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    applyCatalogOrnamentDefaults(context, mapboxMap);
    _mapboxMap = mapboxMap;
    await mapboxMap.setDebugOptions(_defaults.toList());
    setState(() => _enabled = {..._defaults});
  }

  Future<void> _toggle(MapWidgetDebugOptions option, bool value) async {
    setState(() {
      if (value) {
        _enabled.add(option);
      } else {
        _enabled.remove(option);
      }
    });
    await _mapboxMap?.setDebugOptions(_enabled.toList());
  }

  Future<void> _setAll(bool value) async {
    setState(() => _enabled = value ? _allOptions.toSet() : {});
    await _mapboxMap?.setDebugOptions(_enabled.toList());
  }

  @override
  Widget build(BuildContext context) {
    return MapScaffold(
      map: MapWidget(
        key: const ValueKey('mapWidget'),
        onMapCreated: _onMapCreated,
      ),
      controlsTitle: 'Debug overlays (${_enabled.length})',
      controlsSheetSize: ControlsSheetSize.large,
      onSheetExtentChanged: SceneScaffold.defaultOnSheetExtentChanged(
        _mapboxMap,
      ),
      controlsBuilder: () => [
        ControlRow(
          label: 'All overlays',
          child: Row(
            children: [
              Expanded(
                child: ControlAction(
                  label: 'Enable all',
                  icon: Icons.select_all,
                  onPressed: () => _setAll(true),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ControlAction(
                  label: 'Clear',
                  icon: Icons.clear_all,
                  onPressed: () => _setAll(false),
                ),
              ),
            ],
          ),
        ),
        for (final option in _allOptions)
          ControlSwitch(
            label: option.label,
            icon: option.icon,
            value: _enabled.contains(option),
            onChanged: _mapboxMap == null
                ? null
                : (value) => _toggle(option, value),
          ),
      ],
    );
  }
}
