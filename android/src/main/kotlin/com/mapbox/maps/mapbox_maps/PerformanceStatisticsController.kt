package com.mapbox.maps.mapbox_maps

import com.mapbox.maps.MapboxMap
import com.mapbox.maps.mapbox_maps.pigeons.PerformanceStatisticsListener
import com.mapbox.maps.mapbox_maps.pigeons.PerformanceStatisticsOptions
import com.mapbox.maps.mapbox_maps.pigeons._PerformanceStatisticsApi
import io.flutter.plugin.common.BinaryMessenger

class PerformanceStatisticsController(
  private val mapboxMap: MapboxMap,
  messenger: BinaryMessenger,
  channelSuffix: String
) : _PerformanceStatisticsApi {
  private val performanceStatisticsListener: PerformanceStatisticsListener =
    PerformanceStatisticsListener(messenger, channelSuffix)

  override fun startPerformanceStatisticsCollection(options: PerformanceStatisticsOptions) {
    // stop previous collection to match the behavior with iOS
    mapboxMap.stopPerformanceStatisticsCollection()

    mapboxMap.startPerformanceStatisticsCollection(options.toPerformanceStatisticsOptions()) { statistics ->
      performanceStatisticsListener.onPerformanceStatisticsCollected(statistics.toPerformanceStatistics()) { }
    }
  }

  override fun stopPerformanceStatisticsCollection() {
    mapboxMap.stopPerformanceStatisticsCollection()
  }
}