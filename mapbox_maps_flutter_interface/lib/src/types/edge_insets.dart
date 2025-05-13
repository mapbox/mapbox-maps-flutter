/// Represents immutable edge insets, typically used for padding or margins.
/// This class defines the distances from the edges of a rectangle.
class MbxEdgeInsets {
  /// The distance from the top edge.
  final double top;

  /// The distance from the left edge.
  final double left;

  /// The distance from the bottom edge.
  final double bottom;

  /// The distance from the right edge.
  final double right;

  /// Creates an immutable [MbxEdgeInsets] instance.
  ///
  /// All parameters are required and must not be null.
  const MbxEdgeInsets({
    required this.top,
    required this.left,
    required this.bottom,
    required this.right,
  });

  /// Creates an [MbxEdgeInsets] instance with all edges set to the same value.
  const MbxEdgeInsets.all(double value)
      : top = value,
        left = value,
        bottom = value,
        right = value;

  /// Creates an [MbxEdgeInsets] instance with symmetric vertical and horizontal values.
  const MbxEdgeInsets.symmetric({
    double vertical = 0.0,
    double horizontal = 0.0,
  })  : top = vertical,
        bottom = vertical,
        left = horizontal,
        right = horizontal;

  /// Returns a string representation of the edge insets.
  @override
  String toString() {
    return 'MbxEdgeInsets(top: $top, left: $left, bottom: $bottom, right: $right)';
  }

  /// Compares two [MbxEdgeInsets] instances for equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MbxEdgeInsets) return false;
    return top == other.top &&
        left == other.left &&
        bottom == other.bottom &&
        right == other.right;
  }

  @override
  int get hashCode => Object.hash(top, left, bottom, right);
}
