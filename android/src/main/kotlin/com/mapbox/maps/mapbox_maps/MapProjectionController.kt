package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapboxMap
import com.mapbox.maps.pigeons.FLTMapInterfaces

class MapProjectionController(private val mapboxMap: MapboxMap) : FLTMapInterfaces.Projection {
  override fun getMetersPerPixelAtLatitude(latitude: Double, zoom: Double): Double {
    return mapboxMap.getMetersPerPixelAtLatitude(latitude, zoom)
  }

  override fun projectedMetersForCoordinate(coordinate: MutableMap<String, Any>): FLTMapInterfaces.ProjectedMeters {
    return mapboxMap.projectedMetersForCoordinate(coordinate.toPoint()).toFLTProjectedMeters()
  }

  override fun coordinateForProjectedMeters(projectedMeters: FLTMapInterfaces.ProjectedMeters): MutableMap<String, Any> {
    return mapboxMap.coordinateForProjectedMeters(projectedMeters.toProjectedMeters()).toMap().toMutableMap()
  }

  override fun unproject(
    coordinate: FLTMapInterfaces.MercatorCoordinate,
    zoomScale: Double
  ): MutableMap<String, Any> {
    return mapboxMap.unproject(coordinate.toMercatorCoordinate(), zoomScale).toMap().toMutableMap()
  }

  override fun project(
    coordinate: MutableMap<String, Any>,
    zoomScale: Double
  ): FLTMapInterfaces.MercatorCoordinate {
    return mapboxMap.project(coordinate.toPoint(), zoomScale).toFLTMercatorCoordinate()
  }
}