package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.logo.logo

class LogoController(private val mapView: MapView) :
  FLTSettings.LogoSettingsInterface {
  override fun getSettings(): FLTSettings.LogoSettings = mapView.logo.toFLT()
  override fun updateSettings(settings: FLTSettings.LogoSettings) {
    mapView.logo.applyFromFLT(settings, mapView.context)
  }
}