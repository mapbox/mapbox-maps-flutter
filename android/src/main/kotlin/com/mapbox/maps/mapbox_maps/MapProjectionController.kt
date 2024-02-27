package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapboxMap
import com.mapbox.maps.mapbox_maps.pigeons.*

class MapProjectionController(private val mapboxMap: MapboxMap) : Projection {
  override fun getMetersPerPixelAtLatitude(latitude: Double, zoom: Double): Double {
    return mapboxMap.getMetersPerPixelAtLatitude(latitude, zoom)
  }

  override fun projectedMetersForCoordinate(coordinate: Map<String?, Any?>): ProjectedMeters {
    return mapboxMap.projectedMetersForCoordinate(coordinate.toPoint()).toFLTProjectedMeters()
  }

  override fun coordinateForProjectedMeters(projectedMeters: ProjectedMeters): Map<String?, Any?> {
    return mapboxMap.coordinateForProjectedMeters(projectedMeters.toProjectedMeters()).toMap()
  }

  override fun unproject(
    coordinate: MercatorCoordinate,
    zoomScale: Double
  ): Map<String?, Any?> {
    return mapboxMap.unproject(coordinate.toMercatorCoordinate(), zoomScale).toMap()
  }

  override fun project(
    coordinate: Map<String?, Any?>,
    zoomScale: Double
  ): MercatorCoordinate {
    return mapboxMap.project(coordinate.toPoint(), zoomScale).toFLTMercatorCoordinate()
  }
}