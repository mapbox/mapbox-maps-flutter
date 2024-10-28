#pragma once

#include <mapbox/bindgen/c/apis/config.h>
#include <dart_api.h>
#include <stdint.h> // NOLINT(modernize-deprecated-headers)

#ifdef __cplusplus
extern "C" {
#endif
struct mapbox_maps_Map_handle;
// NOLINTNEXTLINE(modernize-use-using)
typedef struct mapbox_maps_Map_handle* mapbox_maps_Map_t;

// NOLINTNEXTLINE(modernize-use-using)
typedef uint8_t (*mapbox_maps_Map_CheckIfRefIsNull)(Dart_Handle MAPBOX_NULLABLE);
// NOLINTNEXTLINE(modernize-use-using)
typedef Dart_Handle MAPBOX_NONNULL (*mapbox_maps_Map_CreateDartRef)(mapbox_maps_Map_t MAPBOX_NONNULL);

MAPBOX_PUBLIC Dart_Handle MAPBOX_NONNULL mapbox_maps_Map_getDartPeerOrCreateIfNotExist(mapbox_maps_Map_t MAPBOX_NONNULL, mapbox_maps_Map_CheckIfRefIsNull MAPBOX_NONNULL, mapbox_maps_Map_CreateDartRef MAPBOX_NONNULL);
MAPBOX_PUBLIC void mapbox_maps_Map_setDartRef(mapbox_maps_Map_t MAPBOX_NONNULL, Dart_Handle MAPBOX_NONNULL);

#ifdef __cplusplus
}
#endif