part of mapbox_maps_flutter;

/// Returns back the passed value casted to the desired type
/// or null if typecasting fails
T? _optionalCast<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  // Cast int(num) to double,
  // as GL Native converts e.g. 1.0 to 1 (int),
  // which trips dart up
  if (value is num && T == double) {
    return value.toDouble() as T;
  }
  return null;
}

List<T>? _optionalCastList<T>(dynamic value) {
  if (value is List) {
    return value.where((value) => value is T).cast<T>().toList();
  }
  return null;
}
