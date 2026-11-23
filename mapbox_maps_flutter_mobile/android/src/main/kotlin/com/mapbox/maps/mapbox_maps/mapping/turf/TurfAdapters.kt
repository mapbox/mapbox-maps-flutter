package com.mapbox.maps.mapbox_maps.mapping.turf

import com.google.gson.Gson
import com.mapbox.geojson.*

// Pigeon's default codec wraps custom data classes as `List<Any?>`.
// Mobile's Dart-side codec (rewritten in mapbox_dart_generator.dart)
// uses `turf.<Name>.toJson()` / `turf.<Name>.fromJson()` which
// produces / consumes a bare GeoJSON `Map<String, Any?>`
// (e.g. `{type: "Point", coordinates: [lng, lat]}`).
//
// To keep Dart ↔ Kotlin wire format identical, the Kotlin codec for
// these four turf types is rewritten in `mapbox_kotlin_generator.dart`
// to call `value.toMap()` / `<Name>Decoder.fromMap(...)` instead of
// `value.toList()` / `<Name>Decoder.fromList(...)`. The toMap/fromMap
// pair below uses the GeoJSON shape directly via gson where the
// underlying Mapbox geojson type ships its own toJson()/fromJson()
// (Feature) and lng/lat arithmetic for Point/LineString/Polygon.
// Without this override every Pigeon call carrying a turf payload
// silently decodes to null on Android.

private fun Map<String, Any?>.coordinatesAsList(): List<Any?> =
  this["coordinates"] as? List<Any?> ?: emptyList<Any?>()

fun Point.toMap(): Map<String, Any?> = mapOf(
  "type" to "Point",
  "coordinates" to listOf(longitude(), latitude()),
)

object PointDecoder {
  @Suppress("UNCHECKED_CAST")
  fun fromMap(map: Map<String, Any?>): Point {
    val coordinates = map["coordinates"] as List<Double>
    return Point.fromLngLat(coordinates[0], coordinates[1])
  }
}

fun LineString.toMap(): Map<String, Any?> = mapOf(
  "type" to "LineString",
  "coordinates" to coordinates().map { listOf(it.longitude(), it.latitude()) },
)

object LineStringDecoder {
  @Suppress("UNCHECKED_CAST")
  fun fromMap(map: Map<String, Any?>): LineString {
    return LineString.fromLngLats(
      (map["coordinates"] as List<List<Double>>).map {
        Point.fromLngLat(it[0], it[1])
      }
    )
  }
}

fun Polygon.toMap(): Map<String, Any?> = mapOf(
  "type" to "Polygon",
  "coordinates" to coordinates().map { ring ->
    ring.map { listOf(it.longitude(), it.latitude()) }
  },
)

object PolygonDecoder {
  @Suppress("UNCHECKED_CAST")
  fun fromMap(map: Map<String, Any?>): Polygon {
    return Polygon.fromLngLats(
      (map["coordinates"] as List<List<List<Double>>>).map { ring ->
        ring.map { Point.fromLngLat(it[0], it[1]) }
      }
    )
  }
}

fun Feature.toMap(): Map<String, Any?> {
  @Suppress("UNCHECKED_CAST")
  return Gson().fromJson(this.toJson(), Map::class.java) as Map<String, Any?>
}

object FeatureDecoder {
  fun fromMap(map: Map<String, Any?>): Feature {
    return Feature.fromJson(Gson().toJson(map))
  }
}