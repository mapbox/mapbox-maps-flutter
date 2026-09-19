package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.LocationPuck2D
import com.mapbox.maps.plugin.LocationPuck3D
import com.mapbox.maps.plugin.locationcomponent.createDefault2DPuck
import com.mapbox.maps.plugin.locationcomponent.location

class LocationComponentController(
  private val mapView: MapView,
  private val context: Context
) : _LocationComponentSettingsInterface {
  // `locationPuck` only holds the active type, dropping the other one's
  // config. Cache both so they survive a detour through the other type.
  private var cachedPuck2D: LocationPuck2D? = null
  private var cachedPuck3D: LocationPuck3D? = null

  override fun getSettings(): LocationComponentSettings = mapView.location.toFLT(context)

  override fun updateSettings(settings: LocationComponentSettings, useDefaultPuck2DIfNeeded: Boolean) {
    if (useDefaultPuck2DIfNeeded && mapView.location.locationPuck == null) {
      mapView.location.locationPuck = createDefault2DPuck(withBearing = settings.puckBearingEnabled == true)
    }
    mapView.location.applyFromFLT(settings, useDefaultPuck2DIfNeeded, cachedPuck2D, cachedPuck3D, context)
    (mapView.location.locationPuck as? LocationPuck2D)?.let { cachedPuck2D = it }
    (mapView.location.locationPuck as? LocationPuck3D)?.let { cachedPuck3D = it }
  }
}