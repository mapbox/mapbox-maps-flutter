#pragma once
#include <mapbox/bindgen/c/apis/config.h>

#ifdef __cplusplus
extern "C" {
#endif

struct mapbox_maps_Map_handle;
// NOLINTNEXTLINE(modernize-use-using)
typedef struct mapbox_maps_Map_handle* mapbox_maps_Map_t;

MAPBOX_PUBLIC mapbox_maps_Map_t MAPBOX_NONNULL mapbox_maps_Map_copyHandle(mapbox_maps_Map_t MAPBOX_NONNULL);
MAPBOX_PUBLIC void mapbox_maps_Map_release(mapbox_maps_Map_t MAPBOX_NONNULL);
MAPBOX_PUBLIC void mapbox_maps_Map_render(mapbox_maps_Map_t MAPBOX_NONNULL);

#ifdef __cplusplus
}
#endif