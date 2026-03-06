package com.mapbox.maps.mapbox_maps.annotation

import com.mapbox.maps.plugin.annotation.AnnotationManager

interface ControllerDelegate {
  fun getManager(managerId: String): AnnotationManager<*, *, *, *, *, *, *>
}