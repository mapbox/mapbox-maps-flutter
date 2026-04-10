import 'package:flutter/material.dart';
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

  bool compassEnabled = true;
  OrnamentPosition compassPosition = OrnamentPosition.TOP_RIGHT;

  bool scaleBarEnabled = true;
  OrnamentPosition scaleBarPosition = OrnamentPosition.TOP_LEFT;

  bool logoEnabled = true;
  OrnamentPosition logoPosition = OrnamentPosition.BOTTOM_LEFT;

  bool attributionEnabled = true;
  OrnamentPosition attributionPosition = OrnamentPosition.BOTTOM_RIGHT;

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
      CameraOptions(
        center: City.helsinki,
        zoom: 12,
        bearing: 40,
      ),
    );
    _applyAllSettings();
  }

  void _applyAllSettings() {
    mapboxMap?.compass.updateSettings(
      CompassSettings(
        enabled: compassEnabled,
        position: compassPosition,
        marginBottom: 10,
        marginLeft: 10,
        marginTop: 10,
        marginRight: 10,
      ),
    );
    mapboxMap?.scaleBar.updateSettings(
      ScaleBarSettings(
        enabled: scaleBarEnabled,
        position: scaleBarPosition,
        marginBottom: 20,
        marginLeft: 10,
        marginTop: 10,
        marginRight: 20,
      ),
    );
    mapboxMap?.logo.updateSettings(
      LogoSettings(
        enabled: logoEnabled,
        position: logoPosition,
        marginBottom: 10,
        marginLeft: 10,
        marginTop: 30,
        marginRight: 30,
      ),
    );
    mapboxMap?.attribution.updateSettings(
      AttributionSettings(
        enabled: attributionEnabled,
        position: attributionPosition,
        marginBottom: 10,
        marginLeft: 40,
        marginTop: 40,
        marginRight: 0,
      ),
    );
  }

  String _positionLabel(OrnamentPosition pos) {
    switch (pos) {
      case OrnamentPosition.TOP_LEFT:
        return 'Top Left';
      case OrnamentPosition.TOP_RIGHT:
        return 'Top Right';
      case OrnamentPosition.BOTTOM_LEFT:
        return 'Bottom Left';
      case OrnamentPosition.BOTTOM_RIGHT:
        return 'Bottom Right';
    }
  }

  Widget _buildPositionSelector(
    OrnamentPosition current,
    ValueChanged<OrnamentPosition> onChanged,
  ) {
    return ListTile(
      title: const Text('Position'),
      trailing: PopupMenuButton<OrnamentPosition>(
        initialValue: current,
        onSelected: onChanged,
        child: Chip(label: Text(_positionLabel(current))),
        itemBuilder: (_) => OrnamentPosition.values
            .map((pos) => PopupMenuItem(
                  value: pos,
                  child: Text(_positionLabel(pos)),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildCompassTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SwitchListTile(
          title: const Text('Visible'),
          value: compassEnabled,
          onChanged: (v) {
            setState(() => compassEnabled = v);
            _applyAllSettings();
          },
        ),
        const SizedBox(height: 8),
        _buildPositionSelector(compassPosition, (pos) {
          setState(() => compassPosition = pos);
          _applyAllSettings();
        }),
      ],
    );
  }

  Widget _buildScaleBarTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SwitchListTile(
          title: const Text('Visible'),
          value: scaleBarEnabled,
          onChanged: (v) {
                  setState(() => scaleBarEnabled = v);
                  _applyAllSettings();
                },
        ),
        const SizedBox(height: 8),
        _buildPositionSelector(scaleBarPosition, (pos) {
          setState(() => scaleBarPosition = pos);
          _applyAllSettings();
        }),
      ],
    );
  }

  Widget _buildLogoTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SwitchListTile(
          title: const Text('Visible'),
          value: logoEnabled,
          onChanged: (v) {
            setState(() => logoEnabled = v);
            _applyAllSettings();
          },
        ),
        const SizedBox(height: 8),
        _buildPositionSelector(logoPosition, (pos) {
          setState(() => logoPosition = pos);
          _applyAllSettings();
        }),
      ],
    );
  }

  Widget _buildAttributionTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SwitchListTile(
          title: const Text('Visible'),
          value: attributionEnabled,
          onChanged: (v) {
            setState(() => attributionEnabled = v);
            _applyAllSettings();
          },
        ),
        const SizedBox(height: 8),
        _buildPositionSelector(attributionPosition, (pos) {
          setState(() => attributionPosition = pos);
          _applyAllSettings();
        }),
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
          height: 160,
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
