import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter_web/src/cluster_queries.dart';

Map<String?, Object?> _cluster(Object? id) => {
  'type': 'Feature',
  'properties': {'cluster': true, 'cluster_id': id},
};

void main() {
  group('clusterIdOf', () {
    test('reads an int cluster_id', () {
      expect(clusterIdOf(_cluster(1249)), 1249);
    });

    test('reads a whole double cluster_id', () {
      expect(clusterIdOf(_cluster(1249.0)), 1249);
    });

    test('returns null for a feature that is not a cluster', () {
      expect(clusterIdOf({'type': 'Feature', 'properties': {}}), isNull);
      expect(clusterIdOf({'type': 'Feature'}), isNull);
      expect(clusterIdOf(_cluster('1249')), isNull);
      expect(clusterIdOf(_cluster(1.5)), isNull);
    });
  });

  group('formatClusterExpansionZoom', () {
    test('formats a whole zoom without a fraction', () {
      expect(formatClusterExpansionZoom(1), '1');
    });

    test('keeps a fractional zoom', () {
      expect(formatClusterExpansionZoom(2.5), '2.5');
    });
  });
}
