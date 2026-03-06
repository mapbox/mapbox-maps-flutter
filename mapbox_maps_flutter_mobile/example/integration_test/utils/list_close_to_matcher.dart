import 'package:flutter_test/flutter_test.dart';

Matcher listCloseTo(List<dynamic>? value, num delta) =>
    _IsListCloseTo(value, delta);

class _IsListCloseTo extends Matcher {
  final List<dynamic>? _value;
  final num _delta;

  const _IsListCloseTo(this._value, this._delta);

  @override
  bool matches(dynamic list, Map<dynamic, dynamic> matchState) {
    if (_value == null || list == null) {
      return false;
    }
    if (_value!.length != list.length) {
      return false;
    }
    for (var i = 0; i < _value!.length; i++) {
      final expected = _value![i];
      final actual = list[i];
      if (expected is num && actual is num) {
        final pairIsCloseTo = closeTo(expected, _delta).matches(actual, {});
        if (!pairIsCloseTo) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Description describe(Description description) => description
      .add('a numeric value within ')
      .addDescriptionOf(_delta)
      .add(' of ')
      .addDescriptionOf(_value);
}
