package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.attribution.attribution

class AttributionController(private val mapView: MapView) :
  AttributionSettingsInterface {
  override fun getSettings(): AttributionSettings = mapView.attribution.toFLT(mapView.context)
  override fun updateSettings(settings: AttributionSettings) {
    mapView.attribution.applyFromFLT(settings, mapView.context)
  }
}