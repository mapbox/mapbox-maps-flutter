package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapboxMap
import com.mapbox.maps.pigeons.FLTMapboxMap

class MapProjectionController(private val mapboxMap: MapboxMap) : FLTMapboxMap.Projection {
  override fun getMetersPerPixelAtLatitude(latitude: Double, zoom: Double): Double {
    return mapboxMap.getMetersPerPixelAtLatitude(latitude, zoom)
  }

  override fun projectedMetersForCoordinate(coordinate: MutableMap<String, Any>): FLTMapboxMap.ProjectedMeters {
    return mapboxMap.projectedMetersForCoordinate(coordinate.toPoint()).toFLTProjectedMeters()
  }

  override fun coordinateForProjectedMeters(projectedMeters: FLTMapboxMap.ProjectedMeters): MutableMap<String, Any> {
    return mapboxMap.coordinateForProjectedMeters(projectedMeters.toProjectedMeters()).toMap().toMutableMap()
  }

  override fun unproject(
    coordinate: FLTMapboxMap.MercatorCoordinate,
    zoomScale: Double
  ): MutableMap<String, Any> {
    return mapboxMap.unproject(coordinate.toMercatorCoordinate(), zoomScale).toMap().toMutableMap()
  }

  override fun project(
    coordinate: MutableMap<String, Any>,
    zoomScale: Double
  ): FLTMapboxMap.MercatorCoordinate {
    return mapboxMap.project(coordinate.toPoint(), zoomScale).toFLTMercatorCoordinate()
  }
}