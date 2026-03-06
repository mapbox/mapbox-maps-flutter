package com.mapbox.maps.mapbox_maps

import com.mapbox.geojson.Point
import com.mapbox.maps.MapboxMap
import com.mapbox.maps.mapbox_maps.pigeons.*

class MapProjectionController(private val mapboxMap: MapboxMap) : Projection {
  override fun getMetersPerPixelAtLatitude(latitude: Double, zoom: Double): Double {
    return mapboxMap.getMetersPerPixelAtLatitude(latitude, zoom)
  }

  override fun projectedMetersForCoordinate(coordinate: Point): ProjectedMeters {
    return mapboxMap.projectedMetersForCoordinate(coordinate).toFLTProjectedMeters()
  }

  override fun coordinateForProjectedMeters(projectedMeters: ProjectedMeters): Point {
    return mapboxMap.coordinateForProjectedMeters(projectedMeters.toProjectedMeters())
  }

  override fun unproject(
    coordinate: MercatorCoordinate,
    zoomScale: Double
  ): Point {
    return mapboxMap.unproject(coordinate.toMercatorCoordinate(), zoomScale)
  }

  override fun project(
    coordinate: Point,
    zoomScale: Double
  ): MercatorCoordinate {
    return mapboxMap.project(coordinate, zoomScale).toFLTMercatorCoordinate()
  }
}