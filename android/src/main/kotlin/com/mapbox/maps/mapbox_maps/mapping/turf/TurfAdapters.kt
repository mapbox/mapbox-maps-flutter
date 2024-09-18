package com.mapbox.maps.mapbox_maps.mapping.turf

import com.google.gson.Gson
import com.mapbox.geojson.*

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

fun LineString.toList(): List<Any?> {
  return listOf(mapOf("coordinates" to coordinates().map { it.coordinates() }))
}

object LineStringDecoder {
  @Suppress("UNCHECKED_CAST")
  fun fromList(list: List<Any?>): LineString {
    val rawData = list.first() as Map<String, Any>

    return LineString.fromLngLats(
      (rawData["coordinates"] as List<List<Double>>).map {
        Point.fromLngLat(it.first(), it.last())
      }
    )
  }
}

fun Polygon.toList(): List<Any?> {
  return listOf(mapOf("coordinates" to coordinates().map { it.map { it.coordinates() } }))
}

object PolygonDecoder {
  @Suppress("UNCHECKED_CAST")
  fun fromList(list: List<Any?>): Polygon {
    val rawData = list.first() as Map<String, Any>

    return Polygon.fromLngLats(
      (rawData["coordinates"] as List<List<List<Double>>>).map {
        it.map { Point.fromLngLat(it.first(), it.last()) }
      }
    )
  }
}

fun Feature.toList(): List<Any?> {
  return listOf(this.toJson())
}

object FeatureDecoder {
  @Suppress("UNCHECKED_CAST")
  fun fromList(list: List<Any?>): Feature {
    val rawData = list.first() as Map<String, Any>

    val gson = Gson()
    val json = gson.toJson(rawData)

    return Feature.fromJson(json)
  }
}