package com.mapbox.maps.mapbox_maps

import com.mapbox.geojson.Point
import com.mapbox.maps.plugin.locationcomponent.LocationConsumer
import com.mapbox.maps.plugin.locationcomponent.LocationProvider
import java.util.concurrent.CopyOnWriteArrayList

/**
 * A [LocationProvider] whose data comes from outside Mapbox's own location
 * stack. Dart pushes updates into it via [LocationComponentController]'s
 * `setExternalLocation`/`clearExternalLocation` platform-channel handlers,
 * instead of Mapbox reading the device's location itself through
 * [com.mapbox.maps.plugin.locationcomponent.DefaultLocationProvider].
 *
 * Registered with `mapView.location.setLocationProvider(...)` the first time
 * `setExternalLocation` is called. Until then, the map behaves exactly as it
 * does today (the default provider, unmodified).
 *
 * Note: unlike iOS's `Location`, this SDK's [LocationConsumer] has no floor
 * concept at all — only [Point] and bearing/accuracy. Floor never flowed
 * through Mapbox's location APIs on Android; callers that need floor-aware
 * behavior (e.g. indoor-map puck opacity) handle it entirely separately,
 * unaffected by this override.
 */
class ExternalLocationProvider : LocationProvider {
  // Consumers come and go with puck visibility (same contract as any other
  // LocationProvider) — a plain thread-safe list, since updates can arrive
  // off the main thread depending on where the platform channel dispatches.
  private val consumers = CopyOnWriteArrayList<LocationConsumer>()

  override fun registerLocationConsumer(locationConsumer: LocationConsumer) {
    consumers.add(locationConsumer)
  }

  override fun unRegisterLocationConsumer(locationConsumer: LocationConsumer) {
    consumers.remove(locationConsumer)
  }

  /** Pushes a new position to every registered consumer. */
  fun updateLocation(point: Point) {
    consumers.forEach { it.onLocationUpdated(point) }
  }

  /** Pushes a new bearing/heading to every registered consumer. */
  fun updateBearing(bearing: Double) {
    consumers.forEach { it.onBearingUpdated(bearing) }
  }

  /** Pushes a new horizontal accuracy radius to every registered consumer. */
  fun updateAccuracyRadius(radiusMeters: Double) {
    consumers.forEach { it.onHorizontalAccuracyRadiusUpdated(radiusMeters) }
  }
}
