package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.scalebar.scalebar

class ScaleBarController(private val mapView: MapView) :
  ScaleBarSettingsInterface {
  override fun getSettings(): ScaleBarSettings = mapView.scalebar.toFLT(mapView.context)
  override fun updateSettings(settings: ScaleBarSettings) {
    mapView.scalebar.applyFromFLT(settings, mapView.context)
  }
}