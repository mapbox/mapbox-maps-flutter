package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.Snapshotter

// ⚠️ Danger zone ⚠️

fun Snapshotter.styleManager(): com.mapbox.maps.StyleManager {
  return javaClass.getDeclaredField("coreSnapshotter").let {
    it.isAccessible = true
    return@let it.get(this) as com.mapbox.maps.StyleManager
  }
}