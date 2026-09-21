package com.mapbox.maps.mapbox_maps

import android.content.Context
import com.mapbox.geojson.Point
import com.mapbox.maps.MapView
import com.mapbox.maps.mapbox_maps.mapping.applyFromFLT
import com.mapbox.maps.mapbox_maps.mapping.toFLT
import com.mapbox.maps.mapbox_maps.pigeons.*
import com.mapbox.maps.plugin.LocationPuck2D
import com.mapbox.maps.plugin.LocationPuck3D
import com.mapbox.maps.plugin.locationcomponent.createDefault2DPuck
import com.mapbox.maps.plugin.locationcomponent.location
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

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

  // Native location-provider override, so the puck can be driven by an
  // externally-supplied combined GPS+indoor location provider instead of
  // Mapbox's default provider.
  private val externalLocationProvider = ExternalLocationProvider()
  private var isOverrideActive = false
  private var externalLocationChannel: MethodChannel? = null

  /**
   * Sets up the plain [MethodChannel] for `setExternalLocation`/
   * `clearExternalLocation`. Deliberately not Pigeon-generated — Mapbox
   * doesn't ship the Pigeon input specs for this plugin publicly, only the
   * generated output, so this is a small hand-written channel kept isolated
   * from the generated code to stay easy to rebase. Mirrors
   * `LocationController.setUpExternalLocationChannel` on iOS.
   */
  fun setUpExternalLocationChannel(messenger: BinaryMessenger, channelSuffix: String) {
    val channel = MethodChannel(
      messenger,
      "plugins.flutter.io.mapbox_maps_flutter.externalLocation.$channelSuffix"
    )
    channel.setMethodCallHandler { call, result -> handleExternalLocationCall(call, result) }
    externalLocationChannel = channel
  }

  private fun handleExternalLocationCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "setExternalLocation" -> setExternalLocation(call, result)
      "clearExternalLocation" -> clearExternalLocation(result)
      else -> result.notImplemented()
    }
  }

  private fun setExternalLocation(call: MethodCall, result: MethodChannel.Result) {
    val latitude = call.argument<Double>("latitude")
    val longitude = call.argument<Double>("longitude")
    if (latitude == null || longitude == null) {
      result.error("invalid_args", "setExternalLocation requires latitude and longitude", null)
      return
    }

    activateOverrideIfNeeded()
    externalLocationProvider.updateLocation(Point.fromLngLat(longitude, latitude))

    call.argument<Double>("heading")?.let { externalLocationProvider.updateBearing(it) }
    call.argument<Double>("accuracy")?.let { externalLocationProvider.updateAccuracyRadius(it) }
    // `floor` is intentionally not forwarded — see ExternalLocationProvider's
    // doc comment: this SDK's LocationConsumer has no floor concept, unlike
    // iOS's Location.floor. Callers that need floor-aware behavior (e.g.
    // indoor-map puck opacity) handle it entirely separately from this
    // override.

    result.success(null)
  }

  /**
   * Restores Mapbox's default location provider — "clear" means "go back to
   * normal GPS." Intended usage: call this on a location-stream error, where
   * presenting a stale synthetic position would be worse than falling back
   * to GPS.
   */
  private fun clearExternalLocation(result: MethodChannel.Result) {
    if (isOverrideActive) {
      isOverrideActive = false
      mapView.location.setLocationProvider(defaultLocationProvider)
    }
    result.success(null)
  }

  // Mapbox lazily creates its own DefaultLocationProvider the first time the
  // location component is enabled with no provider set (see
  // LocationComponentPluginImpl). Capture whatever is active *before* we ever
  // swap in our own, so clearExternalLocation has something real to restore.
  private val defaultLocationProvider by lazy {
    mapView.location.getLocationProvider()
      ?: com.mapbox.maps.plugin.locationcomponent.DefaultLocationProvider(context)
  }

  /**
   * Registers `externalLocationProvider` with Mapbox on first use only —
   * until `setExternalLocation` is called at least once, the map behaves
   * exactly as it does today (default provider, unmodified).
   */
  private fun activateOverrideIfNeeded() {
    if (isOverrideActive) return
    // Force evaluation before swapping so it captures the real default, not
    // our own override.
    defaultLocationProvider
    isOverrideActive = true
    mapView.location.setLocationProvider(externalLocationProvider)
  }
}