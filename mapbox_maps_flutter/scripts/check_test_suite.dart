// ignore_for_file: avoid_print

import 'dart:io';

// Checks that all test files in the integration_test directory
// are included in the aggregated test suite file(integration_test/all_test.dart).
//
// Should be run from the root of the examples project.
void main() {
  // Directory containing your integration tests
  final integrationTestDir = Directory('integration_test');

  // Aggregated test suite file (e.g., app_test.dart)
  final aggregatedTestSuiteFile = File('integration_test/all_test.dart');

  // Get all test files in the integration_test directory (ending with _test.dart)
  final allTestFiles = integrationTestDir
      .listSync(recursive: true)
      .where((entity) => entity is File && entity.path.endsWith('_test.dart'))
      .map((file) => file.path.replaceFirst('integration_test/', ''))
      .toList();

  // Get imported test files from the aggregated test suite
  final aggregatedTestContent = aggregatedTestSuiteFile.readAsStringSync();
  final includedTestFiles = RegExp(r"^import '([^']+)'", multiLine: true)
      .allMatches(aggregatedTestContent)
      .map((match) => match.group(1))
      .toList();

  // Normalize paths (to be safe for different platforms like Windows vs Unix)
  final missingTests = allTestFiles
      .where((testFile) => !includedTestFiles.contains(testFile))
      .toList();

  missingTests.remove('all_test.dart'); // Exclude the aggregated test suite file itself

  if (missingTests.isNotEmpty) {
    print('The following test files are missing from the aggregated test suite:');
    for (var missingTest in missingTests) {
      print(missingTest);
    }
    print('');
    print('Import the missing test files in the integration_test/all_test.dart.');
    print("Don't forget to invoke the main function of the test file as well.");
    exit(1); // Exit with error code 1 if there are missing tests
  } else {
    print('All test files are included in the aggregated test suite.');
    exit(0); // Success
  }
}
