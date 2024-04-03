package com.mapbox.maps.mapbox_maps.mapping.turf

import com.mapbox.geojson.Point

fun Point.toList(): List<Any?> {
  return listOf(mapOf("coordinates" to coordinates()))
}

object PointDecoder {
  @Suppress("UNCHECKED_CAST")
  fun fromList(list: List<Any?>): Point {
    val rawPoint = list.first() as Map<String, Any>
    val coordinates = rawPoint["coordinates"] as List<Double>

    return Point.fromLngLat(coordinates[0], coordinates[1])
  }
}