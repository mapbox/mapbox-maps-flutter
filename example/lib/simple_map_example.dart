import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class SimpleMapExample extends StatefulWidget implements Example {
  const SimpleMapExample({super.key});

  @override
  final Widget leading = const Icon(Icons.map_outlined);
  @override
  final String title = 'Display a simple map';
  @override
  final String subtitle =
      'Create and display a map that uses the default Mapbox Standard style.';

  @override
  State<StatefulWidget> createState() => _SimpleMapState();
}

class _SimpleMapState extends State<SimpleMapExample> {
  _SimpleMapState();
  final widgetSize = Size(width: 400, height: 400);
  final textureChannel = MethodChannel('mapbox_maps/texture');
  int? _textureId;

  @override
  void initState() {
    fetchTextureId();
    super.initState();
  }

  void fetchTextureId() async {
    final int textureId = await textureChannel.invokeMethod("getTextureId", {
      "width": widgetSize.width,
      "height": widgetSize.height,
    });
    setState(() {
      _textureId = textureId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textureId = _textureId;
    if (textureId == null) {
      return const SizedBox.shrink();
    }
    
    return RepaintBoundary(
      child: SizedBox(
        width: widgetSize.width,
        height: widgetSize.height,
        child: Texture(textureId: textureId),
      ),
    );
  }
}
