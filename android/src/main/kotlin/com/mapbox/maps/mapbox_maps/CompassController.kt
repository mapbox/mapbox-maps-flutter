package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.compass.compass

class CompassController(private val mapView: MapView) :
  FLTSettings.CompassSettingsInterface {
  override fun getSettings(): FLTSettings.CompassSettings = mapView.compass.toFLT()
  override fun updateSettings(settings: FLTSettings.CompassSettings) {
    mapView.compass.applyFromFLT(settings, mapView.context)
  }
}