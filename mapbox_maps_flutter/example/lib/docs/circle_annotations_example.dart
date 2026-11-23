import 'dart:developer';
import 'dart:math' hide log;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart' hide Visibility;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

/// Styles cycled through by the style-switch button, to show that the
/// annotations survive a style change.
const _annotationStyles = [
  MapboxStyles.MAPBOX_STREETS,
  MapboxStyles.OUTDOORS,
  MapboxStyles.LIGHT,
  MapboxStyles.DARK,
  MapboxStyles.SATELLITE_STREETS,
];

final _random = Random();

Point _randomPoint() => Point(
  coordinates: Position(
    _random.nextDouble() * 360.0 - 180.0,
    _random.nextDouble() * 180.0 - 90.0,
  ),
);

int _randomColor() => Color.fromARGB(
  255,
  _random.nextInt(256),
  _random.nextInt(256),
  _random.nextInt(256),
).toARGB32();

class CircleAnnotationExample extends StatefulWidget {
  const CircleAnnotationExample({super.key});

  @override
  State<CircleAnnotationExample> createState() =>
      _CircleAnnotationExampleState();
}

class _CircleAnnotationExampleState extends State<CircleAnnotationExample> {
  /// Space the bottom button card takes, so it can be handed to the camera as
  /// padding: without it, the card would cover whatever sits underneath it.
  static const _controlsHeight = 108.0;

  /// Extra clearance above the card: its own outer padding
  static const _controlsClearance = 16.0;

  MapboxMap? mapboxMap;
  CircleAnnotation? circleAnnotation;
  CircleAnnotationManager? circleAnnotationManager;
  List<CircleAnnotation> annotations = [];
  int styleIndex = 0;

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;

    mapboxMap.addInteraction(
      TapInteraction.onMap((context) {
        log(
          "on map tap at point: ${context.touchPosition}, lngLat: ${context.point}",
        );
      }),
    );

    mapboxMap.setCamera(
      CameraOptions(
        center: Point(coordinates: Position(0, 0)),
        zoom: 1,
        pitch: 0,
        // Keeps the map's visual center clear of the bottom button card.
        padding: MbxEdgeInsets(
          top: 0,
          left: 0,
          right: 0,
          bottom: _controlsHeight,
        ),
      ),
    );
    // The Mapbox logo and attribution default to the bottom edge, so they
    // would otherwise sit behind the button card.
    const ornamentMargin = _controlsHeight + _controlsClearance;
    mapboxMap.logo.updateSettings(LogoSettings(marginBottom: ornamentMargin));
    mapboxMap.attribution.updateSettings(
      AttributionSettings(marginBottom: ornamentMargin),
    );
    final manager = await mapboxMap.annotations.createCircleAnnotationManager();
    circleAnnotationManager = manager;

    createOneAnnotation();

    final createdAnnotations = await manager.createMulti([
      for (var i = 0; i < 200; i++)
        CircleAnnotationOptions(
          geometry: _randomPoint(),
          circleColor: _randomColor(),
          circleRadius: 8.0,
          isDraggable: true,
        ),
    ]);
    annotations = createdAnnotations.whereType<CircleAnnotation>().toList();

    manager.tapEvents(
      onTap: (annotation) => log("onAnnotationClick, id: ${annotation.id}"),
    );
    manager.longPressEvents(
      onLongPress: (annotation) =>
          log("onAnnotationLongPress, id: ${annotation.id}"),
    );
  }

  Future<void> createOneAnnotation() async {
    circleAnnotation = await circleAnnotationManager?.create(
      CircleAnnotationOptions(
        geometry: Point(coordinates: Position(0.381457, 6.687337)),
        circleColor: Colors.yellow.toARGB32(),
        circleRadius: 12.0,
        isDraggable: true,
      ),
    );
  }

  void _switchStyle() {
    styleIndex = (styleIndex + 1) % _annotationStyles.length;
    mapboxMap?.setStyleURI(_annotationStyles[styleIndex]);
  }

  void _update() {
    if (circleAnnotation == null) return;
    var point = circleAnnotation!.geometry;
    var newPoint = Point(
      coordinates: Position(
        point.coordinates.lng + 1.0,
        point.coordinates.lat + 1.0,
      ),
    );
    circleAnnotation?.geometry = newPoint;
    circleAnnotationManager?.update(circleAnnotation!);
  }

  void _delete() {
    if (circleAnnotation == null) return;
    circleAnnotationManager?.delete(circleAnnotation!);
    circleAnnotation = null;
  }

  Future<void> _deleteMulti() async {
    if (annotations.isEmpty) return;
    final toDelete = annotations.take(100).toList();
    await circleAnnotationManager?.deleteMulti(toDelete);
    annotations.removeRange(0, toDelete.length);
  }

  void _deleteAll() {
    circleAnnotationManager?.deleteAll();
    circleAnnotation = null;
    annotations.clear();
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidget"),
      onMapCreated: _onMapCreated,
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: mapWidget),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: _ControlGrid(
                height: _controlsHeight,
                buttons: [
                  _GridButton('Create', createOneAnnotation),
                  _GridButton('Update', _update),
                  _GridButton('Delete', _delete),
                  _GridButton('Delete 100', _deleteMulti),
                  _GridButton('Delete all', _deleteAll),
                  _GridButton('Switch style', _switchStyle),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One button in a [_ControlGrid], labelled and wired to [onPressed].
class _GridButton {
  const _GridButton(this.label, this.onPressed);

  final String label;
  final VoidCallback onPressed;
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
              childAspectRatio: 2.6,
              children: [
                for (final button in buttons)
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0x14FFFFFF),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      textStyle: const TextStyle(fontSize: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
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
