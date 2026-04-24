import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'example.dart';

/// Demonstrates [ViewAnnotationManager] by anchoring three custom Flutter
/// widgets — a numbered pin, a price bubble, and an interactive avatar — to
/// geographic coordinates. The widgets are rasterized once on creation and
/// reprojected natively during camera animations.
class ViewAnnotationExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.place_outlined);
  @override
  final String title = 'View Annotations (Flutter widgets as markers)';
  @override
  final String? subtitle =
      'Mounts custom widgets as native view annotations on the map.';

  @override
  State<ViewAnnotationExample> createState() => _ViewAnnotationExampleState();
}

class _ViewAnnotationExampleState extends State<ViewAnnotationExample> {
  ViewAnnotationManager? _manager;
  String? _lastTappedId;

  @override
  void dispose() {
    _manager?.dispose();
    super.dispose();
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    await mapboxMap.setCamera(CameraOptions(
      center: Point(coordinates: Position(2.349, 48.864)),
      zoom: 12,
    ));

    final manager = await mapboxMap.annotations.createViewAnnotationManager();
    _manager = manager;

    manager.tapEvents.listen((event) {
      setState(() => _lastTappedId = event.annotationId);
    });

    await manager.create(ViewAnnotationOptions(
      geometry: Point(coordinates: Position(2.349, 48.864)),
      anchor: ViewAnnotationAnchor.BOTTOM,
      offsetY: -4,
      widget: const _NumberedPin(label: '1'),
    ));

    await manager.create(ViewAnnotationOptions(
      geometry: Point(coordinates: Position(2.332, 48.872)),
      anchor: ViewAnnotationAnchor.BOTTOM,
      offsetY: -4,
      widget: const _PriceBubble(label: '€129'),
    ));

    await manager.create(ViewAnnotationOptions(
      geometry: Point(coordinates: Position(2.365, 48.857)),
      anchor: ViewAnnotationAnchor.CENTER,
      widget: const _Avatar(initials: 'AL'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Annotations')),
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey('viewAnnotationsMap'),
            onMapCreated: _onMapCreated,
          ),
          if (_lastTappedId != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Last tapped: $_lastTappedId'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NumberedPin extends StatelessWidget {
  const _NumberedPin({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 52,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBubble extends StatelessWidget {
  const _PriceBubble({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black26),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.indigo,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
