/// The number of leaves that `getGeoJsonClusterLeaves` returns when the
/// caller gives no limit. The mobile SDKs use the same value.
const defaultClusterLeavesLimit = 10;

/// The number of leaves that `getGeoJsonClusterLeaves` skips when the caller
/// gives no offset. The mobile SDKs use the same value.
const defaultClusterLeavesOffset = 0;

/// Reads the cluster id from the `cluster_id` property of a cluster
/// [feature], or returns `null` if [feature] is not a cluster.
///
/// Like the mobile SDKs, accepts an integer or a whole double.
int? clusterIdOf(Map<String?, Object?> feature) {
  final properties = feature['properties'];
  final id = properties is Map ? properties['cluster_id'] : null;
  return switch (id) {
    int() => id,
    double() when id == id.truncateToDouble() => id.toInt(),
    _ => null,
  };
}

/// Formats a cluster expansion [zoom] as the mobile SDKs do, for example
/// `1` and not `1.0`.
String formatClusterExpansionZoom(double zoom) =>
    zoom == zoom.truncateToDouble() ? zoom.toInt().toString() : '$zoom';
