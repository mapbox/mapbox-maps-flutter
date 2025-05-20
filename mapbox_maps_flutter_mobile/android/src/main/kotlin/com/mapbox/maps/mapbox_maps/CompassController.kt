package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.compass.compass

class CompassController(private val mapView: MapView) :
  CompassSettingsInterface {
  override fun getSettings(): CompassSettings = mapView.compass.toFLT(mapView.context)
  override fun updateSettings(settings: CompassSettings) {
    mapView.compass.applyFromFLT(settings, mapView.context)
  }
}