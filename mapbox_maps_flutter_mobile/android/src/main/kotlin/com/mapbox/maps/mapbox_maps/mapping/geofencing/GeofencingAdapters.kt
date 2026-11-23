package com.mapbox.maps.mapbox_maps.mapping.geofencing

import com.mapbox.common.geofencing.GeofenceState
import com.mapbox.common.geofencing.GeofencingEvent
import com.mapbox.common.geofencing.geofenceState
import com.mapbox.common.geofencing.geofencingEvent
import com.mapbox.maps.mapbox_maps.mapping.turf.FeatureDecoder
import com.mapbox.maps.mapbox_maps.mapping.turf.toMap
import java.util.Date

// Pigeon codec adapters for Common's geofencing types. The wire format is
// `[feature, timestamp in milliseconds]`, matching `encode` and `decode` of
// the platform interface's GeofencingEvent and GeofenceState.

fun GeofencingEvent.toList(): List<Any?> = listOf(feature.toMap(), timestamp.time)

object GeofencingEventDecoder {
  @Suppress("UNCHECKED_CAST")
  fun fromList(list: List<Any?>): GeofencingEvent = geofencingEvent(
    FeatureDecoder.fromMap(list[0] as Map<String, Any?>),
    Date((list[1] as Number).toLong()),
  )
}

fun GeofenceState.toList(): List<Any?> = listOf(feature.toMap(), timestamp?.time)

object GeofenceStateDecoder {
  @Suppress("UNCHECKED_CAST")
  fun fromList(list: List<Any?>): GeofenceState =
    geofenceState(FeatureDecoder.fromMap(list[0] as Map<String, Any?>)) {
      timestamp = (list[1] as Number?)?.let { Date(it.toLong()) }
    }
}