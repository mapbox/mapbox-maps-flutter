package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapView
import com.mapbox.maps.MapboxExperimental
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.mapbox_maps.pigeons.IndoorSelectorSettings
import com.mapbox.maps.mapbox_maps.pigeons.IndoorSelectorSettingsInterface
import com.mapbox.maps.plugin.indoorselector.indoorSelector

class IndoorSelectorController(private val mapView: MapView) : IndoorSelectorSettingsInterface {

  @OptIn(MapboxExperimental::class)
  override fun getSettings(): IndoorSelectorSettings = mapView.indoorSelector.toFLT(mapView.context)

  @OptIn(MapboxExperimental::class)
  override fun updateSettings(settings: IndoorSelectorSettings) {
    mapView.indoorSelector.applyFromFLT(settings, mapView.context)
  }
}