package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.locationcomponent.createDefault2DPuck
import com.mapbox.maps.plugin.locationcomponent.location

class LocationComponentController(
  private val mapView: MapView,
  private val context: Context
) : _LocationComponentSettingsInterface {
  override fun getSettings(): LocationComponentSettings = mapView.location.toFLT(context)

  override fun updateSettings(settings: LocationComponentSettings, useDefaultPuck2DIfNeeded: Boolean) {
    if (useDefaultPuck2DIfNeeded) {
      mapView.location.locationPuck = createDefault2DPuck(withBearing = settings.puckBearingEnabled == true)
    }
    mapView.location.applyFromFLT(settings, useDefaultPuck2DIfNeeded, context)
  }
}