package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.logo.logo

class LogoController(private val mapView: MapView) :
  LogoSettingsInterface {
  override fun getSettings(): LogoSettings = mapView.logo.toFLT(mapView.context)
  override fun updateSettings(settings: LogoSettings) {
    mapView.logo.applyFromFLT(settings, mapView.context)
  }
}