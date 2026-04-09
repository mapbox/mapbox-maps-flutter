import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'ornaments_example.dart';
import 'simple_map_page.dart';
import 'spinning_globe_example.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(const String.fromEnvironment('ACCESS_TOKEN'));
  runApp(const MyApp());
}

class _Example {
  final String title;
  final WidgetBuilder builder;

  const _Example({required this.title, required this.builder});
}

final _examples = [
  _Example(title: 'Simple Map View', builder: (_) => const SimpleMapPage()),
  _Example(title: 'Ornaments', builder: (_) => const OrnamentsExample()),
  _Example(
    title: 'Spinning Globe',
    builder: (_) => const SpinningGlobeExample(),
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Examples',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Examples'),
          backgroundColor: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ).inversePrimary,
        ),
        body: ListView.separated(
          itemCount: _examples.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final example = _examples[index];
            return ListTile(
              title: Text(example.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: example.builder),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
