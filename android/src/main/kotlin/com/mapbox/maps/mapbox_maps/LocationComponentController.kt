package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.LocationPuck2D
import com.mapbox.maps.plugin.locationcomponent.createDefault2DPuck
import com.mapbox.maps.plugin.locationcomponent.location

class LocationComponentController(private val mapView: MapView, private val context: Context) :
  _LocationComponentSettingsInterface {
  override fun getSettings(): LocationComponentSettings = mapView.location.toFLT(context)

  override fun updateSettings(settings: LocationComponentSettings, useDefaultPuck2DIfNeeded: Boolean) {
    mapView.location.applyFromFLT(settings, context)
    mapView.location.apply {
      if (locationPuck is LocationPuck2D && useDefaultPuck2DIfNeeded) {
        locationPuck = createDefault2DPuck(withBearing = settings.puckBearingEnabled == true)
          .apply {
            (locationPuck as LocationPuck2D).topImage?.let { topImage = it }
            (locationPuck as LocationPuck2D).bearingImage?.let { bearingImage = it }
            (locationPuck as LocationPuck2D).shadowImage?.let { shadowImage = it }
          }
      }
    }
  }
}