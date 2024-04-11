part of mapbox_maps_flutter;

/// Returns back passed value casted to the desired type
/// or null if typecasting fails
T? optionalCast<T>(dynamic value) => value is T ? value : null;
