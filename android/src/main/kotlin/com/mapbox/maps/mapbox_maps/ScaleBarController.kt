package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.pigeons.FLTSettings
import com.mapbox.maps.plugin.scalebar.scalebar

class ScaleBarController(private val mapView: MapView) :
  FLTSettings.ScaleBarSettingsInterface {
  override fun getSettings(): FLTSettings.ScaleBarSettings = mapView.scalebar.toFLT()
  override fun updateSettings(settings: FLTSettings.ScaleBarSettings) {
    mapView.scalebar.applyFromFLT(settings, mapView.context)
  }
}