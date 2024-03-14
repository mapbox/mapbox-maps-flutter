package com.mapbox.maps.mapbox_maps.mapping.turf

import com.google.gson.Gson
import com.mapbox.geojson.Point

fun Point.toList(): List<Any?> {
  return listOf(mapOf("coordinates" to coordinates()))
}

object PointDecoder {
  fun fromList(list: List<Any?>): Point {
    return Point.fromJson(Gson().toJson(list.first()))
  }
}