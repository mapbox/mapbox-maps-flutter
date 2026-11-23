import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Each file in `lib/docs/` is published verbatim on the documentation site,
/// where a reader pastes it into their own app. Such a file must compile on its
/// own: it can import `package:` libraries, but nothing from this example app.
void main() {
  test('examples in lib/docs import no example-app files', () {
    final directory = Directory('lib/docs');
    expect(
      directory.existsSync(),
      isTrue,
      reason: 'lib/docs must exist; run this test from the example app root.',
    );

    final files = directory
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList();
    expect(files, isNotEmpty, reason: 'lib/docs should not be empty.');

    final offenders = <String>[];
    for (final file in files) {
      for (final line in file.readAsLinesSync()) {
        final trimmed = line.trimLeft();
        if (!trimmed.startsWith('import ') && !trimmed.startsWith('export ')) {
          continue;
        }
        final isRelative =
            trimmed.contains("'./") ||
            trimmed.contains("'../") ||
            RegExp("['\"][a-z0-9_]+\\.dart['\"]").hasMatch(trimmed);
        final isExamplePackage = trimmed.contains(
          'package:mapbox_maps_flutter_examples/',
        );
        if (isRelative || isExamplePackage) {
          offenders.add('${file.path}: $trimmed');
        }
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These files back docs.mapbox.com examples and must stay '
          'self-contained, so a reader can copy one into their own app. '
          'Either drop the shared '
          'import, or move the example out of lib/docs and clear its '
          'docsUrl.\n${offenders.join('\n')}',
    );
  });
}
