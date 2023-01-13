package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.attribution.attribution

class AttributionController(private val mapView: MapView) :
  FLTSettings.AttributionSettingsInterface {
  override fun getSettings(): FLTSettings.AttributionSettings = mapView.attribution.toFLT()
  override fun updateSettings(settings: FLTSettings.AttributionSettings) {
    mapView.attribution.applyFromFLT(settings, mapView.context)
  }
}