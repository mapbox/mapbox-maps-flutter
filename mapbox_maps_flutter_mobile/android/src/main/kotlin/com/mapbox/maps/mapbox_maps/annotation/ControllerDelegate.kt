package com.mapbox.maps.mapbox_maps.annotation

import com.mapbox.maps.MapboxStyleManager
import com.mapbox.maps.plugin.annotation.AnnotationManager

interface ControllerDelegate {
  fun getManager(managerId: String): AnnotationManager<*, *, *, *, *, *, *>
  fun getStyleManager(): MapboxStyleManager
}